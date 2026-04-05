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
  "description": "Mapeia eventos GTM para nomes válidos do Facebook Pixel. Filtra eventos internos do GTM (gtm.*) e mapeia gtm.js como PageView. Configure o campo \u0027GTM Event\u0027 com a variável {{Event}} do GTM.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "gtmEvent",
    "displayName": "GTM Event (obrigatório)",
    "simpleValueType": true,
    "help": "Configure com a variável built-in {{Event}} do GTM. Isso garante que eventos internos como gtm.historyChange sejam corretamente filtrados no ambiente sandboxed.",
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

// All GTM internal events (gtm.js, gtm.dom, gtm.load, gtm.historyChange)
// are page lifecycle events — map them all to PageView.
// Deduplication via {{TrackAPI - Event ID}} ensures Meta counts only one
// PageView per page load, even if multiple gtm.* events fire.
if (ev.indexOf('gtm.') === 0) {
  return 'PageView';
}

// Empty event names should not fire the Pixel
if (!ev) {
  return 'PageView';
}

// Business events pass as-is (Lead, Purchase, AddToCart, PageView, etc.)
return ev;


___TESTS___

scenarios: []


___NOTES___

## TrackAPI - FB Event Name — GTM Variable Template

Filtra e mapeia eventos GTM para nomes válidos do Facebook Pixel.

### Como funciona

- Todos os eventos `gtm.*` (gtm.js, gtm.dom, gtm.load, gtm.historyChange)
  → retorna `'PageView'`
- Eventos de negócio (Lead, Purchase, AddToCart) → retorna o nome original
- A deduplicação pelo {{TrackAPI - Event ID}} garante que o Meta conte
  apenas 1 PageView por carregamento, mesmo com múltiplos eventos gtm.*

### Setup

1. Importe este template como Variável no GTM
2. No campo **GTM Event**, configure: `{{Event}}` (variável built-in do GTM)
3. Salve como "TrackAPI - FB Event Name"
4. Na tag **Meta Pixel**, campo "Event Name" → `{{TrackAPI - FB Event Name}}`
5. No campo "Event ID" → `{{TrackAPI - Event ID}}` para deduplicação

Nenhum trigger de exceção necessário — funciona plug and play.

### Documentação completa

https://trackapi.app.br/docs


