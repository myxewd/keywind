<#macro kw script="">
  <title>${msg("loginTitle", (realm.displayName!""))}</title>

  <meta charset="utf-8">
  <meta name="robots" content="noindex, nofollow">
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <script>
    (function () {
      try {
        var stored = localStorage.getItem('keywind-theme');
        var dark = stored ? stored === 'dark' : window.matchMedia('(prefers-color-scheme: dark)').matches;
        if (dark) document.documentElement.classList.add('dark');
      } catch (e) {}
    })();
  </script>

  <script type="importmap">
    {
      "imports": {
        "rfc4648": "${url.resourcesCommonPath}/vendor/rfc4648/rfc4648.js"
      }
    }
  </script>

  <#if properties.meta?has_content>
    <#list properties.meta?split(" ") as meta>
      <meta name="${meta?split('==')[0]}" content="${meta?split('==')[1]}">
    </#list>
  </#if>

  <#-- favicons entries are "path==rel", optionally followed by "==type" and "==sizes" -->
  <#if properties.favicons?has_content>
    <#list properties.favicons?split(" ") as favicon>
      <#if favicon?has_content>
        <#assign faviconAttrs = favicon?split("==")>
        <#if faviconAttrs?size == 2>
          <link href="${url.resourcesPath}/${faviconAttrs[0]}" rel="${faviconAttrs[1]}">
        <#elseif faviconAttrs?size == 3>
          <link href="${url.resourcesPath}/${faviconAttrs[0]}" rel="${faviconAttrs[1]}" type="${faviconAttrs[2]}">
        <#elseif faviconAttrs?size gte 4>
          <link href="${url.resourcesPath}/${faviconAttrs[0]}" rel="${faviconAttrs[1]}" type="${faviconAttrs[2]}" sizes="${faviconAttrs[3]}">
        </#if>
      </#if>
    </#list>
  </#if>

  <#if properties.styles?has_content>
    <#list properties.styles?split(" ") as style>
      <link href="${url.resourcesPath}/${style}" rel="stylesheet">
    </#list>
  </#if>

  <#if script?has_content>
    <script defer src="${url.resourcesPath}/${script}" type="module"></script>
  </#if>

  <#if properties.scripts?has_content>
    <#list properties.scripts?split(" ") as script>
      <script defer src="${url.resourcesPath}/${script}" type="module"></script>
    </#list>
  </#if>
</#macro>
