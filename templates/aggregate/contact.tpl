{extends "layout.tpl"}

{block "title"}{cap}{t}title-contact{/t}{/cap}{/block}

{block "content"}
  <div class="container my-5">
    {$staticResource->getContents()}
  </div>
{/block}
