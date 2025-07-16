<div class="category-item">
    <label>
        <input type="checkbox" name="category_ids[]" value="{$category->id}" class="category-checkbox">
        {$category->name}
        <input type="number" name="category_position_{$category->id}" class="category-position form-control" 
               style="width: 80px; display: inline-block; margin-left: 10px;" 
               placeholder="Posición" disabled>
    </label>
    {if isset($children) && $children|count > 0}
        <ul class="category-children">
            {foreach from=$children item=child_category}
                <li>
                    {include file="./category_tree_item.tpl" category=$child_category}
                </li>
            {/foreach}
        </ul>
    {/if}
</div>