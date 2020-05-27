{if count($actions)}
  <h6 class="mt-4 pb-2 pl-0 answer-label text-uppercase font-weight-bold">
    {t}actions{/t}
  </h6>

  <div class="row py-1">
    <div class="col font-weight-bold">
      {t}label-date{/t}
    </div>
    <div class="col font-weight-bold">
      {t}label-action{/t}
    </div>
  </div>

  {foreach $actions as $a}
    <div class="row row-border small py-1">
      <div class="col-md-2">
        {include "bits/moment.tpl" t=$a->createDate}
      </div>
      <div class="col-md-10">
        {$obj=$a->getObject()}
        {if !$obj}   {* Underlying object has been deleted *}
          {$a->getTypeName()}
          {$a->description|escape}
        {elseif $a->objectType == Proto::TYPE_ANSWER}
          {$a->getTypeName()}
          <a href="{Router::getViewLink($obj)}">
            {t}action-type-answer{/t}
          </a>
          <div class="text-muted">
            {$obj->contents|shorten:120}
          </div>
        {elseif $a->objectType == Proto::TYPE_ENTITY}
          {$a->getTypeName()}
          {include "bits/entityLink.tpl" e=$obj}
        {elseif $a->objectType == Proto::TYPE_STATEMENT}
          {$a->getTypeName()}
          {include "bits/statementLink.tpl" statement=$obj quotes=false}
        {elseif $a->objectType == Proto::TYPE_TAG}
          {$a->getTypeName()}
          {include "bits/tag.tpl" t=$obj link=true}
        {elseif $a->objectType == Proto::TYPE_USER}
          {t}action-updated-user-profile{/t}
        {/if}
      </div>
    </div>
  {/foreach}
{/if}
