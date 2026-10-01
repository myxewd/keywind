<#macro kw>
  <#--
    A single <img> is used on purpose: rendering two images (one per colour scheme) and
    hiding one with CSS would still make the browser download both. The inline script runs
    right after the element and resolves the source before the browser requests anything,
    so exactly one image is fetched. A MutationObserver keeps it in sync when the theme
    toggle flips the "dark" class on <html>.
  -->
  <img
    alt=""
    class="h-12 w-12"
    data-logo-dark="${url.resourcesPath}/img/wuxiaoyou-dark.png"
    data-logo-light="${url.resourcesPath}/img/wuxiaoyou-light.png"
    id="kc-logo"
  />
  <script>
    (function () {
      var logo = document.getElementById('kc-logo');
      if (!logo) return;

      var apply = function () {
        var next = document.documentElement.classList.contains('dark')
          ? logo.dataset.logoDark
          : logo.dataset.logoLight;

        if (next && logo.getAttribute('src') !== next) {
          logo.setAttribute('src', next);
        }
      };

      apply();

      if (window.MutationObserver) {
        new MutationObserver(apply).observe(document.documentElement, {
          attributeFilter: ['class'],
          attributes: true,
        });
      }
    })();
  </script>
  <noscript>
    <img alt="" class="h-12 w-12" src="${url.resourcesPath}/img/wuxiaoyou-light.png" />
  </noscript>
</#macro>
