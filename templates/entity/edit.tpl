{extends "layout.tpl"}

{capture "title"}
{if $entity->id}
  {t}title-edit-entity{/t}
{else}
  {t}title-add-entity{/t}
{/if}
{/capture}

{block "title"}{cap}{$smarty.capture.title}{/cap}{/block}

{block "content"}
  <h1 class="mb-5">{$smarty.capture.title}</h1>

  {if !$entity->isEditable()}
    <div class="alert alert-warning">
      {$entity->getEditMessage()}
    </div>
  {/if}

  <form method="post" enctype="multipart/form-data">
    <input type="hidden" name="id" value="{$entity->id}">
    <input type="hidden" name="referrer" value="{$referrer}">

    <div class="common-region mb-5">
      <div class="form-group row highlight-field py-1 pr-1">
        <label for="field-name" class="col-2 ml-0 mt-2">{t}label-name{/t}</label>
        <input
          name="name"
          value="{$entity->name|escape}"
          id="field-name"
          class="form-control {if isset($errors.name)}is-invalid{/if} col-10">
        {include "bits/fieldErrors.tpl" errors=$errors.name|default:null}
      </div>

      <div class="form-group row highlight-field py-1">
        <label class="col-2 ml-0 mt-2">{t}label-alias{/t}</label>
        <div class="col-10 pl-0 mt-1 mb-2">
          <button id="add-alias" class="btn btn-outline-secondary btn-sm" type="button">
            <i class="icon icon-plus"></i>
            {t}link-add-alias{/t}
          </button>
        </div>

        <table class="table table-sm sortable col-md-10 offset-md-2">
          <thead
            id="alias-header"
            {if empty($aliases)}hidden{/if}>
            <tr>
              <th class="border-0">{t}label-order{/t}</th>
              <th class="border-0">{t}label-alias{/t}</th>
              <th class="border-0">{t}actions{/t}</th>
            </tr>
          </thead>
          <tbody id="alias-container">
            {include "bits/aliasEdit.tpl" id="stem-alias"}
            {foreach $aliases as $a}
              {include "bits/aliasEdit.tpl" alias=$a}
            {/foreach}
          </tbody>
        </table>
      </div>

    </div>

    <div class="common-region mb-5">
      <div class="form-group row highlight-field py-1 pr-1">
        <label for="field-entity-type-id" class="col-2 ml-0 mt-2">{t}label-type{/t}</label>
        <select
          name="entityTypeId"
          id="field-entity-type-id"
          class="form-control col-10 {if isset($errors.entityTypeId)}is-invalid{/if}"
          data-change-msg="{t}info-change-entity-type-while-relations-exist{/t}">
          {foreach $entityTypes as $et}
            <option
              value="{$et->id}"
              data-has-color="{$et->hasColor}"
              {if $entity->entityTypeId == $et->id}selected{/if}>
              {$et->name|escape}
            </option>
          {/foreach}
        </select>
        {include "bits/fieldErrors.tpl" errors=$errors.type|default:null}
      </div>

      <div id="color-wrapper"
        class="form-group""
        {if !$entity->hasColor()}hidden{/if}>
        <label for="field-color">{t}label-color{/t}</label>
        <div class="input-group colorpicker-component">
          <span class="input-group-prepend input-group-text colorpicker-input-addon">
            <i></i>
          </span>
          <input type="text"
            class="form-control"
            id="field-color"
            name="color"
            value="{$entity->getColor()}">
        </div>
      </div>

      <div class="form-group row highlight-field py-1 pr-1">
        <label class="col-2">{t}label-relations{/t}</label>
        <div class="col-10 pl-0 mb-2">
          <button id="add-relation" class="btn btn-outline-secondary btn-sm" type="button">
            <i class="icon icon-plus"></i>
            {t}label-add-relation{/t}
          </button>
        </div>

        <table class="table table-sm table-rel sortable col-md-10 offset-md-2">
          <thead
            id="relation-header"
            {if empty($relations)}hidden{/if}>
            <tr>
              <th class="border-0">{t}label-order{/t}</th>
              <th class="border-0">{t}label-type{/t}</th>
              <th class="border-0">{t}label-target{/t}</th>
              <th class="border-0">{t}label-start-date{/t}</th>
              <th class="border-0">{t}label-end-date{/t}</th>
              <th class="border-0">{t}actions{/t}</th>
            </tr>
          </thead>
          <tbody id="relation-container">
            {$entityTypeId=$entity->getEntityType()->id|default:$entityTypes[0]->id}
            {include "bits/relationEdit.tpl" id="stem-relation"}
            {foreach $relations as $r}
              {include "bits/relationEdit.tpl" relation=$r}
            {/foreach}
          </tbody>
        </table>

        {include "bits/fieldErrors.tpl" errors=$errors.relations|default:null}

      </div>
    </div>

    <div class="common-region mb-5">
      <div class="form-group row highlight-field py-1">
        <label for="field-profile" class="col-2 mt-3">{t}label-profile{/t}</label>
        <div class="col-10 pl-0">
          <textarea
            id="field-profile"
            name="profile"
            class="form-control has-unload-warning size-limit easy-mde"
            maxlength="{Entity::PROFILE_MAX_LENGTH}"
            rows="5">{$entity->profile|escape}</textarea>

          <small class="form-text text-muted float-left">
            <span class="chars-remaining">{$profileCharsRemaining}</span>
            {t}label-characters-remaining{/t}
          </small>
          {include "bits/markdownHelp.tpl"}
          {include "bits/fieldErrors.tpl" errors=$errors.profile|default:null}
        </div>
      </div>

      {capture "labelText" assign=labelText}{t}label-entity-links{/t}{/capture}
      {capture "addButtonText" assign=addButtonText}{t}link-add-entity-link{/t}{/capture}
      {include "bits/linkEditor.tpl"
        errors=$errors.links|default:null
      }

    </div>

    <div class="common-region mb-5">
      <div class="form-group row highlight-field">
        <label class="col-2 mt-2">{t}label-tags{/t}</label>
        <div class="col-10 pl-0">
          <select name="tagIds[]" class="form-control select2Tags" multiple>
            {foreach $tagIds as $tagId}
              <option value="{$tagId}" selected></option>
            {/foreach}
          </select>
        </div>
      </div>

      <div class="form-group row highlight-field py-1">
        <label class="col-2" for="field-image">{t}label-image{/t}</label>

        <div class="col-10 pl-0">
          <div class="custom-file">
            <input
              name="image"
              type="file"
              class="custom-file-input {if isset($errors.image)}is-invalid{/if}"
              id="field-image">
            <label class="custom-file-label" for="field-image">
              {t}info-upload-image{/t}
            </label>
          </div>
          {include "bits/fieldErrors.tpl" errors=$errors.image|default:null}

          <div class="form-check">
            <label class="form-check-label">
              <input type="checkbox" name="deleteImage" class="form-check-input">
              {t}label-delete-image{/t}
            </label>
          </div>

          {include "bits/image.tpl"
            obj=$entity
            geometry=Config::THUMB_ENTITY_LARGE
            spanClass="col-3"
            imgClass="pic float-right"}
        </div>
      </div>
    </div>

    <div class="mt-4">
      <button name="saveButton" type="submit" class="btn btn-sm btn-outline-primary">
        <i class="icon icon-floppy"></i>
        {t}link-save{/t}
      </button>

      <a href="{$referrer}" class="btn btn-sm btn-outline-secondary">
        <i class="icon icon-cancel"></i>
        {t}link-cancel{/t}
      </a>

      <div class="float-right">
        {if $entity->isDeletable()}
          <button
            name="deleteButton"
            type="submit"
            class="btn btn-sm btn-outline-danger"
            data-confirm="{t}info-confirm-delete-entity{/t}">
            <i class="icon icon-trash"></i>
            {t}link-delete{/t}
          </button>
        {/if}

        {if $entity->isReopenable()}
          <button
            name="reopenButton"
            type="submit"
            class="btn btn-sm btn-outline-secondary"
            data-confirm="{t}info-confirm-reopen-entity{/t}">
            {t}link-reopen{/t}
          </button>
        {/if}
      </div>
    </div>

  </form>
{/block}
