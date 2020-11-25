{extends "layout.tpl"}

{block "title"}{cap}{t}title-static-resources{/t}{/cap}{/block}

{block "content"}
  <div class="container my-5">
    <h1 class="mb-5">{cap}{t}title-static-resources{/t}{/cap}</h1>

    <a class="btn btn-sm btn-outline-primary" href="{Router::link('staticResource/edit')}">
      <i class="icon icon-plus"></i>
      {t}link-add-static-resource{/t}
    </a>

    {if count($staticResources)}
      <table class="table table-hover mt-5 mb-4">
        <thead>
          <tr class="small">
            <th class="border-0">{t}label-name{/t}</th>
            <th class="border-0">{t}label-locale{/t}</th>
            <th class="border-0">{t}label-url{/t}</th>
            <th class="border-0">{t}actions{/t}</th>
          </tr>
        </thead>
        <tbody>
          {foreach $staticResources as $sr}
            <tr class="small">
              <td class="align-middle">{$sr->name|escape}</td>
              <td class="align-middle">
                {if $sr->locale}
                  {LocaleUtil::getDisplayName($sr->locale)|escape}
                {else}
                  {t}label-all-locales{/t}
                {/if}
              </td>
              <td>
                <a href="{$sr->getUrl()}" class="btn btn-sm btn-link">
                  {t}label-url{/t}
                </a>
              </td>
              <td>
                <a
                  href="{$sr->getEditUrl()}"
                  class="btn"
                  title="{t}link-edit{/t}">
                  <i class="icon icon-pencil"></i>
                </a>
              </td>
            </tr>
          {/foreach}
        </tbody>
      </table>
    {/if}
  </div>
{/block}
