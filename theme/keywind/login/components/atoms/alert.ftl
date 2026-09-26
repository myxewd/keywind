<#macro kw color="">
  <#switch color>
    <#case "error">
      <#assign colorClass="bg-red-100 text-red-600 dark:bg-red-500/20 dark:text-red-300">
      <#break>
    <#case "info">
      <#assign colorClass="bg-blue-100 text-blue-600 dark:bg-blue-500/20 dark:text-blue-300">
      <#break>
    <#case "success">
      <#assign colorClass="bg-green-100 text-green-600 dark:bg-green-500/20 dark:text-green-300">
      <#break>
    <#case "warning">
      <#assign colorClass="bg-orange-100 text-orange-600 dark:bg-orange-500/20 dark:text-orange-300">
      <#break>
    <#default>
      <#assign colorClass="bg-blue-100 text-blue-600 dark:bg-blue-500/20 dark:text-blue-300">
  </#switch>

  <div class="${colorClass} p-4 rounded-lg text-sm" role="alert">
    <#nested>
  </div>
</#macro>
