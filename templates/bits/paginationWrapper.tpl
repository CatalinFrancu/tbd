{* @param $n number of pages *}
{* @param $k current page *}
{* @param $url URL to call for the page contents *}
{* @param $target element to overwrite with the page contents *}

{* When we print the initial page we include this template. Subsequent *}
{* refreshes via Ajax will include only pagination.tpl. *}
<div
  class="pagination-wrapper mt-3"
  data-url="{$url}"
  data-bs-target="{$target}">

  {include "bs/pagination.tpl" k=1}
</div>
