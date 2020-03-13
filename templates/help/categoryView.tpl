{extends "layout.tpl"}

{block "title"}{cap}{$category->name}{/cap} - {cap}{t}help-center{/t}{/cap}{/block}

{block "content"}
  <div class="row">
    <div class="col-md-8 mb-3">

      <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
          <li class="breadcrumb-item">
            <a href="{Router::link('help/index')}">
              {cap}{t}help-center{/t}{/cap}
            </a>
          </li>
          <li class="breadcrumb-item active">
            {cap}{$category->name}{/cap}
          </li>
        </ol>
      </nav>

      <h3>{$category->name}</h3>

      {foreach $category->getPages() as $p}
        <div>
          <a href="{Router::helpLink($p)}">{$p->title}</a>
        </div>
      {/foreach}

      {if User::isModerator()}
        <div class="mt-2">
          <a
            class="btn btn-sm btn-outline-secondary"
            href="{Router::link('help/categoryEdit')}/{$category->id}">
            <i class="icon icon-edit"></i>
            {t}link-edit{/t}
          </a>
        </div>
      {/if}
    </div>

    <div class="col-md-4">
      {include "bits/helpSidebar.tpl" activeCategoryId=$category->id}
    </div>
  </div>
{/block}
