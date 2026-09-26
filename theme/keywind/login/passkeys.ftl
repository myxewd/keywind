<#import "/assets/icons/key.ftl" as iconKey>

<#--
  Keycloak 26.4+ passkey (WebAuthn passwordless) support.

  conditionalUIData: hidden forms + WebAuthn conditional-UI bootstrap. Render it inside a
  page's "form" section but outside the login form (it contains its own form elements).
  button: the manual key-icon trigger, rendered by the layout nav.
-->
<#macro conditionalUIData>
  <#if (enableWebAuthnConditionalUI!'')?has_content>
    <form id="webauth" action="${url.loginAction}" method="post">
      <input id="clientDataJSON" name="clientDataJSON" type="hidden" />
      <input id="authenticatorData" name="authenticatorData" type="hidden" />
      <input id="signature" name="signature" type="hidden" />
      <input id="credentialId" name="credentialId" type="hidden" />
      <input id="userHandle" name="userHandle" type="hidden" />
      <input id="error" name="error" type="hidden" />
    </form>

    <#-- Rendered even when empty so the shared scripts never hit an undefined form. -->
    <form id="authn_select">
      <#if authenticators??>
        <#list authenticators.authenticators as authenticator>
          <input name="authn_use_chk" type="hidden" value="${authenticator.credentialId}" />
        </#list>
      </#if>
    </form>

    <#--
      WebAuthn parameters travel as HTML-escaped data attributes instead of being
      interpolated into the script source, so no value can escape the <script> element.
    -->
    <div
      data-challenge="${(challenge!'')}"
      data-create-timeout="${(createTimeout!0)?c}"
      data-is-user-identified="${isUserIdentified!false}"
      data-resources-path="${(url.resourcesPath!'')}"
      data-rp-id="${(rpId!'')}"
      data-unsupported-text="${msg('passkey-unsupported-browser-text')}"
      data-unsupported-text-webauthn="${msg('webauthn-unsupported-browser-text')}"
      data-user-verification="${userVerification!'not specified'}"
      hidden
      id="kc-passkeys"
    ></div>

    <script type="module">
      (async () => {
        const data = document.getElementById('kc-passkeys');
        const button = document.getElementById('authenticateWebAuthnButton');

        // Without the payload there is nothing to authenticate with.
        if (!data) {
          if (button) button.remove();
          return;
        }

        const resourcesPath = data.dataset.resourcesPath || '';
        let authenticateByWebAuthn;
        let initAuthenticate;

        try {
          ({ authenticateByWebAuthn } = await import(resourcesPath + '/js/webauthnAuthenticate.js'));
          ({ initAuthenticate } = await import(resourcesPath + '/js/passkeysConditionalAuth.js'));
        } catch (error) {
          // Shared WebAuthn scripts unavailable: drop the trigger instead of leaving it dead.
          if (button) button.remove();
          return;
        }

        const timeout = Number.parseInt(data.dataset.createTimeout, 10);
        const args = {
          challenge: data.dataset.challenge || '',
          createTimeout: Number.isFinite(timeout) ? timeout : 0,
          isUserIdentified: data.dataset.isUserIdentified === 'true',
          rpId: data.dataset.rpId || '',
          userVerification: data.dataset.userVerification || 'not specified',
        };

        const startConditionalUI = () => {
          try {
            initAuthenticate({ ...args, errmsg: data.dataset.unsupportedText || '' });
          } catch (error) {
            // Conditional UI is a progressive enhancement; the key button still works.
          }
        };

        if (document.readyState === 'loading') {
          document.addEventListener('DOMContentLoaded', startConditionalUI, { once: true });
        } else {
          startConditionalUI();
        }

        if (button) {
          button.addEventListener('click', (event) => {
            event.preventDefault();
            try {
              authenticateByWebAuthn({ ...args, errmsg: data.dataset.unsupportedTextWebauthn || '' });
            } catch (error) {
              // Failures are reported through the hidden form by the shared script.
            }
          });
        }
      })();
    </script>
  </#if>
</#macro>

<#macro button>
  <#if (enableWebAuthnConditionalUI!'')?has_content>
    <button
      aria-label="${msg('passkey-doAuthenticate')}"
      class="flex items-center text-secondary-600 hover:text-secondary-900 dark:text-secondary-300 dark:hover:text-white"
      id="authenticateWebAuthnButton"
      title="${msg('passkey-doAuthenticate')}"
      type="button"
    >
      <@iconKey.kw />
    </button>
    <script>
      // Remove the trigger on pages that never render the WebAuthn payload for it.
      (function () {
        var button = document.getElementById('authenticateWebAuthnButton');
        if (button && !document.getElementById('kc-passkeys')) {
          button.remove();
        }
      })();
    </script>
  </#if>
</#macro>
