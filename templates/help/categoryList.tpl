{extends "layout.tpl"}

{block "title"}{cap}{t}title-help-categories{/t}{/cap}{/block}

{block "content"}
  <div class="container my-5">
    <h1 class="mb-5">{cap}{t}title-help-categories{/t}{/cap}</h1>

    <form method="post">
      <table class="table table-hover mt-3 sortable">
        <tbody>
          {foreach $categories as $c}
            <tr class="d-flex">
              <td class="col-1">
                <input type="hidden" name="categoryIds[]" value="{$c->id}">
                {include "bits/icon.tpl" i=drag_indicator class="drag-indicator pt-0"}
              </td>

              <td class="col-11">
                {$c->getName()}
              </td>
            </tr>
          {/foreach}
        </tbody>
      </table>

      {include "bs/actions.tpl"
        cancelLink=Router::link('help/index')
        saveButtonText="{t}link-save-order{/t}"}

    </form>
  </div>
{/block}
