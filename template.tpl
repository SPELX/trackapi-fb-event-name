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
  "description": "Mapeia eventos GTM para nomes válidos do Facebook Pixel. Filtra eventos internos do GTM (gtm.*) e mapeia gtm.js como PageView. Use no campo Event Name da tag nativa do Facebook Pixel para evitar disparos indevidos.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

var copyFromDataLayer = require('copyFromDataLayer');

var ev = copyFromDataLayer('event') || '';

// Bloqueia eventos internos do GTM (gtm.dom, gtm.load, gtm.historyChange, etc.)
// Retornar undefined impede o disparo da tag do Facebook Pixel
if (ev.indexOf('gtm.') === 0 && ev !== 'gtm.js') {
  return undefined;
}

// Mapeia gtm.js (carregamento inicial do GTM) como PageView
// Garante que o Pixel dispare um PageView no carregamento da página,
// após o GTM estar completamente inicializado
if (ev === 'gtm.js') {
  return 'PageView';
}

// Eventos de negócio passam como estão (Lead, Purchase, AddToCart, etc.)
return ev;


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_data_layer",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedKeys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "event"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {},
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

## TrackAPI - FB Event Name — GTM Variable Template

Filtra e mapeia eventos GTM para nomes válidos do Facebook Pixel.

### Por que é necessário?

A tag nativa do Facebook Pixel no GTM dispara em TODOS os eventos do dataLayer por padrão
— incluindo eventos internos do GTM como gtm.dom, gtm.load e gtm.historyChange.
Sem este filtro, o Pixel dispararia eventos falsos e PageViews duplicados.

Esta variável:
- Retorna `undefined` para eventos internos (gtm.*) → impede o disparo da tag
- Retorna `'PageView'` para `gtm.js` → disparo correto no carregamento inicial da página
- Retorna o nome original para eventos de negócio (Lead, Purchase, AddToCart, etc.)

### Como usar

1. No GTM, importe este template como Variável e salve como "TrackAPI - FB Event Name"
2. Na tag nativa do **Facebook Pixel**, configure:
   - Campo "Event Name" → Variável → {{TrackAPI - FB Event Name}}
3. Use junto com {{TrackAPI - Event ID}} no campo Event ID para deduplicação correta com o TrackAPI CAPI

### Fluxo completo com deduplicação

```
GTM dispara
  ├─ Tag TrackAPI Analytics: SDK → CAPI (event_id: evt_123, event: 'Purchase')
  └─ Tag Facebook Pixel nativa:
       Event Name  → {{TrackAPI - FB Event Name}}  → 'Purchase'
       Event ID    → {{TrackAPI - Event ID}}        → evt_123 (mesmo ID)
Meta Events Manager: event_id idêntico → 1 conversão contabilizada ✅
```

### Documentação completa

https://trackapi.app.br/docs


