{*
* Product Extra Content Manager - TEMPLATE COMPLETO Y CORREGIDO
*}

<div class="panel">
    <h3><i class="icon-cogs"></i> {l s='Product Extra Content Manager' mod='productextracontentmanager'}</h3>
    
    <div class="row">
        <div class="col-lg-12">
            <div class="alert alert-info">
                <p><i class="icon-info-circle"></i> {l s='This module allows you to add extra content (text and images) to specific hooks on product pages.' mod='productextracontentmanager'}</p>
                <p><strong>{l s='Priority:' mod='productextracontentmanager'}</strong> {l s='Individual products have priority over categories.' mod='productextracontentmanager'}</p>
                <p><strong>{l s='HTML Support:' mod='productextracontentmanager'}</strong> {l s='The editor preserves all HTML code including custom classes and attributes.' mod='productextracontentmanager'}</p>
            </div>
        </div>
    </div>
</div>

<!-- Lista de contenidos existentes -->
<div class="panel">
    <h3><i class="icon-list"></i> {l s='Existing Contents' mod='productextracontentmanager'}</h3>
    
    <div class="table-responsive">
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>{l s='Name' mod='productextracontentmanager'}</th>
                    <th>{l s='Content Type' mod='productextracontentmanager'}</th>
                    <th>{l s='Image' mod='productextracontentmanager'}</th>
                    <th>{l s='Hooks' mod='productextracontentmanager'}</th>
                    <th>{l s='Products' mod='productextracontentmanager'}</th>
                    <th>{l s='Categories' mod='productextracontentmanager'}</th>
                    <th>{l s='Status' mod='productextracontentmanager'}</th>
                    <th>{l s='Actions' mod='productextracontentmanager'}</th>
                </tr>
            </thead>
            <tbody>
                {if $contents}
                    {foreach $contents as $content}
                    <tr>
                        <td><strong>{$content.name|escape:'html':'UTF-8'}</strong></td>
                        <td>
                            {if $content.content_text && $content.content_image}
                                <span class="label label-primary">{l s='Text + Image' mod='productextracontentmanager'}</span>
                            {elseif $content.content_text}
                                <span class="label label-info">{l s='Text Only' mod='productextracontentmanager'}</span>
                            {elseif $content.content_image}
                                <span class="label label-warning">{l s='Image Only' mod='productextracontentmanager'}</span>
                            {else}
                                <span class="label label-default">{l s='Empty' mod='productextracontentmanager'}</span>
                            {/if}
                        </td>
                        <td>
                            {if $content.content_image}
                                <img src="{$module_dir}images/{$content.content_image}" alt="{$content.name}" style="max-width: 50px; max-height: 50px;">
                            {else}
                                <em>{l s='No image' mod='productextracontentmanager'}</em>
                            {/if}
                        </td>
                        <td>
                            {if $content.hooks}
                                {foreach $content.hooks as $hook}
                                    <span class="label label-default">{$hook.hook_name}</span>
                                {/foreach}
                            {else}
                                <em>{l s='No hooks assigned' mod='productextracontentmanager'}</em>
                            {/if}
                        </td>
                        <td>
                            {if $content.products}
                                <span class="badge badge-info">{$content.products|count} {l s='products' mod='productextracontentmanager'}</span>
                            {else}
                                <em>{l s='No products' mod='productextracontentmanager'}</em>
                            {/if}
                        </td>
                        <td>
                            {if $content.categories}
                                <span class="badge badge-success">{$content.categories|count} {l s='categories' mod='productextracontentmanager'}</span>
                            {else}
                                <em>{l s='No categories' mod='productextracontentmanager'}</em>
                            {/if}
                        </td>
                        <td>
                            {if $content.active}
                                <span class="label label-success">{l s='Active' mod='productextracontentmanager'}</span>
                            {else}
                                <span class="label label-danger">{l s='Inactive' mod='productextracontentmanager'}</span>
                            {/if}
                        </td>
                        <td>
                            <div class="btn-group">
                                <button class="btn btn-default btn-sm edit-content-btn" data-id="{$content.id_content}">
                                    <i class="icon-edit"></i> {l s='Edit' mod='productextracontentmanager'}
                                </button>
                                <button class="btn btn-danger btn-sm delete-content-btn" data-id="{$content.id_content}">
                                    <i class="icon-trash"></i> {l s='Delete' mod='productextracontentmanager'}
                                </button>
                            </div>
                        </td>
                    </tr>
                    {/foreach}
                {else}
                    <tr>
                        <td colspan="8" class="text-center">
                            <div class="alert alert-warning" style="margin: 20px;">
                                <i class="icon-warning-sign"></i> {l s='No content created yet. Click "Add New Content" to get started!' mod='productextracontentmanager'}
                            </div>
                        </td>
                    </tr>
                {/if}
            </tbody>
        </table>
    </div>
    
    <div class="panel-footer">
        <button class="btn btn-primary btn-lg" id="add-new-content">
            <i class="icon-plus"></i> {l s='Add New Content' mod='productextracontentmanager'}
        </button>
    </div>
</div>

<!-- Formulario para agregar/editar contenido -->
<div class="panel panel-featured" id="content-form" style="display: none;">
    <div class="panel-heading">
        <h3><i class="icon-plus"></i> <span id="form-title">{l s='Add New Content' mod='productextracontentmanager'}</span></h3>
    </div>
    
    <form id="content-form-data" method="post" enctype="multipart/form-data" class="form-horizontal">
        <input type="hidden" name="submitAddContent" value="1" id="submit-type">
        <input type="hidden" name="id_content" value="" id="content-id">
        
        <div class="panel-body">
            <!-- Nombre -->
            <div class="form-group">
                <label class="control-label col-lg-3" for="name">
                    <span class="label-tooltip" data-toggle="tooltip" title="{l s='Internal name to identify this content' mod='productextracontentmanager'}">
                        {l s='Name' mod='productextracontentmanager'} <span class="required">*</span>
                    </span>
                </label>
                <div class="col-lg-9">
                    <input type="text" name="name" id="name" class="form-control" required placeholder="{l s='Enter a descriptive name...' mod='productextracontentmanager'}">
                </div>
            </div>
            
            <!-- CONTENIDO DE TEXTO - CRÍTICO PARA PRESERVAR HTML -->
            <div class="form-group">
                <label class="control-label col-lg-3" for="content_text">
                    <span class="label-tooltip" data-toggle="tooltip" title="{l s='HTML content that will be displayed to customers. All HTML code will be preserved.' mod='productextracontentmanager'}">
                        {l s='HTML Content' mod='productextracontentmanager'}
                    </span>
                </label>
                <div class="col-lg-9">
                    <!-- CRITICAL: Configuración específica para preservar HTML -->
                    <div class="html-editor-container">
                        <textarea 
    name="content_text" 
    id="content_text" 
    class="form-control" 
    rows="20" 
    cols="100"
    style="font-family: 'Courier New', monospace; font-size: 13px; line-height: 1.4; white-space: pre;"
    placeholder="Pega tu código HTML aquí. Los saltos de línea y el HTML se preservarán exactamente."
></textarea>
                    </div>
                    <div class="help-block">
                        <i class="icon-code"></i> {l s='You can paste HTML code directly. Custom classes, IDs, and attributes will be preserved.' mod='productextracontentmanager'}
                        <br>
                        <strong>{l s='Example:' mod='productextracontentmanager'}</strong> <code>&lt;div class="pv_single"&gt;&lt;img src="image.jpg"&gt;&lt;span class="pv_label"&gt;Text&lt;/span&gt;&lt;/div&gt;</code>
                    </div>
                    
                    <!-- Preview del contenido -->
                    <div class="html-preview-container" style="display: none; margin-top: 15px;">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h4 class="panel-title">
                                    <i class="icon-eye"></i> {l s='Preview' mod='productextracontentmanager'}
                                    <button type="button" class="btn btn-xs btn-default pull-right" onclick="togglePreview()">
                                        {l s='Hide Preview' mod='productextracontentmanager'}
                                    </button>
                                </h4>
                            </div>
                            <div class="panel-body" id="content-preview">
                                <!-- Preview content will be inserted here -->
                            </div>
                        </div>
                    </div>
                    
                    <!-- Botón para mostrar/ocultar preview -->
                    <button type="button" class="btn btn-default btn-sm" onclick="togglePreview()" style="margin-top: 10px;">
                        <i class="icon-eye"></i> {l s='Toggle Preview' mod='productextracontentmanager'}
                    </button>
                </div>
            </div>
            
            <!-- Imagen -->
            <div class="form-group">
                <label class="control-label col-lg-3" for="content_image">
                    <span class="label-tooltip" data-toggle="tooltip" title="{l s='Upload an image to accompany your content' mod='productextracontentmanager'}">
                        {l s='Image' mod='productextracontentmanager'}
                    </span>
                </label>
                <div class="col-lg-9">
                    <div class="image-upload-container">
                        <input type="file" name="content_image" id="content_image" accept="image/*" class="form-control">
                        <p class="help-block">
                            <i class="icon-picture"></i> {l s='Supported formats: JPG, PNG, GIF, WEBP (max 5MB)' mod='productextracontentmanager'}
                        </p>
                        <div id="current-image" style="display: none; margin-top: 15px;">
                            <div class="current-image-preview">
                                <strong>{l s='Current Image:' mod='productextracontentmanager'}</strong>
                                <img src="" alt="" class="img-thumbnail">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Dimensiones de Imagen -->
            <div class="form-group">
                <label class="control-label col-lg-3">
                    <span class="label-tooltip" data-toggle="tooltip" title="{l s='Specify custom dimensions for your image' mod='productextracontentmanager'}">
                        {l s='Image Dimensions' mod='productextracontentmanager'}
                    </span>
                </label>
                <div class="col-lg-9">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="input-group">
                                <input type="number" name="image_width" id="image_width" class="form-control" placeholder="{l s='Width' mod='productextracontentmanager'}" min="0">
                                <span class="input-group-addon">px</span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="input-group">
                                <input type="number" name="image_height" id="image_height" class="form-control" placeholder="{l s='Height' mod='productextracontentmanager'}" min="0">
                                <span class="input-group-addon">px</span>
                            </div>
                        </div>
                    </div>
                    <p class="help-block">
                        <i class="icon-resize-horizontal"></i> {l s='Leave empty for original size. Images are automatically responsive.' mod='productextracontentmanager'}
                    </p>
                </div>
            </div>
            
            <!-- Hooks -->
            <div class="form-group">
                <label class="control-label col-lg-3">
                    <span class="label-tooltip" data-toggle="tooltip" title="{l s='Choose where this content will appear on product pages' mod='productextracontentmanager'}">
                        {l s='Display Hooks' mod='productextracontentmanager'} <span class="required">*</span>
                    </span>
                </label>
                <div class="col-lg-9">
                    <div class="hooks-container">
                        {foreach $hooks as $hook_name => $hook_label}
                        <div class="hook-item">
                            <div class="checkbox">
                                <label>
                                    <input type="checkbox" name="hooks[]" value="{$hook_name}" class="hook-checkbox">
                                    <strong>{$hook_label}</strong>
                                    <small class="text-muted">({$hook_name})</small>
                                </label>
                            </div>
                            <div class="position-group" style="display: none;">
                                <label class="sr-only">{l s='Position for' mod='productextracontentmanager'} {$hook_label}</label>
                                <input type="number" name="hook_position_{$hook_name}" placeholder="{l s='Position' mod='productextracontentmanager'}" class="form-control hook-position" min="0" disabled>
                                <small class="help-text">{l s='Lower number = appears first' mod='productextracontentmanager'}</small>
                            </div>
                        </div>
                        {/foreach}
                    </div>
                    <p class="help-block">
                        <i class="icon-map-marker"></i> {l s='Select where you want this content to appear. You can choose multiple hooks.' mod='productextracontentmanager'}
                    </p>
                </div>
            </div>
            
            <!-- Productos -->
            <div class="form-group">
                <label class="control-label col-lg-3">
                    <span class="label-tooltip" data-toggle="tooltip" title="{l s='Assign this content to specific products' mod='productextracontentmanager'}">
                        {l s='Products' mod='productextracontentmanager'}
                    </span>
                </label>
                <div class="col-lg-9">
                    <div class="products-selector">
                        <div class="search-container">
                            <div class="input-group">
                                <input type="text" id="product-search" class="form-control" placeholder="{l s='Search for products by name or ID...' mod='productextracontentmanager'}" autocomplete="off">
                                <span class="input-group-addon"><i class="icon-search"></i></span>
                            </div>
                            <div id="product-search-results" class="search-results"></div>
                        </div>
                        <div id="selected-products" class="selected-items">
                            <div class="selected-items-header" style="display: none;">
                                <strong>{l s='Selected Products:' mod='productextracontentmanager'}</strong>
                            </div>
                        </div>
                        <input type="hidden" name="products" id="products-input" value="">
                    </div>
                    <p class="help-block">
                        <i class="icon-shopping-cart"></i> {l s='Start typing to search for products. Selected products will appear below.' mod='productextracontentmanager'}
                    </p>
                </div>
            </div>
            
            <!-- Categorías -->
            <div class="form-group">
                <label class="control-label col-lg-3">
                    <span class="label-tooltip" data-toggle="tooltip" title="{l s='Assign this content to all products in selected categories' mod='productextracontentmanager'}">
                        {l s='Categories' mod='productextracontentmanager'}
                    </span>
                </label>
                <div class="col-lg-9">
                    <div class="categories-selector">
                        <div class="category-tree-container">
                            <div class="category-tree-header">
                                <div class="btn-toolbar">
                                    <div class="btn-group">
                                        <button type="button" class="btn btn-sm btn-default" onclick="return expandAllCategories()">
                                            <i class="icon-plus"></i> {l s='Expand All' mod='productextracontentmanager'}
                                        </button>
                                        <button type="button" class="btn btn-sm btn-default" onclick="return collapseAllCategories()">
                                            <i class="icon-minus"></i> {l s='Collapse All' mod='productextracontentmanager'}
                                        </button>
                                    </div>
                                    <div class="btn-group">
                                        <button type="button" class="btn btn-sm btn-success" onclick="return checkAllCategories()">
                                            <i class="icon-check"></i> {l s='Check All' mod='productextracontentmanager'}
                                        </button>
                                        <button type="button" class="btn btn-sm btn-warning" onclick="return uncheckAllCategories()">
                                            <i class="icon-remove"></i> {l s='Uncheck All' mod='productextracontentmanager'}
                                        </button>
                                    </div>
                                </div>
                                <div class="category-search">
                                    <div class="input-group">
                                        <input type="text" class="form-control input-sm" placeholder="{l s='Search categories...' mod='productextracontentmanager'}" onkeyup="searchCategories(this.value)">
                                        <span class="input-group-addon"><i class="icon-search"></i></span>
                                    </div>
                                </div>
                            </div>
                            <div id="category-tree" class="category-tree">
                                {$category_tree nofilter}
                            </div>
                        </div>
                        <input type="hidden" name="categories" id="selected-categories" value="">
                    </div>
                    <p class="help-block">
                        <i class="icon-sitemap"></i> {l s='Content will be shown on all products within selected categories.' mod='productextracontentmanager'}
                    </p>
                </div>
            </div>
            
            <!-- Estado -->
            <div class="form-group">
                <label class="control-label col-lg-3">
                    <span class="label-tooltip" data-toggle="tooltip" title="{l s='Enable or disable this content' mod='productextracontentmanager'}">
                        {l s='Status' mod='productextracontentmanager'}
                    </span>
                </label>
                <div class="col-lg-9">
                    <span class="switch prestashop-switch fixed-width-lg">
    <input type="radio" name="active" id="active_on" value="1" checked="checked">
    <label for="active_on">{l s='Yes' mod='productextracontentmanager'}</label>
    <input type="radio" name="active" id="active_off" value="0">
    <label for="active_off">{l s='No' mod='productextracontentmanager'}</label>
    <a class="slide-button btn"></a>
</span>
                    <p class="help-block">
                        <i class="icon-eye"></i> {l s='Only active content will be displayed on your store.' mod='productextracontentmanager'}
                    </p>
                </div>
            </div>
        </div>
        
        <div class="panel-footer">
            <div class="btn-toolbar">
                <button type="submit" class="btn btn-primary btn-lg">
                    <i class="icon-save"></i> {l s='Save Content' mod='productextracontentmanager'}
                </button>
                <button type="button" class="btn btn-default btn-lg" id="cancel-form">
                    <i class="icon-remove"></i> {l s='Cancel' mod='productextracontentmanager'}
                </button>
                <button type="button" class="btn btn-info btn-lg" onclick="debugTinyMCE()" title="Debug TinyMCE">
                    <i class="icon-bug"></i> Debug
                </button>
            </div>
        </div>
    </form>
</div>

<!-- Panel de Testing -->
<div class="panel" style="margin-top: 20px;">
    <div class="panel-heading">
        <h3><i class="icon-flask"></i> Herramientas de Testing</h3>
    </div>
    <div class="panel-body">
        <p>Usa estos botones para probar el funcionamiento del módulo:</p>
        <div class="btn-group">
            <button type="button" class="btn btn-success btn-test-html" onclick="testHtml()">
                <i class="icon-code"></i> Insertar HTML de Prueba
            </button>
            <button type="button" class="btn btn-info" onclick="debugContent()">
                <i class="icon-search"></i> Debug Contenido
            </button>
            <button type="button" class="btn btn-warning" onclick="togglePreview()">
                <i class="icon-eye"></i> Toggle Preview
            </button>
        </div>
        <div class="help-block">
            <strong>HTML de prueba:</strong> <code>&lt;div class="pv_single"&gt;&lt;img src="..."&gt;&lt;span class="pv_label"&gt;Texto&lt;/span&gt;&lt;/div&gt;</code>
        </div>
    </div>
</div>

<!-- JavaScript y CSS -->
<script type="text/javascript">
// Variables globales necesarias para el funcionamiento
var moduleUrl = '{$current_index}&configure={$module_name}&token={$token}';
var selectedProducts = [];
var prestashop_language = '{$iso}';
var prestashop_css_dir = '{$smarty.const._PS_CSS_DIR_}';

$(document).ready(function() {
    console.log('🚀 Módulo Product Extra Content Manager iniciado');
    console.log('📍 URL del módulo:', moduleUrl);
    
    // CRITICAL: Función para alternar preview del contenido HTML
    window.togglePreview = function() {
        var $container = $('.html-preview-container');
        var $button = $('button[onclick="togglePreview()"]');
        
        if ($container.is(':visible')) {
            $container.slideUp(300);
            $button.html('<i class="icon-eye"></i> {l s="Show Preview" mod="productextracontentmanager"}');
        } else {
            var content = '';
            if (typeof window.getTinyMCEContent === 'function') {
                content = window.getTinyMCEContent();
            } else {
                content = $('#content_text').val();
            }
            
            if (content.trim()) {
                $('#content-preview').html(content);
                $container.slideDown(300);
                $button.html('<i class="icon-eye-slash"></i> {l s="Hide Preview" mod="productextracontentmanager"}');
            } else {
                alert('{l s="No content to preview" mod="productextracontentmanager"}');
            }
        }
    };
    
    // Manejar pegado de contenido HTML
    $('#content_text').on('paste', function(e) {
        console.log('📋 Contenido HTML pegado');
        setTimeout(function() {
            if (typeof tinymce === 'undefined' || !tinymce.get('content_text')) {
                console.log('💡 Usando textarea normal - HTML preservado');
            }
        }, 100);
    });
});

// Debug de contenido HTML
window.debugContent = function() {
    console.log('🔍 Debug del contenido:');
    
    var content = '';
    if (typeof window.getTinyMCEContent === 'function') {
        content = window.getTinyMCEContent();
        console.log('📝 Contenido desde TinyMCE:', content);
    } else {
        content = $('#content_text').val();
        console.log('📝 Contenido desde textarea:', content);
    }
    
    console.log('📏 Longitud:', content.length);
    console.log('🏷️ Contiene HTML:', /<[a-z][\s\S]*>/i.test(content));
    
    return content;
};

// Función para insertar HTML de prueba
window.testHtml = function() {
    var testHtml = '<div class="pv_single"><img src="https://www.minipitbikes.es/blog/wp-content/uploads/2017/03/Envios-antes-de-12pm.jpg" alt="" /> <span class="pv_label">Envío hoy si lo pides <strong>antes 11h <span class="pv_label"><strong>de la</strong></span> mañana</strong></span><span class="pv_value"></span></div><div class="pv_single"><img src="https://www.minipitbikes.es/blog/wp-content/uploads/2017/03/Entrega-en-24-72h.jpg" alt="" /> <span class="pv_label">Entrega 24-48h, <strong>puesta a punto un día más</strong><br /></span></div><div class="pv_single"><img src="https://www.minipitbikes.es/blog/wp-content/uploads/2017/03/Atenci%C3%B3n-al-cliente.jpg" alt="" /> Atención al cliente télefono <strong>633 083 659</strong></div>';
    
    if (typeof window.setTinyMCEContent === 'function') {
        window.setTinyMCEContent(testHtml);
    } else {
        $('#content_text').val(testHtml);
    }
    
    console.log('🧪 HTML de prueba insertado');
    alert('HTML de prueba insertado. Revisa el editor.');
};

window.debugTinyMCE = function() {
    if (typeof window.debugTinyMCE !== 'undefined') {
        window.debugTinyMCE();
    } else {
        console.log('Debug TinyMCE no disponible');
    }
};
// Fix para el switch de activar/desactivar
$(document).ready(function() {
    // Manejar clicks en el switch
    $('.prestashop-switch').on('click', function(e) {
        var $switch = $(this);
        var $activeOn = $switch.find('#active_on');
        var $activeOff = $switch.find('#active_off');
        
        if ($activeOn.is(':checked')) {
            $activeOff.prop('checked', true);
            $activeOn.prop('checked', false);
        } else {
            $activeOn.prop('checked', true);
            $activeOff.prop('checked', false);
        }
        
        updateSwitchAppearance($switch);
    });
    
    // Actualizar apariencia del switch
    function updateSwitchAppearance($switch) {
        var isActive = $switch.find('#active_on').is(':checked');
        var $slideButton = $switch.find('.slide-button');
        
        if (isActive) {
            $switch.css('background', '#28a745');
            $slideButton.css('left', '42px');
            $switch.find('label[for="active_on"]').css('color', 'white');
            $switch.find('label[for="active_off"]').css('color', '#666');
        } else {
            $switch.css('background', '#dc3545');
            $slideButton.css('left', '2px');
            $switch.find('label[for="active_off"]').css('color', 'white');
            $switch.find('label[for="active_on"]').css('color', '#666');
        }
    }
    
    // Inicializar apariencia
    $('.prestashop-switch').each(function() {
        updateSwitchAppearance($(this));
    });
    
    // Manejar clicks en labels específicamente
    $('.prestashop-switch label').on('click', function(e) {
        e.stopPropagation();
        var $label = $(this);
        var $switch = $label.closest('.prestashop-switch');
        var forValue = $label.attr('for');
        
        $switch.find('input[type="radio"]').prop('checked', false);
        $switch.find('#' + forValue).prop('checked', true);
        
        updateSwitchAppearance($switch);
    });
});
</script>

<!-- Cargar el archivo JavaScript principal -->
<script type="text/javascript" src="{$module_dir}views/js/admin.js"></script>

<!-- CSS específico -->
<style>
/* CRITICAL: Estilos para el editor HTML mejorado */
.html-editor-container {
    position: relative;
    border: 2px solid #e9ecef;
    border-radius: 8px;
    overflow: hidden;
    background: white;
    transition: all 0.3s ease;
}

.html-editor-container:focus-within {
    border-color: #007bff;
    box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.1);
}

.html-editor {
    border: none !important;
    min-height: 400px;
    font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
    font-size: 13px;
    line-height: 1.5;
    padding: 15px;
    resize: vertical;
    background: #fafafa;
}

.html-editor:focus {
    outline: none;
    background: white;
    box-shadow: none;
}

/* Preview del contenido */
.html-preview-container {
    animation: slideDown 0.3s ease;
}

@keyframes slideDown {
    from {
        opacity: 0;
        max-height: 0;
    }
    to {
        opacity: 1;
        max-height: 500px;
    }
}

#content-preview {
    max-height: 400px;
    overflow-y: auto;
    border: 1px solid #ddd;
    background: white;
    padding: 15px;
}

/* Estilos para el contenido de ejemplo */
#content-preview .pv_single {
    display: flex;
    align-items: center;
    margin: 10px 0;
    padding: 15px;
    border: 1px solid #ddd;
    border-radius: 8px;
    background: #f9f9f9;
}

#content-preview .pv_single img {
    margin-right: 15px;
    max-width: 50px;
    max-height: 50px;
}

#content-preview .pv_label {
    font-weight: bold;
    color: #333;
}

#content-preview .pv_value {
    color: #666;
    margin-left: 10px;
}

/* Panel del formulario mejorado */
.panel-featured {
    border: 2px solid #007cba;
    box-shadow: 0 8px 25px rgba(0, 124, 186, 0.1);
    animation: slideInDown 0.5s ease;
}

@keyframes slideInDown {
    from {
        opacity: 0;
        transform: translateY(-30px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.panel-featured .panel-heading {
    background: linear-gradient(135deg, #007cba 0%, #005a9a 100%);
    color: white;
    border-bottom: none;
    padding: 20px;
}

.panel-featured .panel-heading h3 {
    margin: 0;
    color: white;
    font-size: 18px;
}

/* Grupos de formulario mejorados */
.form-group {
    margin-bottom: 30px;
    padding: 20px;
    background: linear-gradient(135deg, #fafafa 0%, #f5f5f5 100%);
    border: 1px solid #e9ecef;
    border-radius: 8px;
    transition: all 0.3s ease;
}

.form-group:hover {
    background: linear-gradient(135deg, #f0f8ff 0%, #e6f3ff 100%);
    border-color: #007cba;
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 124, 186, 0.1);
}

.control-label {
    font-weight: 600;
    color: #333;
    font-size: 14px;
}

.label-tooltip {
    cursor: help;
    border-bottom: 1px dotted #666;
}

.required {
    color: #e74c3c;
    font-weight: bold;
}

/* TinyMCE específico */
.mce-tinymce {
    border: 2px solid #007cba !important;
    border-radius: 8px !important;
    box-shadow: 0 4px 12px rgba(0, 124, 186, 0.1) !important;
}

.mce-toolbar-grp {
    background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%) !important;
    border-bottom: 1px solid #dee2e6 !important;
}

.mce-btn {
    transition: all 0.2s ease !important;
}

.mce-btn:hover {
    background: #007cba !important;
    border-color: #007cba !important;
    color: white !important;
}

/* Contenedor de imagen mejorado */
.image-upload-container {
    border: 3px dashed #007cba;
    border-radius: 12px;
    padding: 30px;
    text-align: center;
    background: linear-gradient(135deg, #f8f9ff 0%, #e6f3ff 100%);
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
}

.image-upload-container:hover {
    border-color: #0056b3;
    background: linear-gradient(135deg, #e6f3ff 0%, #cce7ff 100%);
    transform: translateY(-2px);
    box-shadow: 0 8px 25px rgba(0, 123, 255, 0.15);
}

.current-image-preview {
    text-align: center;
    padding: 15px;
    background: white;
    border: 1px solid #ddd;
    border-radius: 8px;
    margin-top: 15px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.current-image-preview img {
    border-radius: 6px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    transition: transform 0.3s ease;
}

.current-image-preview img:hover {
    transform: scale(1.05);
}

.image-preview {
    background: white;
    border: 1px solid #e9ecef;
    border-radius: 8px;
    padding: 15px;
    margin-top: 15px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    animation: fadeInUp 0.3s ease;
}

@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* Hooks mejorados */
.hooks-container {
    background: white;
    border: 1px solid #e9ecef;
    border-radius: 8px;
    padding: 20px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.hook-item {
    background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
    border: 1px solid #dee2e6;
    border-radius: 8px;
    padding: 15px;
    margin-bottom: 15px;
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
}

.hook-item::before {
    content: "";
    position: absolute;
    left: 0;
    top: 0;
    width: 4px;
    height: 100%;
    background: #007bff;
    transform: translateX(-4px);
    transition: transform 0.3s ease;
}

.hook-item:hover {
    background: linear-gradient(135deg, #e6f3ff 0%, #cce7ff 100%);
    border-color: #007bff;
    transform: translateX(5px);
}

.hook-item:hover::before {
    transform: translateX(0);
}

.hook-item input[type="checkbox"] {
    transform: scale(1.2);
    margin-right: 10px;
    accent-color: #007bff;
}

.position-group {
    background: white;
    border: 1px solid #dee2e6;
    border-radius: 6px;
    padding: 12px;
    margin-top: 10px;
    animation: slideDown 0.3s ease;
}

.hook-position {
    width: 80px !important;
    text-align: center;
    font-weight: 600;
}

/* Selector de productos mejorado */
.products-selector {
    border: 1px solid #e9ecef;
    border-radius: 8px;
    background: white;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
    overflow: hidden;
}

.search-container {
    background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
    padding: 20px;
    border-bottom: 1px solid #dee2e6;
}

.search-results {
    position: absolute;
    background: white;
    border: 1px solid #007bff;
    border-top: none;
    border-radius: 0 0 8px 8px;
    max-height: 250px;
    overflow-y: auto;
    z-index: 1050;
    width: 100%;
    box-shadow: 0 8px 25px rgba(0, 123, 255, 0.15);
}

.search-result-item {
    padding: 15px 20px;
    cursor: pointer;
    border-bottom: 1px solid #f8f9fa;
    display: flex;
    align-items: center;
    transition: all 0.2s ease;
}

.search-result-item:hover {
    background: linear-gradient(135deg, #e6f3ff 0%, #cce7ff 100%);
    color: #0056b3;
    transform: translateX(5px);
}

.search-result-item i {
    margin-right: 10px;
    color: #007bff;
}

.searching {
    text-align: center;
    padding: 20px;
    color: #007bff;
}

.searching i {
    animation: spin 1s linear infinite;
}

@keyframes spin {
    from { transform: rotate(0deg); }
    to { transform: rotate(360deg); }
}

.no-results, .search-error {
    text-align: center;
    padding: 20px;
    color: #6c757d;
    font-style: italic;
}

.search-error {
    color: #dc3545;
}

.selected-items {
    padding: 20px;
    min-height: 60px;
    background: linear-gradient(135deg, #f8f9ff 0%, #e6f3ff 100%);
}

.selected-product-item {
    display: inline-block;
    background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
    color: white;
    padding: 8px 30px 8px 15px;
    margin: 3px;
    border-radius: 20px;
    font-size: 12px;
    position: relative;
    transition: all 0.3s ease;
    box-shadow: 0 2px 4px rgba(0, 123, 255, 0.3);
}

.selected-product-item:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 123, 255, 0.4);
}

.selected-product-item .remove-product {
    position: absolute;
    right: 8px;
    top: 50%;
    transform: translateY(-50%);
    background: rgba(255, 255, 255, 0.2);
    border: none;
    color: white;
    width: 18px;
    height: 18px;
    border-radius: 50%;
    padding: 0;
    line-height: 1;
    cursor: pointer;
    transition: all 0.2s ease;
}

.selected-product-item .remove-product:hover {
    background: #dc3545;
    transform: translateY(-50%) scale(1.1);
}

/* Help blocks mejorados */
.help-block {
    font-size: 12px;
    color: #6c757d;
    margin-top: 10px;
    line-height: 1.5;
    padding: 8px 12px;
    background: rgba(0, 123, 255, 0.05);
    border-left: 3px solid #007bff;
    border-radius: 0 4px 4px 0;
}

.help-block i {
    margin-right: 5px;
    color: #007bff;
}

.help-block code {
    background: #f8f9fa;
    border: 1px solid #e9ecef;
    border-radius: 3px;
    padding: 2px 4px;
    font-size: 11px;
    color: #e83e8c;
}

/* Botón de prueba HTML */
.btn-test-html {
    background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
    border: none;
    color: white;
    margin-left: 10px;
}

.btn-test-html:hover {
    background: linear-gradient(135deg, #20c997 0%, #17a2b8 100%);
    color: white;
    transform: translateY(-2px);
}

/* Responsive mejorado */
@media (max-width: 768px) {
    .form-group {
        padding: 15px;
        margin-bottom: 20px;
    }
    
    .html-editor {
        min-height: 300px;
        font-size: 14px;
    }
    
    .image-upload-container {
        padding: 20px;
    }
    
    .selected-product-item {
        display: block;
        margin: 5px 0;
        width: auto;
    }
    
    .control-label {
        text-align: left !important;
        margin-bottom: 10px;
        font-size: 14px;
    }
    
    .col-lg-3, .col-lg-9 {
        width: 100% !important;
        float: none !important;
        padding: 0 !important;
    }
    
    .form-horizontal .form-group {
        margin-left: 0;
        margin-right: 0;
    }
}

/* Animaciones adicionales */
.category-tree {
    max-height: 300px;
    overflow-y: auto;
    padding: 15px;
    background: linear-gradient(135deg, #f8f9ff 0%, #e6f3ff 100%);
}

.category-tree::-webkit-scrollbar {
    width: 8px;
}

.category-tree::-webkit-scrollbar-track {
    background: #f1f1f1;
    border-radius: 4px;
}

.category-tree::-webkit-scrollbar-thumb {
    background: #007bff;
    border-radius: 4px;
}

.category-tree::-webkit-scrollbar-thumb:hover {
    background: #0056b3;
}

.categories-selector {
    border: 1px solid #e9ecef;
    border-radius: 8px;
    background: white;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
    overflow: hidden;
}

.category-tree-container {
    background: white;
}

.category-tree-header {
    background: #f8f9fa;
    border-bottom: 1px solid #e9ecef;
    padding: 15px;
}

.category-tree-header .btn-toolbar {
    margin-bottom: 10px;
}

.category-tree-header .btn-group {
    margin-right: 10px;
}

.category-search {
    max-width: 250px;
}

.category-tree-list {
    list-style: none;
    padding: 0;
    margin: 0;
}

.category-node {
    margin: 3px 0;
    padding: 5px 0;
    line-height: 24px;
}

.tree-toggle {
    display: inline-block;
    width: 20px;
    height: 20px;
    line-height: 18px;
    text-align: center;
    background: #e6e6e6;
    border: 1px solid #ccc;
    border-radius: 3px;
    cursor: pointer;
    margin-right: 6px;
    color: #333;
    font-size: 12px;
}

.tree-toggle:hover {
    background: #007cba;
    color: white;
    border-color: #007cba;
}

.tree-spacer {
    display: inline-block;
    width: 22px;
    margin-right: 6px;
}

.tree-icon {
    display: inline-block;
    width: 16px;
    height: 16px;
    margin-right: 8px;
    vertical-align: middle;
}

.tree-icon.folder::before {
    content: "📁";
    font-size: 14px;
}

.tree-icon.item::before {
    content: "📄";
    font-size: 14px;
}

.category-label {
    display: inline-flex;
    align-items: center;
    cursor: pointer;
    margin: 0;
    font-weight: normal;
}

.category-label:hover {
    color: #007cba;
}

.category-label input[type="checkbox"] {
    margin-right: 8px;
    transform: scale(1.1);
}

.category-name small {
    color: #6c757d;
    font-size: 10px;
}

.category-children {
    margin-left: 25px;
    border-left: 2px dotted #ddd;
    padding-left: 15px;
}

.category-node.expanded > .tree-toggle {
    background: #28a745;
    color: white;
    border-color: #28a745;
}
/* Switch de PrestaShop corregido */
.prestashop-switch {
    position: relative;
    display: inline-block;
    width: 80px;
    height: 34px;
    background: #ddd;
    border-radius: 17px;
    cursor: pointer;
    transition: all 0.3s ease;
}

.prestashop-switch input[type="radio"] {
    display: none;
}

.prestashop-switch label {
    position: absolute;
    top: 0;
    width: 40px;
    height: 34px;
    line-height: 34px;
    text-align: center;
    font-size: 11px;
    font-weight: 600;
    text-transform: uppercase;
    cursor: pointer;
    transition: all 0.3s ease;
    z-index: 2;
    color: #666;
}

.prestashop-switch label[for="active_on"] {
    left: 0;
}

.prestashop-switch label[for="active_off"] {
    right: 0;
}

.prestashop-switch .slide-button {
    position: absolute;
    top: 2px;
    left: 2px;
    width: 36px;
    height: 30px;
    background: white;
    border-radius: 15px;
    transition: all 0.3s ease;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
    z-index: 1;
}

.prestashop-switch input[value="1"]:checked ~ .slide-button {
    left: 42px;
}

.prestashop-switch input[value="1"]:checked ~ label[for="active_on"] {
    color: white;
}

.prestashop-switch input[value="1"]:checked {
    background: #28a745;
}

.prestashop-switch input[value="0"]:checked ~ label[for="active_off"] {
    color: white;
}

.prestashop-switch:has(input[value="1"]:checked) {
    background: #28a745;
}

.prestashop-switch:has(input[value="0"]:checked) {
    background: #dc3545;
}
/* Textarea que preserva formato */
#content_text {
    font-family: 'Courier New', Monaco, monospace !important;
    font-size: 13px !important;
    line-height: 1.4 !important;
    white-space: pre-wrap !important;
    word-wrap: break-word !important;
    background: #f8f8f8 !important;
    border: 2px solid #007bff !important;
    padding: 15px !important;
}

#content_text:focus {
    background: white !important;
    outline: none !important;
}

/* Preview que respeta HTML */
#content-preview {
    white-space: normal !important;
    word-wrap: break-word !important;
}

#content-preview .pv_single {
    display: block !important;
    margin: 10px 0 !important;
    padding: 10px !important;
    border: 1px solid #ddd !important;
    background: #f9f9f9 !important;
}
</style>