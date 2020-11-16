{extends "layout.tpl"}

{block "title"}{t}title-edit-canned-response{/t}{/block}

{block "content"}
  <div class="container my-5">
    <h1 class="mb-4">{t}title-edit-canned-response{/t}</h1>

    <form method="post">

      <div class="form-group">
        <label for="field-contents">{t}label-contents{/t}</label>
        <textarea
          id="field-contents"
          name="contents"
          class="form-control has-unload-warning size-limit easy-mde"
          maxlength="{Comment::MAX_LENGTH}"
        >{$cannedResponse->contents|escape}</textarea>
        <small class="form-text text-muted float-left">
          <span class="chars-remaining">{$charsRemaining}</span>
          {t}label-characters-remaining{/t}
        </small>
        {include "bits/markdownHelp.tpl"}
        {include "bits/fieldErrors.tpl" errors=$errors.contents|default:null}
      </div>

      <div class="mt-4 text-right">
        {if $cannedResponse->id}
          <button
            name="deleteButton"
            type="submit"
            class="btn btn-sm btn-outline-danger col-sm-3 col-lg-2 mr-2 mb-2"
            data-confirm="{t}info-confirm-delete-canned-response{/t}">
            <i class="icon icon-trash"></i>
            {t}link-delete{/t}
          </button>
        {/if}

        <a href="{Router::link('cannedResponse/list')}" class="btn btn-sm btn-outline-secondary col-sm-3 col-lg-2 mr-2 mb-2">
          <i class="icon icon-cancel"></i>
          {t}link-cancel{/t}
        </a>

        <button name="saveButton" type="submit" class="btn btn-sm btn-outline-primary col-sm-3 col-lg-2 mb-2">
          <i class="icon icon-floppy"></i>
          {t}link-save{/t}
        </button>
      </div>
    </form>
  </div>
{/block}
