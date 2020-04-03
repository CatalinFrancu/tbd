{extends "layout.tpl"}

{block "title"}{t}title-edit-canned-response{/t}{/block}

{block "content"}
  <h3>{t}title-edit-canned-response{/t}</h3>

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

    <div>
      <button name="saveButton" type="submit" class="btn btn-primary">
        <i class="icon icon-floppy"></i>
        {t}link-save{/t}
      </button>

      <a href="{Router::link('cannedResponse/list')}" class="btn btn-light">
        <i class="icon icon-cancel"></i>
        {t}link-cancel{/t}
      </a>

      {if $cannedResponse->id}
        <button
          name="deleteButton"
          type="submit"
          class="btn btn-danger float-right"
          data-confirm="{t}info-confirm-delete-canned-response{/t}">
          <i class="icon icon-trash"></i>
          {t}link-delete{/t}
        </button>
      {/if}
    </div>
  </form>
{/block}