# TrackAPI - FB Event Name (GTM Variable Template)

Variável para Google Tag Manager que filtra e mapeia eventos GTM para nomes válidos do Facebook Pixel. Evita disparos indevidos em eventos internos do GTM.

## O problema que resolve

A tag nativa do **Facebook Pixel** no GTM dispara em **todos** os eventos do dataLayer — incluindo eventos internos como `gtm.dom`, `gtm.load` e `gtm.historyChange`. Sem filtro, o Pixel gera PageViews e eventos falsos em momentos indevidos.

## Como funciona

| Evento GTM | Retorno | Resultado |
|---|---|---|
| `gtm.dom`, `gtm.load`, etc. | `undefined` | Tag não dispara |
| `gtm.js` (carregamento inicial) | `'PageView'` | Pixel dispara PageView |
| `Lead`, `Purchase`, `AddToCart`, etc. | o próprio nome | Pixel dispara normalmente |

## Como usar

1. No GTM, vá em **Modelos → Novo → ⋮ → Importar**
2. Importe `template.tpl` → salve como **"TrackAPI - FB Event Name"**
3. Na tag nativa do **Facebook Pixel**, configure:
   - Campo **Event Name** → Variável → `{{TrackAPI - FB Event Name}}`

## Uso recomendado com deduplicação

Para deduplicação correta entre browser Pixel e TrackAPI CAPI, configure a tag do Facebook Pixel com ambas as variáveis:

```
Tag: Facebook Pixel (nativa GTM)
  Event Name → {{TrackAPI - FB Event Name}}
  Event ID   → {{TrackAPI - Event ID}}
  Trigger    → All Pages
```

O resultado:

```
GTM dispara
  ├─ Tag TrackAPI Analytics: SDK → CAPI (event_id: evt_123)
  └─ Tag Facebook Pixel:
       Event Name → 'Purchase'     (via {{TrackAPI - FB Event Name}})
       Event ID   → 'evt_123'      (via {{TrackAPI - Event ID}})

Meta Events Manager: mesmo event_id → 1 conversão ✅
```

## Templates relacionados

| Template | Tipo | O que faz |
|---|---|---|
| **TrackAPI Analytics** | Tag | Carrega o SDK e inicializa com Project ID e Endpoint |
| **TrackAPI - Event ID** | Variável | Gera event_id com cache de 8s para deduplicação |
| **TrackAPI - FB Event Name** | Variável | Filtra e mapeia eventos para o Facebook Pixel |

## Documentação completa

https://trackapi.app.br/docs
