<#macro kw checked=false id="" label="" rest...>
  <div>
    <input
      <#if checked>checked</#if>

      class="border-secondary-200 focus:ring-primary-600 dark:bg-secondary-800 dark:border-secondary-600"
      id="${id}"
      type="radio"

      <#list rest as attrName, attrValue>
        ${attrName}="${attrValue}"
      </#list>
    >
    <label class="ml-2 text-secondary-600 dark:text-secondary-300 text-sm" for="${id}">
      ${label}
    </label>
  </div>
</#macro>
