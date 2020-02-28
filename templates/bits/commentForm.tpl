<form id="commentForm" class="mt-1">
  <input type="hidden" name="objectType">
  <input type="hidden" name="objectId">

  <div class="form-group">
    <textarea
      name="contents"
      class="form-control"
      rows="2"
      maxlength="{Comment::MAX_LENGTH}"
    ></textarea>
    <small class="form-text text-muted float-left">
      <span class="charsRemaining">{Comment::MAX_LENGTH}</span>
      {t}label-characters-remaining{/t}
    </small>
    {include "bits/markdownHelp.tpl"}
  </div>

  <button type="submit" class="btn btn-primary commentSaveButton btn-sm">
    <i class="icon icon-floppy"></i>
    {t}link-save{/t}
  </button>

  <button type="button" class="btn btn-link commentCancelButton">
    <i class="icon icon-cancel"></i>
    {t}link-cancel{/t}
  </button>
</form>
