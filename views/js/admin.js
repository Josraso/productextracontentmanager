/**
 * Product Extra Content Manager - Admin JavaScript CORREGIDO
 * Solución completa para preservar HTML en TinyMCE
 */

$(document).ready(function() {
    
    // Variables globales
    var tinyMCEInitialized = false;
    var moduleUrl = window.location.href;
    var selectedProducts = [];
    
    // ============= INICIALIZACIÓN TINYMCE MEJORADA =============
    
    /**
     * CRITICAL: Función mejorada para inicializar TinyMCE que preserva HTML completo
     */
    function initTinyMCE() {
        console.log('🔧 Inicializando TinyMCE mejorado...');
        
        // Destruir instancia anterior si existe
        if (typeof tinymce !== 'undefined' && tinymce.get('content_text')) {
            tinymce.get('content_text').destroy();
        }
        
        // Método mejorado para PrestaShop 8
        if (typeof tinymce !== 'undefined') {
            try {
                tinymce.init({
                    selector: '#content_text',
                    height: 400,
                    language: prestashop_language || 'es',
                    
                    // CRITICAL: Plugins necesarios para HTML avanzado
                    plugins: [
                        'advlist', 'autolink', 'lists', 'link', 'image', 'charmap', 'preview',
                        'anchor', 'searchreplace', 'visualblocks', 'code', 'fullscreen',
                        'insertdatetime', 'media', 'table', 'contextmenu', 'paste', 
                        'textcolor', 'colorpicker', 'wordcount'
                    ].join(' '),
                    
                    // CRITICAL: Toolbar completa para HTML
                    toolbar: [
                        'undo redo | styleselect | bold italic underline strikethrough',
                        'alignleft aligncenter alignright alignjustify',
                        'bullist numlist outdent indent | removeformat',
                        'forecolor backcolor | link unlink anchor image media',
                        'table | code preview fullscreen'
                    ].join(' | '),
                    
                    menubar: false,
                    branding: false,
                    
                    // CRITICAL: Configuración para preservar HTML
                    convert_urls: false,
                    relative_urls: false,
                    remove_script_host: false,
                    cleanup: false,
                    verify_html: false,
                    
                    // CRITICAL: Elementos permitidos - CLAVE PARA PRESERVAR HTML
                    valid_elements: '*[*]',
                    valid_children: '+body[style]',
                    extended_valid_elements: '*[*]',
                    custom_elements: '*[*]',
                    
                    // CRITICAL: No filtrar contenido
                    entity_encoding: 'raw',
                    entities: '160,nbsp,38,amp,60,lt,62,gt',
                    
                    // Configuración de estilo
                    content_css: [
                        '//fonts.googleapis.com/css?family=Lato:300,300i,400,400i',
                        prestashop_css_dir + 'font.css'
                    ],
                    
                    content_style: [
                        'body { font-family: Lato, Arial, sans-serif; font-size: 14px; line-height: 1.6; }',
                        'img { max-width: 100%; height: auto; }',
                        '.pv_single { margin: 10px 0; padding: 10px; border: 1px solid #ddd; border-radius: 4px; }',
                        '.pv_label { font-weight: bold; margin-left: 10px; }',
                        '.pv_value { color: #666; }'
                    ].join(' '),
                    
                    // CRITICAL: Configuración de paste para preservar HTML
                    paste_data_images: true,
                    paste_as_text: false,
                    paste_retain_style_properties: 'all',
                    paste_remove_styles: false,
                    paste_remove_styles_if_webkit: false,
                    paste_strip_class_attributes: 'none',
                    
                    // Configuración de formato
                    formats: {
                        alignleft: { selector: 'p,h1,h2,h3,h4,h5,h6,td,th,div,ul,ol,li,table,img', classes: 'text-left' },
                        aligncenter: { selector: 'p,h1,h2,h3,h4,h5,h6,td,th,div,ul,ol,li,table,img', classes: 'text-center' },
                        alignright: { selector: 'p,h1,h2,h3,h4,h5,h6,td,th,div,ul,ol,li,table,img', classes: 'text-right' },
                        alignjustify: { selector: 'p,h1,h2,h3,h4,h5,h6,td,th,div,ul,ol,li,table,img', classes: 'text-justify' }
                    },
                    
                    // CRITICAL: Callbacks para debug y preservación
                    setup: function(editor) {
                        console.log('📝 TinyMCE setup iniciado...');
                        
                        editor.on('init', function() {
                            console.log('✅ TinyMCE inicializado correctamente');
                            tinyMCEInitialized = true;
                            
                            // CRITICAL: Configurar para preservar HTML al cargar
                            editor.serializer.addRules('*[*]');
                        });
                        
                        editor.on('change keyup', function() {
                            // Auto-guardar contenido sin filtros
                            editor.save();
                        });
                        
                        editor.on('paste', function(e) {
                            console.log('📋 Contenido pegado en TinyMCE');
                            // No prevenir el pegado para mantener HTML
                        });
                        
                        editor.on('BeforeSetContent', function(e) {
                            console.log('📥 Contenido siendo establecido:', e.content);
                            // No modificar el contenido
                        });
                        
                        editor.on('GetContent', function(e) {
                            console.log('📤 Contenido obtenido:', e.content);
                            // No modificar el contenido al obtenerlo
                        });
                    },
                    
                    // Configuración de imagen
                    image_advtab: true,
                    image_caption: true,
                    image_title: true,
                    
                    // Configuración de tabla
                    table_toolbar: 'tableprops tabledelete | tableinsertrowbefore tableinsertrowafter tabledeleterow | tableinsertcolbefore tableinsertcolafter tabledeletecol',
                    table_appearance_options: false,
                    
                    // Configuración de vista previa
                    preview_styles: false,
                    
                    // CRITICAL: Configuración específica para no limpiar HTML
                    allow_script_urls: true,
                    allow_html_data_urls: true
                });
                
                return true;
            } catch (e) {
                console.error('❌ Error inicializando TinyMCE:', e);
                return false;
            }
        } else {
            console.warn('⚠️ TinyMCE no disponible');
            return false;
        }
    }
    
    /**
     * CRITICAL: Función para obtener contenido HTML sin filtros
     */
    function getTinyMCEContent() {
        if (typeof tinymce !== 'undefined' && tinymce.get('content_text')) {
            // Forzar guardado y obtener contenido raw
            tinymce.get('content_text').save();
            return tinymce.get('content_text').getContent({ format: 'raw' });
        } else {
            return $('#content_text').val();
        }
    }
    
    /**
     * CRITICAL: Función para establecer contenido HTML sin filtros
     */
    function setTinyMCEContent(content) {
        if (typeof tinymce !== 'undefined' && tinymce.get('content_text')) {
            tinymce.get('content_text').setContent(content, { format: 'raw' });
        } else {
            $('#content_text').val(content);
        }
    }
    
    // Destruir TinyMCE
    function destroyTinyMCE() {
        if (typeof tinymce !== 'undefined' && tinymce.get('content_text')) {
            tinymce.get('content_text').destroy();
            tinyMCEInitialized = false;
        }
    }
    
    // ============= EVENTOS DE BOTONES =============
    
    // Mostrar formulario para agregar contenido
    $('#add-new-content').click(function() {
        console.log('➕ Agregando nuevo contenido...');
        $('#form-title').text('Agregar Nuevo Contenido');
        $('#submit-type').attr('name', 'submitAddContent').val('1');
        $('#content-id').val('');
        resetForm();
        $('#current-image').hide();
        $('#content-form').slideDown(400);
        
        // CRITICAL: Inicializar TinyMCE después de mostrar el formulario
        setTimeout(function() {
            initTinyMCE();
        }, 500);
        
        // Scroll suave al formulario
        $('html, body').animate({
            scrollTop: $('#content-form').offset().top - 20
        }, 600);
    });
    
    // Cancelar formulario
    $('#cancel-form').click(function() {
        if (confirm('¿Estás seguro de que quieres cancelar? Se perderán los cambios no guardados.')) {
            $('#content-form').slideUp(400);
            destroyTinyMCE();
            resetForm();
        }
    });
    
    // Resetear formulario
    function resetForm() {
        $('#content-form-data')[0].reset();
        selectedProducts = [];
        $('#selected-products').empty().append('<div class="selected-items-header" style="display: none;"><strong>Productos Seleccionados:</strong></div>');
        $('.hook-checkbox').prop('checked', false);
        $('.position-group').hide();
        $('.hook-position').prop('disabled', true).val('');
        $('#active_on').prop('checked', true);
        updateProductsInput();
        updateSelectedCategories();
        
        // Limpiar TinyMCE
        setTimeout(function() {
            if (tinyMCEInitialized) {
                setTinyMCEContent('');
            }
        }, 100);
    }
    
    // Editar contenido existente
    $('.edit-content-btn').click(function() {
        var contentId = $(this).data('id');
        console.log('✏️ Editando contenido ID:', contentId);
        
        $('#form-title').text('Editar Contenido');
        $('#submit-type').attr('name', 'submitEditContent').val('1');
        $('#content-id').val(contentId);
        $('#content-form').slideDown(400);
        
        // CRITICAL: Inicializar TinyMCE antes de cargar datos
        setTimeout(function() {
            initTinyMCE();
            setTimeout(function() {
                loadContentData(contentId);
            }, 800);
        }, 500);
        
        // Scroll suave al formulario
        $('html, body').animate({
            scrollTop: $('#content-form').offset().top - 20
        }, 600);
    });
    
    // ============= CARGAR DATOS PARA EDICIÓN =============
    
    function loadContentData(contentId) {
        console.log('📥 Cargando datos del contenido:', contentId);
        
        $.ajax({
            url: moduleUrl,
            type: 'POST',
            data: {
                ajax: 1,
                action: 'loadContent',
                id_content: contentId
            },
            dataType: 'json',
            success: function(data) {
                console.log('📊 Datos recibidos:', data);
                
                if (data.success) {
                    $('#name').val(data.content.name);
                    
                    // CRITICAL: Cargar contenido HTML sin filtros en TinyMCE
                    setTimeout(function() {
                        if (tinyMCEInitialized && data.content.content_text) {
                            console.log('📝 Cargando HTML en TinyMCE:', data.content.content_text);
                            setTinyMCEContent(data.content.content_text);
                        } else {
                            $('#content_text').val(data.content.content_text || '');
                        }
                    }, 1000);
                    
                    $('#image_width').val(data.content.image_width || '');
                    $('#image_height').val(data.content.image_height || '');
                    
                    if (data.content.active == 1) {
                        $('#active_on').prop('checked', true);
                    } else {
                        $('#active_off').prop('checked', true);
                    }
                    
                    // Mostrar imagen actual
                    if (data.content.content_image) {
                        $('#current-image img').attr('src', data.module_dir + 'images/' + data.content.content_image);
                        $('#current-image').show();
                    }
                    
                    // Cargar hooks
                    $('.hook-checkbox').prop('checked', false);
                    $('.position-group').hide();
                    $('.hook-position').prop('disabled', true).val('');
                    if (data.hooks) {
                        $.each(data.hooks, function(index, hook) {
                            var $checkbox = $('input[name="hooks[]"][value="' + hook.hook_name + '"]');
                            $checkbox.prop('checked', true);
                            var $positionGroup = $checkbox.closest('.hook-item').find('.position-group');
                            var $positionInput = $positionGroup.find('.hook-position');
                            $positionGroup.show();
                            $positionInput.val(hook.position).prop('disabled', false);
                        });
                    }
                    
                    // Cargar productos
                    selectedProducts = [];
                    $('#selected-products').empty().append('<div class="selected-items-header" style="display: none;"><strong>Productos Seleccionados:</strong></div>');
                    if (data.products) {
                        $.each(data.products, function(index, product) {
                            addProduct(product.id_product, product.name);
                        });
                    }
                    
                    // Cargar categorías
                    $('#category-tree input[type="checkbox"]').prop('checked', false);
                    if (data.categories) {
                        $.each(data.categories, function(index, category) {
                            $('#category-tree input[value="' + category.id_category + '"]').prop('checked', true);
                        });
                    }
                    updateSelectedCategories();
                }
            },
            error: function(xhr, status, error) {
                console.error('❌ Error cargando datos:', error);
                showAlert('error', 'Error al cargar los datos del contenido');
            }
        });
    }
    
    // ============= ELIMINAR CONTENIDO =============
    
    $('.delete-content-btn').click(function() {
        var contentId = $(this).data('id');
        var contentName = $(this).closest('tr').find('td:first strong').text();
        
        if (confirm('¿Estás seguro de que quieres eliminar el contenido "' + contentName + '"?\n\nEsta acción no se puede deshacer.')) {
            var form = $('<form method="post" style="display:none;"></form>');
            form.append('<input type="hidden" name="submitDeleteContent" value="1">');
            form.append('<input type="hidden" name="id_content" value="' + contentId + '">');
            $('body').append(form);
            form.submit();
        }
    });
    
    // ============= GESTIÓN DE HOOKS =============
    
    $('.hook-checkbox').change(function() {
        var $positionGroup = $(this).closest('.hook-item').find('.position-group');
        var $positionInput = $positionGroup.find('.hook-position');
        
        if ($(this).is(':checked')) {
            $positionGroup.slideDown(200);
            $positionInput.prop('disabled', false);
        } else {
            $positionGroup.slideUp(200);
            $positionInput.prop('disabled', true).val('');
        }
    });
    
    // ============= BÚSQUEDA DE PRODUCTOS =============
    
    function initProductSearch() {
        var searchTimeout;
        
        $('#product-search').on('input', function() {
            var query = $(this).val();
            
            clearTimeout(searchTimeout);
            
            if (query.length < 2) {
                $('#product-search-results').hide();
                return;
            }
            
            searchTimeout = setTimeout(function() {
                searchProducts(query);
            }, 300);
        });
        
        $(document).on('click', function(e) {
            if (!$(e.target).closest('.products-selector').length) {
                $('#product-search-results').hide();
            }
        });
    }
    
    function searchProducts(query) {
        $('#product-search-results').html('<div class="searching"><i class="icon-spinner icon-spin"></i> Buscando...</div>').show();
        
        $.ajax({
            url: moduleUrl,
            type: 'POST',
            data: {
                ajax: 1,
                action: 'searchProducts',
                q: query
            },
            dataType: 'json',
            success: function(data) {
                var html = '';
                if (data && data.length > 0) {
                    data.forEach(function(product) {
                        if (selectedProducts.indexOf(product.id_product) === -1) {
                            html += '<div class="search-result-item" data-id="' + product.id_product + '" data-name="' + product.name + '">';
                            html += '<i class="icon-shopping-cart"></i> ';
                            html += '<span class="product-name">' + product.name + '</span> ';
                            html += '<small class="product-id">ID: ' + product.id_product + '</small>';
                            html += '</div>';
                        }
                    });
                }
                
                if (html === '') {
                    html = '<div class="no-results"><i class="icon-warning-sign"></i> No se encontraron productos</div>';
                }
                
                $('#product-search-results').html(html);
            },
            error: function() {
                $('#product-search-results').html('<div class="search-error"><i class="icon-exclamation-triangle"></i> Error en la búsqueda</div>');
            }
        });
    }
    
    $(document).on('click', '.search-result-item', function() {
        var id = $(this).data('id');
        var name = $(this).data('name');
        addProduct(id, name);
    });
    
    function addProduct(id, name) {
        if (selectedProducts.indexOf(id) === -1) {
            selectedProducts.push(id);
            
            var tag = '<div class="selected-product-item" data-id="' + id + '">';
            tag += '<span class="product-info">';
            tag += '<i class="icon-tag"></i> <strong>' + name + '</strong> ';
            tag += '<small class="text-muted">ID: ' + id + '</small>';
            tag += '</span>';
            tag += '<button type="button" class="btn btn-xs btn-danger remove-product" onclick="removeProduct(' + id + ')">';
            tag += '<i class="icon-times"></i>';
            tag += '</button>';
            tag += '</div>';
            
            $('#selected-products').append(tag);
            $('#selected-products .selected-items-header').show();
            
            updateProductsInput();
            $('#product-search').val('');
            $('#product-search-results').hide();
        }
    }
    
    window.removeProduct = function(id) {
        var index = selectedProducts.indexOf(id);
        if (index > -1) {
            selectedProducts.splice(index, 1);
            $('[data-id="' + id + '"].selected-product-item').remove();
            updateProductsInput();
            
            if (selectedProducts.length === 0) {
                $('#selected-products .selected-items-header').hide();
            }
        }
    };
    
    function updateProductsInput() {
        $('#products-input').val(selectedProducts.join(','));
    }
    
    // ============= VALIDACIÓN DEL FORMULARIO =============
    
    $('#content-form-data').submit(function(e) {
        console.log('💾 Enviando formulario...');
        
        var isValid = true;
        var errors = [];
        
        // CRITICAL: Actualizar TinyMCE antes de validar
        if (tinyMCEInitialized) {
            tinymce.get('content_text').save();
        }
        
        updateSelectedCategories();
        
        // Validaciones
        if ($('#name').val().trim() === '') {
            errors.push('El nombre es obligatorio');
            isValid = false;
        }
        
        if ($('.hook-checkbox:checked').length === 0) {
            errors.push('Debe seleccionar al menos un hook');
            isValid = false;
        }
        
        var hasProducts = selectedProducts.length > 0;
        var hasCategories = $('#selected-categories').val() !== '';
        
        if (!hasProducts && !hasCategories) {
            errors.push('Debe seleccionar al menos un producto o categoría');
            isValid = false;
        }
        
        // Validar contenido
        var hasText = getTinyMCEContent().trim() !== '';
        var hasImage = $('#content_image')[0].files.length > 0 || $('#current-image').is(':visible');
        
        if (!hasText && !hasImage) {
            errors.push('Debe proporcionar contenido de texto o una imagen');
            isValid = false;
        }
        
        if (!isValid) {
            e.preventDefault();
            showAlert('error', 'Por favor, corrija los siguientes errores:', errors);
            return false;
        }
        
        console.log('✅ Formulario válido, enviando...');
    });
    
    // ============= PREVIEW DE IMAGEN =============
    
    $('#content_image').change(function() {
        var file = this.files[0];
        if (file) {
            var reader = new FileReader();
            reader.onload = function(e) {
                if ($('#image-preview').length === 0) {
                    $('.image-upload-container').append('<div id="image-preview" class="image-preview"><strong>Vista previa:</strong><img src="" alt="Preview" class="img-thumbnail"></div>');
                }
                $('#image-preview img').attr('src', e.target.result);
                $('#image-preview').show();
            };
            reader.readAsDataURL(file);
        } else {
            $('#image-preview').remove();
        }
    });
    
    // ============= FUNCIONES DE CATEGORÍAS =============
    
    function initCategoryTree() {
        $(document).on('change', '#category-tree input[type="checkbox"]', function() {
            updateSelectedCategories();
        });
    }
    
    // ============= FUNCIONES AUXILIARES =============
    
    function showAlert(type, title, messages) {
        var alertClass = 'alert-' + (type === 'error' ? 'danger' : type);
        var icon = type === 'error' ? 'icon-exclamation-triangle' : 'icon-info-circle';
        var messageList = Array.isArray(messages) ? messages : [messages];
        
        var html = '<div class="alert ' + alertClass + ' alert-dismissible fade in" role="alert">';
        html += '<button type="button" class="close" data-dismiss="alert" aria-label="Close">';
        html += '<span aria-hidden="true">&times;</span></button>';
        html += '<h4><i class="' + icon + '"></i> ' + title + '</h4>';
        html += '<ul>';
        messageList.forEach(function(message) {
            html += '<li>' + message + '</li>';
        });
        html += '</ul></div>';
        
        var $alert = $(html);
        $('#content-form').prepend($alert);
        
        setTimeout(function() {
            $alert.fadeOut(function() {
                $(this).remove();
            });
        }, 8000);
        
        $('html, body').animate({
            scrollTop: $('#content-form').offset().top - 20
        }, 300);
    }
    
    // ============= INICIALIZACIÓN =============
    
    initProductSearch();
    initCategoryTree();
    
    // Tooltips
    $('[data-toggle="tooltip"]').tooltip();
    
    // Inicializar estado de posiciones de hooks
    $('.hook-checkbox').each(function() {
        var $positionGroup = $(this).closest('.hook-item').find('.position-group');
        if (!$(this).is(':checked')) {
            $positionGroup.hide();
        }
    });
    
    // Auto-save del contenido cada 30 segundos
    setInterval(function() {
        if (tinyMCEInitialized && $('#name').val().trim() !== '') {
            tinymce.get('content_text').save();
            console.log('🔄 Auto-save realizado');
        }
    }, 30000);
    
    // Prevenir pérdida de datos al salir de la página
    var formChanged = false;
    
    $('#content-form-data input, #content-form-data textarea, #content-form-data select').change(function() {
        formChanged = true;
    });
    
    $(window).on('beforeunload', function(e) {
        if (formChanged && $('#content-form').is(':visible')) {
            return '¿Estás seguro de que quieres salir? Se perderán los cambios no guardados.';
        }
    });
    
    $('#content-form-data').submit(function() {
        formChanged = false;
    });
    
    // Debug de TinyMCE
    window.debugTinyMCE = function() {
        console.log('🔍 Debug TinyMCE:');
        console.log('- Inicializado:', tinyMCEInitialized);
        console.log('- Instancia existe:', typeof tinymce !== 'undefined' && tinymce.get('content_text'));
        if (typeof tinymce !== 'undefined' && tinymce.get('content_text')) {
            console.log('- Contenido actual:', getTinyMCEContent());
        }
    };
    
    // Función global para obtener contenido (para debugging)
    window.getTinyMCEContent = getTinyMCEContent;
    window.setTinyMCEContent = setTinyMCEContent;
});

// ============= FUNCIONES GLOBALES PARA CATEGORÍAS =============

function toggleCategory(element) {
    var $li = $(element).closest('li');
    var $children = $li.find('> .category-children');
    
    if ($children.length > 0) {
        if ($children.is(':hidden')) {
            $children.slideDown(200);
            $(element).html('-');
            $li.addClass('expanded');
        } else {
            $children.slideUp(200);
            $(element).html('+');
            $li.removeClass('expanded');
        }
    }
    return false;
}

function expandAllCategories() {
    $('.tree-toggle').each(function() {
        var $li = $(this).closest('li');
        var $children = $li.find('> .category-children');
        if ($children.length > 0) {
            $children.slideDown(200);
            $(this).html('-');
            $li.addClass('expanded');
        }
    });
    return false;
}

function collapseAllCategories() {
    $('.tree-toggle').each(function() {
        var $li = $(this).closest('li');
        var $children = $li.find('> .category-children');
        if ($children.length > 0) {
            $children.slideUp(200);
            $(this).html('+');
            $li.removeClass('expanded');
        }
    });
    return false;
}

function checkAllCategories() {
    $('#category-tree input[type="checkbox"]').prop('checked', true);
    updateSelectedCategories();
    return false;
}

function uncheckAllCategories() {
    $('#category-tree input[type="checkbox"]').prop('checked', false);
    updateSelectedCategories();
    return false;
}

function searchCategories(searchTerm) {
    var $categories = $('.category-node');
    searchTerm = searchTerm.toLowerCase();
    
    if (searchTerm === '') {
        $categories.show();
        return;
    }
    
    $categories.each(function() {
        var text = $(this).find('.category-name').text().toLowerCase();
        var $li = $(this);
        
        if (text.includes(searchTerm)) {
            $li.show();
            // Mostrar padres
            $li.parents('.category-children').show();
            $li.parents('.category-node').show();
        } else {
            $li.hide();
        }
    });
}

function updateSelectedCategories() {
    var selected = [];
    $('#category-tree input[type="checkbox"]:checked').each(function() {
        selected.push($(this).val());
    });
    $('#selected-categories').val(selected.join(','));
}