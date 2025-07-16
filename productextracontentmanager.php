<?php
/**
 * Product Extra Content Manager Module for PrestaShop 8
 * Preserva HTML completo sin prepared statements
 */

if (!defined('_PS_VERSION_')) {
    exit;
}

class ProductExtraContentManager extends Module
{
    public function __construct()
    {
        $this->name = 'productextracontentmanager';
        $this->tab = 'administration';
        $this->version = '1.0.1';
        $this->author = 'Custom Module';
        $this->need_instance = 0;
        $this->ps_versions_compliancy = [
            'min' => '8.0.0',
            'max' => _PS_VERSION_
        ];
        $this->bootstrap = true;

        parent::__construct();

        $this->displayName = $this->l('Product Extra Content Manager');
        $this->description = $this->l('Manage extra content for products in specific hooks');
        $this->confirmUninstall = $this->l('Are you sure you want to uninstall?');
    }

    public function install()
    {
        if (Shop::isFeatureActive()) {
            Shop::setContext(Shop::CONTEXT_ALL);
        }

        return parent::install()
            && $this->registerHook('displayAfterProductThumbs')
            && $this->registerHook('displayProductExtraContent')
            && $this->registerHook('displayProductAdditionalInfo')
            && $this->registerHook('actionAdminControllerSetMedia')
            && $this->installDB();
    }

    public function uninstall()
    {
        return parent::uninstall() && $this->uninstallDB();
    }

public function hookActionAdminControllerSetMedia($params)
{
    if (Tools::getValue('configure') == $this->name) {
        // NO cargar TinyMCE para preservar HTML puro
        $this->context->controller->addCSS($this->_path.'views/css/admin.css');
    }
}

    protected function installDB()
    {
        $sql = array();

        $sql[] = 'CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'productextracontentmanager_content` (
            `id_content` int(11) NOT NULL AUTO_INCREMENT,
            `name` varchar(255) NOT NULL,
            `content_text` LONGTEXT,
            `content_image` varchar(255),
            `image_width` int(11) DEFAULT 0,
            `image_height` int(11) DEFAULT 0,
            `active` tinyint(1) NOT NULL DEFAULT 1,
            `date_add` datetime NOT NULL,
            `date_upd` datetime NOT NULL,
            PRIMARY KEY (`id_content`)
        ) ENGINE=' . _MYSQL_ENGINE_ . ' DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;';

        $sql[] = 'CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'productextracontentmanager_hook` (
            `id_hook_assignment` int(11) NOT NULL AUTO_INCREMENT,
            `id_content` int(11) NOT NULL,
            `hook_name` varchar(100) NOT NULL,
            `position` int(11) NOT NULL DEFAULT 0,
            PRIMARY KEY (`id_hook_assignment`),
            KEY `id_content` (`id_content`)
        ) ENGINE=' . _MYSQL_ENGINE_ . ' DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;';

        $sql[] = 'CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'productextracontentmanager_product` (
            `id_assignment` int(11) NOT NULL AUTO_INCREMENT,
            `id_content` int(11) NOT NULL,
            `id_product` int(11) NOT NULL,
            `position` int(11) NOT NULL DEFAULT 0,
            PRIMARY KEY (`id_assignment`),
            KEY `id_content` (`id_content`),
            KEY `id_product` (`id_product`)
        ) ENGINE=' . _MYSQL_ENGINE_ . ' DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;';

        $sql[] = 'CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'productextracontentmanager_category` (
            `id_assignment` int(11) NOT NULL AUTO_INCREMENT,
            `id_content` int(11) NOT NULL,
            `id_category` int(11) NOT NULL,
            `position` int(11) NOT NULL DEFAULT 0,
            PRIMARY KEY (`id_assignment`),
            KEY `id_content` (`id_content`),
            KEY `id_category` (`id_category`)
        ) ENGINE=' . _MYSQL_ENGINE_ . ' DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;';

        foreach ($sql as $query) {
            if (!Db::getInstance()->execute($query)) {
                return false;
            }
        }

        return true;
    }

    protected function uninstallDB()
    {
        $sql = array();
        $sql[] = 'DROP TABLE IF EXISTS `' . _DB_PREFIX_ . 'productextracontentmanager_content`';
        $sql[] = 'DROP TABLE IF EXISTS `' . _DB_PREFIX_ . 'productextracontentmanager_hook`';
        $sql[] = 'DROP TABLE IF EXISTS `' . _DB_PREFIX_ . 'productextracontentmanager_product`';
        $sql[] = 'DROP TABLE IF EXISTS `' . _DB_PREFIX_ . 'productextracontentmanager_category`';

        foreach ($sql as $query) {
            if (!Db::getInstance()->execute($query)) {
                return false;
            }
        }

        return true;
    }

    public function getContent()
    {
        $output = null;

        if (Tools::isSubmit('submitAddContent')) {
            $this->processAddContent();
        }
        if (Tools::isSubmit('submitEditContent')) {
            $this->processEditContent();
        }
        if (Tools::isSubmit('submitDeleteContent')) {
            $this->processDeleteContent();
        }
        if (Tools::isSubmit('ajax') && Tools::isSubmit('action')) {
            $this->processAjax();
        }

        return $output . $this->displayForm();
    }

    protected function processAjax()
    {
        $action = Tools::getValue('action');
        
        switch ($action) {
            case 'loadContent':
                $this->ajaxProcessLoadContent();
                break;
            case 'searchProducts':
                $this->ajaxProcessSearchProducts();
                break;
            case 'searchCategories':
                $this->ajaxProcessSearchCategories();
                break;
        }
    }

    protected function processAddContent()
    {
        $name = Tools::getValue('name');
        $content_text = $this->getHtmlContent('content_text');
        $active = Tools::getValue('active') ? 1 : 0;
        $hooks = Tools::getValue('hooks', array());
        
        $products_string = Tools::getValue('products');
        $products = !empty($products_string) ? explode(',', $products_string) : array();
        
        $categories_string = Tools::getValue('categories');
        $categories = !empty($categories_string) ? explode(',', $categories_string) : array();

        if (empty($name)) {
            $this->context->controller->errors[] = $this->l('Name is required');
            return false;
        }

        if (empty($hooks)) {
            $this->context->controller->errors[] = $this->l('At least one hook must be selected');
            return false;
        }

        if (empty($products) && empty($categories)) {
            $this->context->controller->errors[] = $this->l('At least one product or category must be selected');
            return false;
        }

        $hasImage = isset($_FILES['content_image']) && $_FILES['content_image']['error'] == 0;
        if (empty($content_text) && !$hasImage) {
            $this->context->controller->errors[] = $this->l('Content text or image is required');
            return false;
        }

        $image_name = '';
        $image_width = 0;
        $image_height = 0;
        
        if ($hasImage) {
            $image_result = $this->processImageUpload();
            if ($image_result) {
                $image_name = $image_result['filename'];
                $image_width = (int)Tools::getValue('image_width', 0);
                $image_height = (int)Tools::getValue('image_height', 0);
            } else {
                return false;
            }
        }

        $sql = 'INSERT INTO `' . _DB_PREFIX_ . 'productextracontentmanager_content` 
                (`name`, `content_text`, `content_image`, `image_width`, `image_height`, `active`, `date_add`, `date_upd`) 
                VALUES ("' . pSQL($name) . '", "' . pSQL($content_text, false) . '", "' . pSQL($image_name) . '", 
                ' . (int)$image_width . ', ' . (int)$image_height . ', ' . (int)$active . ', NOW(), NOW())';

        if (Db::getInstance()->execute($sql)) {
            $id_content = Db::getInstance()->Insert_ID();
            
            foreach ($hooks as $hook) {
                $position = (int)Tools::getValue('hook_position_' . $hook, 0);
                Db::getInstance()->execute('INSERT INTO `' . _DB_PREFIX_ . 'productextracontentmanager_hook` 
                    (`id_content`, `hook_name`, `position`) VALUES (' . (int)$id_content . ', "' . pSQL($hook) . '", ' . (int)$position . ')');
            }

            if (!empty($products)) {
                foreach ($products as $id_product) {
                    $id_product = (int)trim($id_product);
                    if ($id_product > 0) {
                        $position = (int)Tools::getValue('product_position_' . $id_product, 0);
                        Db::getInstance()->execute('INSERT INTO `' . _DB_PREFIX_ . 'productextracontentmanager_product` 
                            (`id_content`, `id_product`, `position`) VALUES (' . (int)$id_content . ', ' . (int)$id_product . ', ' . (int)$position . ')');
                    }
                }
            }

            if (!empty($categories)) {
                foreach ($categories as $id_category) {
                    $id_category = (int)trim($id_category);
                    if ($id_category > 0) {
                        $position = (int)Tools::getValue('category_position_' . $id_category, 0);
                        Db::getInstance()->execute('INSERT INTO `' . _DB_PREFIX_ . 'productextracontentmanager_category` 
                            (`id_content`, `id_category`, `position`) VALUES (' . (int)$id_content . ', ' . (int)$id_category . ', ' . (int)$position . ')');
                    }
                }
            }

            $this->context->controller->confirmations[] = $this->l('Content added successfully');
            return true;
        }

        $this->context->controller->errors[] = $this->l('Error adding content');
        return false;
    }

    protected function processEditContent()
    {
        $id_content = (int)Tools::getValue('id_content');
        $name = Tools::getValue('name');
        $content_text = $this->getHtmlContent('content_text');
        $active = Tools::getValue('active') ? 1 : 0;
        $hooks = Tools::getValue('hooks', array());
        
        $products_string = Tools::getValue('products');
        $products = !empty($products_string) ? explode(',', $products_string) : array();
        
        $categories_string = Tools::getValue('categories');
        $categories = !empty($categories_string) ? explode(',', $categories_string) : array();

        if (empty($name)) {
            $this->context->controller->errors[] = $this->l('Name is required');
            return false;
        }

        if (!$id_content) {
            $this->context->controller->errors[] = $this->l('Invalid content ID');
            return false;
        }

        if (empty($hooks)) {
            $this->context->controller->errors[] = $this->l('At least one hook must be selected');
            return false;
        }

        if (empty($products) && empty($categories)) {
            $this->context->controller->errors[] = $this->l('At least one product or category must be selected');
            return false;
        }

        $hasImage = isset($_FILES['content_image']) && $_FILES['content_image']['error'] == 0;
        $currentImage = Db::getInstance()->getValue('SELECT `content_image` FROM `' . _DB_PREFIX_ . 'productextracontentmanager_content` WHERE `id_content` = ' . (int)$id_content);
        
        if (empty($content_text) && !$hasImage && empty($currentImage)) {
            $this->context->controller->errors[] = $this->l('Content text or image is required');
            return false;
        }

        $image_width = (int)Tools::getValue('image_width', 0);
        $image_height = (int)Tools::getValue('image_height', 0);
        
        if ($hasImage) {
            $image_result = $this->processImageUpload();
            if ($image_result) {
                if ($currentImage && file_exists(_PS_MODULE_DIR_ . $this->name . '/images/' . $currentImage)) {
                    unlink(_PS_MODULE_DIR_ . $this->name . '/images/' . $currentImage);
                }
            } else {
                return false;
            }
        }

        $sql = 'UPDATE `' . _DB_PREFIX_ . 'productextracontentmanager_content` SET 
                `name` = "' . pSQL($name) . '", 
                `content_text` = "' . pSQL($content_text, false) . '", 
                `image_width` = ' . (int)$image_width . ', 
                `image_height` = ' . (int)$image_height . ', 
                `active` = ' . (int)$active . ', 
                `date_upd` = NOW()';

        if ($hasImage && isset($image_result)) {
            $sql .= ', `content_image` = "' . pSQL($image_result['filename']) . '"';
        }

        $sql .= ' WHERE `id_content` = ' . (int)$id_content;

        if (Db::getInstance()->execute($sql)) {
            Db::getInstance()->execute('DELETE FROM `' . _DB_PREFIX_ . 'productextracontentmanager_hook` WHERE `id_content` = ' . (int)$id_content);
            Db::getInstance()->execute('DELETE FROM `' . _DB_PREFIX_ . 'productextracontentmanager_product` WHERE `id_content` = ' . (int)$id_content);
            Db::getInstance()->execute('DELETE FROM `' . _DB_PREFIX_ . 'productextracontentmanager_category` WHERE `id_content` = ' . (int)$id_content);
            
            foreach ($hooks as $hook) {
                $position = (int)Tools::getValue('hook_position_' . $hook, 0);
                Db::getInstance()->execute('INSERT INTO `' . _DB_PREFIX_ . 'productextracontentmanager_hook` 
                    (`id_content`, `hook_name`, `position`) VALUES (' . (int)$id_content . ', "' . pSQL($hook) . '", ' . (int)$position . ')');
            }

            if (!empty($products)) {
                foreach ($products as $id_product) {
                    $id_product = (int)trim($id_product);
                    if ($id_product > 0) {
                        $position = (int)Tools::getValue('product_position_' . $id_product, 0);
                        Db::getInstance()->execute('INSERT INTO `' . _DB_PREFIX_ . 'productextracontentmanager_product` 
                            (`id_content`, `id_product`, `position`) VALUES (' . (int)$id_content . ', ' . (int)$id_product . ', ' . (int)$position . ')');
                    }
                }
            }

            if (!empty($categories)) {
                foreach ($categories as $id_category) {
                    $id_category = (int)trim($id_category);
                    if ($id_category > 0) {
                        $position = (int)Tools::getValue('category_position_' . $id_category, 0);
                        Db::getInstance()->execute('INSERT INTO `' . _DB_PREFIX_ . 'productextracontentmanager_category` 
                            (`id_content`, `id_category`, `position`) VALUES (' . (int)$id_content . ', ' . (int)$id_category . ', ' . (int)$position . ')');
                    }
                }
            }

            $this->context->controller->confirmations[] = $this->l('Content updated successfully');
            return true;
        }

        $this->context->controller->errors[] = $this->l('Error updating content');
        return false;
    }

protected function getHtmlContent($field_name)
{
    // MÉTODO 1: Obtener directamente del $_POST sin filtros
    if (isset($_POST[$field_name])) {
        return $_POST[$field_name];
    }
    
    // MÉTODO 2: Obtener del input crudo
    $input = file_get_contents('php://input');
    if ($input) {
        parse_str($input, $data);
        if (isset($data[$field_name])) {
            return $data[$field_name];
        }
    }
    
    // MÉTODO 3: Como último recurso, sin filtros
    return Tools::getValue($field_name, '', false);
}

    protected function processDeleteContent()
    {
        $id_content = (int)Tools::getValue('id_content');

        if (!$id_content) {
            $this->context->controller->errors[] = $this->l('Invalid content ID');
            return false;
        }

        $image = Db::getInstance()->getValue('SELECT `content_image` FROM `' . _DB_PREFIX_ . 'productextracontentmanager_content` WHERE `id_content` = ' . (int)$id_content);
        
        $success = true;
        $success &= Db::getInstance()->execute('DELETE FROM `' . _DB_PREFIX_ . 'productextracontentmanager_hook` WHERE `id_content` = ' . (int)$id_content);
        $success &= Db::getInstance()->execute('DELETE FROM `' . _DB_PREFIX_ . 'productextracontentmanager_product` WHERE `id_content` = ' . (int)$id_content);
        $success &= Db::getInstance()->execute('DELETE FROM `' . _DB_PREFIX_ . 'productextracontentmanager_category` WHERE `id_content` = ' . (int)$id_content);
        $success &= Db::getInstance()->execute('DELETE FROM `' . _DB_PREFIX_ . 'productextracontentmanager_content` WHERE `id_content` = ' . (int)$id_content);

        if ($success) {
            if ($image && file_exists(_PS_MODULE_DIR_ . $this->name . '/images/' . $image)) {
                unlink(_PS_MODULE_DIR_ . $this->name . '/images/' . $image);
            }
            
            $this->context->controller->confirmations[] = $this->l('Content deleted successfully');
            return true;
        }

        $this->context->controller->errors[] = $this->l('Error deleting content');
        return false;
    }

    protected function processImageUpload()
    {
        $upload_dir = _PS_MODULE_DIR_ . $this->name . '/images/';
        
        if (!file_exists($upload_dir)) {
            mkdir($upload_dir, 0755, true);
        }

        $allowed_types = array('image/jpeg', 'image/png', 'image/gif', 'image/webp');
        $file_type = $_FILES['content_image']['type'];
        
        if (!in_array($file_type, $allowed_types)) {
            $this->context->controller->errors[] = $this->l('Invalid image type. Allowed: JPG, PNG, GIF, WEBP');
            return false;
        }

        if ($_FILES['content_image']['size'] > 5 * 1024 * 1024) {
            $this->context->controller->errors[] = $this->l('Image file is too large. Maximum size: 5MB');
            return false;
        }

        $file_extension = pathinfo($_FILES['content_image']['name'], PATHINFO_EXTENSION);
        $filename = uniqid() . '.' . $file_extension;
        $target_file = $upload_dir . $filename;

        if (move_uploaded_file($_FILES['content_image']['tmp_name'], $target_file)) {
            return array('filename' => $filename);
        }

        $this->context->controller->errors[] = $this->l('Error uploading image');
        return false;
    }

    protected function displayForm()
    {
        $contents = $this->getContents();
        
        $this->context->smarty->assign(array(
            'contents' => $contents,
            'module_dir' => $this->_path,
            'module_name' => $this->name,
            'products' => $this->getProducts(),
            'categories' => $this->getCategories(),
            'category_tree' => $this->getCategoryTree(),
            'hooks' => $this->getAvailableHooks(),
            'token' => Tools::getAdminTokenLite('AdminModules'),
            'iso' => $this->context->language->iso_code,
            'ad' => _PS_ADMIN_DIR_,
            'current_index' => AdminController::$currentIndex,
            'module_instance' => $this
        ));

        return $this->display(__FILE__, 'views/templates/admin/configure.tpl');
    }

    protected function getContents()
    {
        $sql = 'SELECT * FROM `' . _DB_PREFIX_ . 'productextracontentmanager_content` ORDER BY `date_add` DESC';
        $contents = Db::getInstance()->executeS($sql);
        
        foreach ($contents as &$content) {
            $content['hooks'] = Db::getInstance()->executeS('SELECT * FROM `' . _DB_PREFIX_ . 'productextracontentmanager_hook` WHERE `id_content` = ' . (int)$content['id_content']);
            
            $content['products'] = Db::getInstance()->executeS('SELECT p.*, pl.name FROM `' . _DB_PREFIX_ . 'productextracontentmanager_product` p 
                LEFT JOIN `' . _DB_PREFIX_ . 'product_lang` pl ON p.id_product = pl.id_product AND pl.id_lang = ' . (int)$this->context->language->id . '
                WHERE p.id_content = ' . (int)$content['id_content']);
            
            $content['categories'] = Db::getInstance()->executeS('SELECT c.*, cl.name FROM `' . _DB_PREFIX_ . 'productextracontentmanager_category` c 
                LEFT JOIN `' . _DB_PREFIX_ . 'category_lang` cl ON c.id_category = cl.id_category AND cl.id_lang = ' . (int)$this->context->language->id . '
                WHERE c.id_content = ' . (int)$content['id_content']);
        }
        
        return $contents;
    }

    protected function getProducts()
    {
        $sql = 'SELECT p.id_product, pl.name 
                FROM `' . _DB_PREFIX_ . 'product` p 
                LEFT JOIN `' . _DB_PREFIX_ . 'product_lang` pl ON p.id_product = pl.id_product 
                WHERE pl.id_lang = ' . (int)$this->context->language->id . ' 
                AND p.active = 1 
                ORDER BY pl.name LIMIT 50';
        return Db::getInstance()->executeS($sql);
    }

    protected function getCategories()
    {
        $sql = 'SELECT c.id_category, cl.name 
                FROM `' . _DB_PREFIX_ . 'category` c 
                LEFT JOIN `' . _DB_PREFIX_ . 'category_lang` cl ON c.id_category = cl.id_category 
                WHERE cl.id_lang = ' . (int)$this->context->language->id . ' 
                AND c.active = 1 
                AND c.id_category != 1
                ORDER BY cl.name';
        return Db::getInstance()->executeS($sql);
    }

    protected function getCategoryTree()
    {
        $categories = $this->getCategoriesForTree();
        return $this->buildCategoryTreeAdvanced($categories);
    }

    protected function getCategoriesForTree($id_parent = 2, $level = 0)
    {
        $sql = 'SELECT c.id_category, cl.name, c.id_parent,
                (SELECT COUNT(*) FROM `' . _DB_PREFIX_ . 'category` cc WHERE cc.id_parent = c.id_category AND cc.active = 1) as has_children
                FROM `' . _DB_PREFIX_ . 'category` c 
                LEFT JOIN `' . _DB_PREFIX_ . 'category_lang` cl ON c.id_category = cl.id_category 
                WHERE cl.id_lang = ' . (int)$this->context->language->id . ' 
                AND c.active = 1 
                AND c.id_parent = ' . (int)$id_parent . '
                ORDER BY cl.name';
        
        $categories = Db::getInstance()->executeS($sql);
        $result = array();
        
        foreach ($categories as $category) {
            $category['level'] = $level;
            $category['children'] = $this->getCategoriesForTree($category['id_category'], $level + 1);
            $result[] = $category;
        }
        
        return $result;
    }

    protected function buildCategoryTreeAdvanced($categories, $level = 0)
    {
        if (empty($categories)) {
            return '';
        }

        $html = '<ul class="category-tree-list' . ($level == 0 ? ' root-level' : '') . '">';
        
        foreach ($categories as $category) {
            $hasChildren = !empty($category['children']);
            $expandClass = $hasChildren ? 'expandable' : 'leaf';
            $iconClass = $hasChildren ? 'folder' : 'item';
            
            $html .= '<li class="category-node ' . $expandClass . '" data-id="' . $category['id_category'] . '">';
            
            if ($hasChildren) {
                $html .= '<span class="tree-toggle" onclick="toggleCategory(this)">+</span>';
            } else {
                $html .= '<span class="tree-spacer">&nbsp;</span>';
            }
            
            $html .= '<span class="tree-icon ' . $iconClass . '"></span>';
            
            $html .= '<label class="category-label">';
            $html .= '<input type="checkbox" name="category_checkbox" value="' . $category['id_category'] . '" onchange="updateSelectedCategories()">';
            $html .= '<span class="category-name">' . $category['name'] . ' <small>(ID: ' . $category['id_category'] . ')</small></span>';
            $html .= '</label>';
            
            if ($hasChildren) {
                $html .= '<div class="category-children" style="display: none;">';
                $html .= $this->buildCategoryTreeAdvanced($category['children'], $level + 1);
                $html .= '</div>';
            }
            
            $html .= '</li>';
        }
        
        $html .= '</ul>';
        return $html;
    }

    protected function getAvailableHooks()
    {
        return array(
            'displayAfterProductThumbs' => 'After Product Thumbnails',
            'displayProductExtraContent' => 'Product Extra Content',
            'displayProductAdditionalInfo' => 'Product Additional Info'
        );
    }

    public function ajaxProcessLoadContent()
    {
        $id_content = (int)Tools::getValue('id_content');
        
        if (!$id_content) {
            header('Content-Type: application/json');
            echo json_encode(array('success' => false, 'error' => 'Invalid content ID'));
            exit;
        }

        $content = Db::getInstance()->getRow('SELECT * FROM `' . _DB_PREFIX_ . 'productextracontentmanager_content` WHERE `id_content` = ' . (int)$id_content);
        
        if (!$content) {
            header('Content-Type: application/json');
            echo json_encode(array('success' => false, 'error' => 'Content not found'));
            exit;
        }

        $hooks = Db::getInstance()->executeS('SELECT * FROM `' . _DB_PREFIX_ . 'productextracontentmanager_hook` WHERE `id_content` = ' . (int)$id_content);
        
        $products = Db::getInstance()->executeS('SELECT p.*, pl.name FROM `' . _DB_PREFIX_ . 'productextracontentmanager_product` p 
            LEFT JOIN `' . _DB_PREFIX_ . 'product_lang` pl ON p.id_product = pl.id_product AND pl.id_lang = ' . (int)$this->context->language->id . '
            WHERE p.id_content = ' . (int)$id_content);
        
        $categories = Db::getInstance()->executeS('SELECT * FROM `' . _DB_PREFIX_ . 'productextracontentmanager_category` WHERE `id_content` = ' . (int)$id_content);

        header('Content-Type: application/json');
        echo json_encode(array(
            'success' => true,
            'content' => $content,
            'hooks' => $hooks,
            'products' => $products,
            'categories' => $categories,
            'module_dir' => $this->_path
        ));
        exit;
    }

    public function ajaxProcessSearchProducts()
    {
        $query = Tools::getValue('q');
        
       if (strlen($query) < 2) {
           header('Content-Type: application/json');
           echo json_encode(array());
           exit;
       }
       
       $sql = 'SELECT c.id_category, cl.name 
               FROM `' . _DB_PREFIX_ . 'category` c 
               LEFT JOIN `' . _DB_PREFIX_ . 'category_lang` cl ON c.id_category = cl.id_category 
               WHERE cl.id_lang = ' . (int)$this->context->language->id . ' 
               AND c.active = 1 
               AND c.id_category != 1
               AND cl.name LIKE "%' . pSQL($query) . '%"
               ORDER BY cl.name LIMIT 20';
       
       $categories = Db::getInstance()->executeS($sql);
       
       header('Content-Type: application/json');
       echo json_encode($categories ? $categories : array());
       exit;
   }

   public function hookDisplayAfterProductThumbs($params)
   {
       return $this->displayHookContent('displayAfterProductThumbs', $params);
   }

   public function hookDisplayProductExtraContent($params)
   {
       return $this->displayHookContent('displayProductExtraContent', $params);
   }

   public function hookDisplayProductAdditionalInfo($params)
   {
       return $this->displayHookContent('displayProductAdditionalInfo', $params);
   }

   protected function displayHookContent($hook_name, $params)
   {
       $product = $params['product'];
       $id_product = $product->id;
       
       $product_content = $this->getContentForProduct($id_product, $hook_name);
       
       if (!empty($product_content)) {
           $content = $product_content;
       } else {
           $content = $this->getContentForCategory($id_product, $hook_name);
       }
       
       if (empty($content)) {
           return '';
       }

       $unique_content = array();
       $seen_ids = array();
       
       foreach ($content as $item) {
           if (!in_array($item['id_content'], $seen_ids)) {
               $unique_content[] = $item;
               $seen_ids[] = $item['id_content'];
           }
       }

       $this->context->smarty->assign(array(
           'content' => $unique_content,
           'module_dir' => $this->_path,
           'hook_name' => $hook_name
       ));

       return $this->display(__FILE__, 'views/templates/hook/display_content.tpl');
   }

   protected function getContentForProduct($id_product, $hook_name)
   {
       $sql = 'SELECT c.*, cp.position, ch.position as hook_position
               FROM `' . _DB_PREFIX_ . 'productextracontentmanager_content` c
               INNER JOIN `' . _DB_PREFIX_ . 'productextracontentmanager_product` cp ON c.id_content = cp.id_content
               INNER JOIN `' . _DB_PREFIX_ . 'productextracontentmanager_hook` ch ON c.id_content = ch.id_content
               WHERE cp.id_product = ' . (int)$id_product . ' 
               AND ch.hook_name = "' . pSQL($hook_name) . '"
               AND c.active = 1
               ORDER BY ch.position ASC, cp.position ASC, c.date_add ASC';
       
       return Db::getInstance()->executeS($sql);
   }

   protected function getContentForCategory($id_product, $hook_name)
   {
       $sql = 'SELECT c.*, cc.position, ch.position as hook_position
               FROM `' . _DB_PREFIX_ . 'productextracontentmanager_content` c
               INNER JOIN `' . _DB_PREFIX_ . 'productextracontentmanager_category` cc ON c.id_content = cc.id_content
               INNER JOIN `' . _DB_PREFIX_ . 'productextracontentmanager_hook` ch ON c.id_content = ch.id_content
               INNER JOIN `' . _DB_PREFIX_ . 'category_product` cp ON cc.id_category = cp.id_category
               WHERE cp.id_product = ' . (int)$id_product . ' 
               AND ch.hook_name = "' . pSQL($hook_name) . '"
               AND c.active = 1
               ORDER BY ch.position ASC, cc.position ASC, c.date_add ASC';
       
       return Db::getInstance()->executeS($sql);
   }
}