{*
* Product Extra Content Manager - Template para mostrar contenido
* CRÍTICO: Preserva HTML sin filtros y con estilos responsivos
*}

{if $content && count($content) > 0}
    <div class="productextracontentmanager-wrapper" data-hook="{$hook_name}">
        {foreach $content as $item}
            <div class="productextracontentmanager-item" data-content-id="{$item.id_content}">
                
                {* CRITICAL: Mostrar contenido HTML sin filtros *}
                {if $item.content_text}
                    <div class="productextracontentmanager-text">
                        {$item.content_text nofilter}
                    </div>
                {/if}
                
                {* Mostrar imagen si existe *}
                {if $item.content_image}
                    <div class="productextracontentmanager-image">
                        <img src="{$module_dir}images/{$item.content_image}" 
                             alt="{$item.name|escape:'html':'UTF-8'}"
                             class="productextracontentmanager-img"
                             {if $item.image_width > 0}width="{$item.image_width}"{/if}
                             {if $item.image_height > 0}height="{$item.image_height}"{/if}
                        >
                    </div>
                {/if}
                
            </div>
        {/foreach}
    </div>

    {* CSS para hacer el contenido responsivo y con estilos mejorados *}
    <style>
    /* Contenedor principal */
    .productextracontentmanager-wrapper {
        margin: 20px 0;
        clear: both;
    }
    
    .productextracontentmanager-item {
        margin-bottom: 15px;
        padding: 15px;
        border-radius: 8px;
        background: #f9f9f9;
        border: 1px solid #e9ecef;
        transition: all 0.3s ease;
    }
    
    .productextracontentmanager-item:hover {
        background: #f0f8ff;
        border-color: #007bff;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0, 123, 255, 0.1);
    }
    
    /* Contenido de texto */
    .productextracontentmanager-text {
        line-height: 1.6;
        color: #333;
    }
    
    /* Imágenes responsivas */
    .productextracontentmanager-image {
        text-align: center;
        margin: 15px 0;
    }
    
    .productextracontentmanager-img {
        max-width: 100%;
        height: auto;
        border-radius: 6px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s ease;
    }
    
    .productextracontentmanager-img:hover {
        transform: scale(1.02);
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
    }
    
    /* Estilos específicos para el contenido HTML de ejemplo */
    .productextracontentmanager-text .pv_single {
        display: flex;
        align-items: center;
        margin: 10px 0;
        padding: 15px;
        background: white;
        border: 1px solid #ddd;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        transition: all 0.3s ease;
    }
    
    .productextracontentmanager-text .pv_single:hover {
        background: #f8f9ff;
        border-color: #007bff;
        transform: translateX(5px);
    }
    
    .productextracontentmanager-text .pv_single img {
        margin-right: 15px;
        max-width: 60px;
        max-height: 60px;
        border-radius: 6px;
        flex-shrink: 0;
    }
    
    .productextracontentmanager-text .pv_label {
        font-weight: 600;
        color: #333;
        flex: 1;
    }
    
    .productextracontentmanager-text .pv_label strong {
        color: #007bff;
    }
    
    .productextracontentmanager-text .pv_value {
        color: #666;
        font-size: 14px;
    }
    
    /* Responsive design */
    @media (max-width: 768px) {
        .productextracontentmanager-item {
            margin-bottom: 10px;
            padding: 12px;
        }
        
        .productextracontentmanager-text .pv_single {
            flex-direction: column;
            text-align: center;
            padding: 12px;
        }
        
        .productextracontentmanager-text .pv_single img {
            margin-right: 0;
            margin-bottom: 10px;
            max-width: 50px;
            max-height: 50px;
        }
        
        .productextracontentmanager-text .pv_label {
            font-size: 14px;
            text-align: center;
        }
    }
    
    @media (max-width: 576px) {
        .productextracontentmanager-wrapper {
            margin: 15px 0;
        }
        
        .productextracontentmanager-item {
            padding: 10px;
            border-radius: 6px;
        }
        
        .productextracontentmanager-text .pv_single {
            padding: 10px;
            margin: 8px 0;
        }
        
        .productextracontentmanager-text .pv_label {
            font-size: 13px;
        }
        
        .productextracontentmanager-text .pv_single img {
            max-width: 40px;
            max-height: 40px;
        }
    }
    
    /* Hook específicos */
    .productextracontentmanager-wrapper[data-hook="displayAfterProductThumbs"] {
        border-top: 2px solid #007bff;
        padding-top: 20px;
        margin-top: 25px;
    }
    
    .productextracontentmanager-wrapper[data-hook="displayProductExtraContent"] {
        background: linear-gradient(135deg, #f8f9ff 0%, #e6f3ff 100%);
        padding: 20px;
        border-radius: 12px;
        margin: 25px 0;
    }
    
    .productextracontentmanager-wrapper[data-hook="displayProductAdditionalInfo"] {
        border-left: 4px solid #28a745;
        padding-left: 20px;
        background: #f8fff9;
    }
    
    /* Animaciones suaves */
    .productextracontentmanager-item {
        animation: fadeInUp 0.6s ease;
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
    
    /* Print styles */
    @media print {
        .productextracontentmanager-wrapper {
            break-inside: avoid;
            margin: 10px 0;
        }
        
        .productextracontentmanager-item {
            background: white !important;
            border: 1px solid #000 !important;
            box-shadow: none !important;
            transform: none !important;
        }
        
        .productextracontentmanager-img {
            max-width: 100px !important;
            max-height: 100px !important;
        }
    }
    
    /* Accesibilidad mejorada */
    .productextracontentmanager-text a {
        color: #007bff;
        text-decoration: underline;
        font-weight: 600;
    }
    
    .productextracontentmanager-text a:hover,
    .productextracontentmanager-text a:focus {
        color: #0056b3;
        text-decoration: none;
        outline: 2px solid #007bff;
        outline-offset: 2px;
    }
    
    /* Soporte para modo oscuro */
    @media (prefers-color-scheme: dark) {
        .productextracontentmanager-item {
            background: #2c3e50;
            border-color: #34495e;
            color: #ecf0f1;
        }
        
        .productextracontentmanager-item:hover {
            background: #34495e;
            border-color: #3498db;
        }
        
        .productextracontentmanager-text .pv_single {
            background: #34495e;
            border-color: #4a5f7a;
            color: #ecf0f1;
        }
        
        .productextracontentmanager-text .pv_single:hover {
            background: #4a5f7a;
            border-color: #3498db;
        }
        
        .productextracontentmanager-text .pv_label {
            color: #ecf0f1;
        }
        
        .productextracontentmanager-text .pv_label strong {
            color: #3498db;
        }
        
        .productextracontentmanager-text .pv_value {
            color: #bdc3c7;
        }
    }
    </style>
{/if}