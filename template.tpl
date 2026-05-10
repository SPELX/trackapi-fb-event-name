___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "TrackAPI - FB Event Name",
  "categories": [
    "ANALYTICS",
    "CONVERSIONS"
  ],
  "description": "Maps GTM events to valid Facebook Pixel event names. Filters internal GTM events (gtm.*) and maps gtm.js to PageView. Set the \u0027GTM Event\u0027 field to the {{Event}} built-in variable.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "gtmEvent",
    "displayName": "GTM Event (required)",
    "simpleValueType": true,
    "defaultValue": "{{Event}}",
    "help": "Set to the GTM built-in variable {{Event}}. This ensures internal GTM events like gtm.historyChange are correctly filtered inside the sandboxed template.",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

var makeString = require('makeString');

// The GTM built-in {{Event}} variable must be passed as the "gtmEvent" parameter.
// It is evaluated BEFORE the sandboxed context, so it always has the correct
// event name — including internal GTM events like gtm.historyChange.
var ev = makeString(data.gtmEvent || '');

// Only these 3 lifecycle events signal a real page load → PageView
if (ev === 'gtm.js' || ev === 'gtm.dom' || ev === 'gtm.load') {
  return 'PageView';
}

// All other gtm.* events (gtm.historyChange, gtm.scrollDepth, gtm.click,
// gtm.elementVisibility, etc.) must NOT fire the pixel.
// Returning '' causes the tag to receive an empty Event Name, which the
// native Meta Pixel tag skips when Disable Automatic Configuration is on.
if (ev.indexOf('gtm.') === 0) {
  return '';
}

// Empty event names must not fire the pixel
if (!ev) {
  return '';
}

// Business events pass as-is (Lead, Purchase, AddToCart, PageView, etc.)
return ev;


___TESTS___

scenarios: []


___NOTES___

## TrackAPI - FB Event Name — GTM Variable Template

Filtra e mapeia eventos GTM para nomes válidos do Facebook Pixel.

### Como funciona

- `gtm.js`, `gtm.dom`, `gtm.load` → retorna `'PageView'` (carregamento real de página)
- Demais `gtm.*` (`gtm.historyChange`, `gtm.scrollDepth`, `gtm.click`, etc.) → retorna `''` (tag não dispara)
- Eventos de negócio (`Lead`, `Purchase`, `AddToCart`, `PageView`, etc.) → retorna o nome original
- Evento vazio → retorna `''` (tag não dispara)

### Setup

1. Importe este template como Variável no GTM
2. No campo **GTM Event**, configure: `{{Event}}` (variável built-in do GTM)
3. Salve como "TrackAPI - FB Event Name"
4. Na tag **Meta Pixel**, campo "Event Name" → `{{TrackAPI - FB Event Name}}`
5. No campo "Event ID" → `{{TrackAPI - Event ID}}` para deduplicação

Nenhum trigger de exceção necessário — funciona plug and play.

### Documentação completa

https://trackapi.app.br/docs


