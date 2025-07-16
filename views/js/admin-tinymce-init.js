/**
 * Product Extra Content Manager - TinyMCE Initialization
 * CRÍTICO: Archivo específico para inicializar TinyMCE preservando HTML
 */

// Configuración global para TinyMCE
window.productExtraContentManagerTinyMCE = {
    initialized: false,
    instance: null,
    
    // CRÍTICO: Configuración para preservar TODO el HTML
    config: {
        selector: '#content_text',
        height: 450,
        language: 'es',
        
        // Plugins esenciales para HTML avanzado
        plugins: [
            'advlist', 'autolink', 'lists', 'link', 'image', 'charmap', 'preview',
            'anchor', 'searchreplace', 'visualblocks', 'code', 'fullscreen',
            'insertdatetime', 'media', 'table', 'contextmenu', 'paste', 
            'textcolor', 'colorpicker', 'wordcount', 'nonbreaking'
        ].join(' '),
        
        // Toolbar completa
        toolbar: [
            'undo redo | styleselect | bold italic underline strikethrough',
            'alignleft aligncenter alignright alignjustify',
            'bullist numlist outdent indent | removeformat',
            'forecolor backcolor | link unlink anchor image media',
            'table | code preview fullscreen | wordcount'
        ].join(' | '),
        
        menubar: false,
        branding: false,
        
        // CRÍTICO: Configuración para preservar HTML sin modificaciones
        convert_urls: false,
        relative_urls: false,
        remove_script_host: false,
        cleanup: false,
        verify_html: false,
        
        // CRÍTICO: Permitir TODOS los elementos y atributos
        valid_elements: '*[*]',
        valid_children: '+body[style],+div[*],+span[*],+img[*]',
        extended_valid_elements: '*[*]',
        custom_elements: '*[*]',
        
        // No filtrar contenido
        entity_encoding: 'raw',
        entities: '160,nbsp,38,amp,60,lt,62,gt',
        
        // Configuración de paste para preservar HTML
        paste_data_images: true,
        paste_as_text: false,
        paste_retain_style_properties: 'all',
        paste_remove_styles: false,
        paste_remove_styles_if_webkit: false,
        paste_strip_class_attributes: 'none',
        paste_merge_formats: false,
        paste_convert_word_fake_lists: false,
        paste_webkit_styles: 'all',
        paste_remove_spans: false,
        paste_remove_empty_paragraphs: false,
        
        // Configuración de formato
        formats: {
            alignleft: { selector: 'p,h1,h2,h3,h4,h5,h6,td,th,div,ul,ol,li,table,img', classes: 'text-left' },
            aligncenter: { selector: 'p,h1,h2,h3,h4,h5,h6,td,th,div,ul,ol,li,table,img', classes: 'text-center' },
            alignright: { selector: 'p,h1,h2,h3,h4,h5,h6,td,th,div,ul,ol,li,table,img', classes: 'text-right' },
            alignjustify: { selector: 'p,h1,h2,h3,h4,h5,h6,td,th,div,ul,ol,li,table,img', classes: 'text-justify' }
        },
        
        // Estilos de contenido
        content_css: [
            '//fonts.googleapis.com/css?family=Lato:300,300i,400,400i'
        ],
        
        content_style: [
            'body { font-family: Lato, Arial, sans-serif; font-size: 14px; line-height: 1.6; }',
            'img { max-width: 100%; height: auto; }',
            '.pv_single { margin: 10px 0; padding: 15px; border: 1px solid #ddd; border-radius: 8px; display: flex; align-items: center; }',
            '.pv_single img { margin-right: 15px; max-width: 60px; max-height: 60px; flex-shrink: 0; }',
            '.pv_label { font-weight: bold; margin-left: 10px; color: #333; }',
            '.pv_value { color: #666; margin-left: 10px; }'
        ].join(' '),
        
        // Configuración de imagen
        image_advtab: true,
        image_caption: true,
        image_title: true,
        
        // Configuración de tabla
        table_toolbar: 'tableprops tabledelete | tableinsertrowbefore tableinsertrowafter tabledeleterow | tableinsertcolbefore tableinsertcolafter tabledeletecol',
        table_appearance_options: false,
        
        // CRÍTICO: No limpiar HTML
        allow_script_urls: true,
        allow_html_data_urls: true,
        
        // Setup personalizado
        setup: function(editor) {
            console.log('?? TinyMCE setup iniciado para Product Extra Content Manager');
            
            editor.on('init', function() {
                console.log('? TinyMCE inicializado correctamente');
                window.productExtraContentManagerTinyMCE.initialized = true;
                window.productExtraContentManagerTinyMCE.instance = editor;
                
                // CRÍTICO: Configurar para preservar HTML al cargar
                editor.serializer.addRules('*[*]');
                editor.parser.addNodeFilter('*', function(nodes) {
                    // No filtrar ningún nodo
                });
            });
            
            editor.on('change keyup', function() {
                // Auto-guardar contenido sin filtros
                editor.save();
                console.log('?? Contenido auto-guardado');
            });
            
            editor.on('paste', function(e) {
                console.log('?? Contenido pegado en TinyMCE');
                console.log('Contenido:', e.content);
                // No prevenir el pegado para mantener HTML
            });
            
            editor.on('BeforeSetContent', function(e) {
                console.log('?? Contenido siendo establecido:', e.content);
                // CRÍTICO: No modificar el contenido
            });
            
            editor.on('GetContent', function(e) {
                console.log('?? Contenido obtenido:', e.content);
                // CRÍTICO: No modificar el contenido al obtenerlo
            });
            
            // Agregar botón personalizado para HTML directo
            editor.addButton('htmlsource', {
                text: 'HTML',
                icon: 'code',
                tooltip: 'Editar HTML directamente',
                onclick: function() {
                    var content = editor.getContent({ format: 'raw' });
                    var newContent = prompt('Editar HTML:', content);
                    if (newContent !== null) {
                        editor.setContent(newContent, { format: 'raw' });
                    }
                }
            });
        }
    },
    
    // Función para inicializar TinyMCE
    init: function() {
        console.log('?? Inicializando TinyMCE para Product Extra Content Manager...');
        
        if (typeof tinymce === 'undefined') {
            console.error('? TinyMCE no está disponible');
            return false;
        }
        
        // Destruir instancia anterior si existe
        if (tinymce.get('content_text')) {
            tinymce.get('content_text').destroy();
        }
        
        try {
            tinymce.init(this.config);
            return true;
        } catch (e) {
            console.error('? Error inicializando TinyMCE:', e);
            return false;
        }
    },
    
    // Función para obtener contenido HTML sin filtros
    getContent: function() {
        if (this.initialized && this.instance) {
            this.instance.save();
            return this.instance.getContent({ format: 'raw' });
        } else if (document.getElementById('content_text')) {
            return document.getElementById('content_text').value;
        }
        return '';
    },
    
    // Función para establecer contenido HTML sin filtros
    setContent: function(content) {
        if (this.initialized && this.instance) {
            this.instance.setContent(content, { format: 'raw' });
        } else if (document.getElementById('content_text')) {
            document.getElementById('content_text').value = content;
        }
    },
    
    // Función para destruir TinyMCE
    destroy: function() {
        if (this.initialized && this.instance) {
            this.instance.destroy();
            this.initialized = false;
            this.instance = null;
            console.log('??? TinyMCE destruido');
        }
    },
    
    // Función para reinicializar
    reinit: function() {
        this.destroy();
        setTimeout(() => {
            this.init();
        }, 500);
    }
};

// Funciones globales para compatibilidad
window.initProductExtraContentTinyMCE = function() {
    return window.productExtraContentManagerTinyMCE.init();
};

window.getProductExtraContentHTML = function() {
    return window.productExtraContentManagerTinyMCE.getContent();
};

window.setProductExtraContentHTML = function(content) {
    return window.productExtraContentManagerTinyMCE.setContent(content);
};

window.destroyProductExtraContentTinyMCE = function() {
    return window.productExtraContentManagerTinyMCE.destroy();
};

// Auto-inicialización cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', function() {
    console.log('?? DOM cargado, esperando a que TinyMCE esté disponible...');
    
    // Esperar a que TinyMCE esté disponible
    var checkTinyMCE = setInterval(function() {
        if (typeof tinymce !== 'undefined') {
            clearInterval(checkTinyMCE);
            console.log('? TinyMCE detectado, listo para inicializar');
            
            // Si el elemento textarea existe, inicializar automáticamente
            if (document.getElementById('content_text')) {
                setTimeout(function() {
                    window.productExtraContentManagerTinyMCE.init();
                }, 1000);
            }
        }
    }, 100);
    
    // Timeout de seguridad
    setTimeout(function() {
        clearInterval(checkTinyMCE);
        if (typeof tinymce === 'undefined') {
            console.warn('?? TinyMCE no se cargó en el tiempo esperado');
        }
    }, 10000);
});

// Exportar para módulos
if (typeof module !== 'undefined' && module.exports) {
    module.exports = window.productExtraContentManagerTinyMCE;
}