{extends "layout.tpl"}

{block "title"}{cap}{$page->title}{/cap} - {cap}{t}help-center{/t}{/cap}{/block}

{block "content"}
  <div class="container my-5">
    <div class="row">
      <div class="col-md-8 mb-3">

        <nav aria-label="breadcrumb">
          <ol class="breadcrumb">
            <li class="breadcrumb-item">
              <a href="{Router::link('help/index')}">
                {cap}{t}help-center{/t}{/cap}
              </a>
            </li>
            <li class="breadcrumb-item">
              <a href="{$category->getViewUrl()}">
                {cap}{$category->name}{/cap}
              </a>
            </li>
          </ol>
        </nav>

        <h1 class="mb-4">{$page->title}</h1>

        {$page->contents|md}


        {if User::isModerator()}
          <div class="mt-4 text-right">
            <a
              class="btn btn-sm btn-primary col-sm-12 col-md-3 mb-2"
              href="{Router::link('help/pageEdit')}/{$page->id}">
              {include "bits/icon.tpl" i=mode_edit}
              {t}link-edit{/t}
            </a>
            {include "bits/historyButton.tpl" obj=$page class="btn btn-sm btn-outline-secondary col-sm-12 col-md-3 mb-2"}
          </div>
        {/if}
      </div>

      <div class="col-md-4">
        {include "bits/helpSidebar.tpl" activePageId=$page->id}
      </div>
    </div>
  </div>
{/block}
