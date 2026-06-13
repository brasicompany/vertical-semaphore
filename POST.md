# Material de lançamento — VerticalSemaphore (Brasico open-source)

Rascunhos prontos para post de blog, thread no X, LinkedIn e release no GitHub.
Tom: design system honesto, com a história por trás do motivo. Visual vende —
sempre anexe o GIF do hover (luzes nativas aparecendo) + o `assets/preview.svg`.

---

## 1) Tweet/X — thread (PT)

**1/**
O semáforo de janela da Apple (🔴🟡🟢) é horizontal — perfeito pra titlebar,
errado pra uma barra lateral estreita ou uma aba.

Então a gente deitou ele. Vertical.

Abrindo o componente SwiftUI → 🧵

**2/**
Por que vertical?
App moderno nem sempre tem titlebar:
• barra lateral flutuante (sobra espaço vertical, não horizontal)
• aba que precisa de fechar/destacar sem um cluster largo
• canvas edge-to-edge, sem chrome

O semáforo vertical encaixa nos três — e mantém a linguagem de cor da Apple.

**3/**
Bônus: no macOS ele **esconde as luzes nativas** e as revela quando o cursor
entra no canto superior esquerdo (estilo Safari/Finder). Você fica com o seu
chrome custom E os controles do SO sob demanda.

**4/**
A parte de engenharia (a que dói):
revelar as luzes **move o layout**. Se o sensor de hover vivesse dentro do
layout, o reveal empurrava o sensor pra longe do cursor → esconde → relayout →
revela de novo. Flicker infinito.

**5/**
A correção: decidir pelo **cursor cru vs. o canto fixo da janela**, não por uma
região SwiftUI no layout. Desacopla sensoriamento de layout, mata a oscilação.

Bati nesse bug em produção. O fix está no repo.

**6/**
SwiftUI puro, macOS + iOS, ~3 arquivos, MIT.

```swift
VerticalSemaphore(onClose:…, onMinimize:…, onZoom:…, style: .window)
  .verticalSemaphoreWindow(chrome)  // esconde nativas + revela no hover
```

GitHub: github.com/brasico/VerticalSemaphore
Feito pela @brasico 🇧🇷

---

## 2) LinkedIn (PT)

**Abrimos o código do nosso semáforo de janela vertical — e do bug de layout que tivemos que matar pra ele funcionar.**

O cluster de controles da Apple (fechar/minimizar/zoom) é horizontal: ótimo pra
titlebar, ruim pra um app de chrome moderno — barra lateral estreita, abas, canvas
edge-to-edge. Construindo o BRACOPED, deitamos esse semáforo na vertical,
mantendo a linguagem de cor familiar.

No macOS ele ainda esconde as luzes nativas e as revela quando o cursor chega no
canto superior esquerdo — você fica com o seu chrome E os controles do sistema
quando precisa.

A lição que vale compartilhar é o detalhe: revelar as luzes desloca o layout. Se
o sensor de hover estivesse dentro desse layout, o reveal empurraria o próprio
sensor para longe do cursor, causando um flicker infinito. A solução foi decidir
pela posição crua do cursor versus o canto fixo da janela — desacoplando
sensoriamento de layout.

SwiftUI puro, macOS + iOS, MIT. Pronto pra Swift Package Manager.

👉 github.com/brasico/VerticalSemaphore

#SwiftUI #macOS #DesignSystems #OpenSource #iOS

---

## 3) GitHub Release notes — v0.1.0

**VerticalSemaphore v0.1.0 — Apple's traffic lights, stood up vertically**

A tiny SwiftUI control for custom window chrome and tab strips.

**Highlights**
- 🚦 Vertical close/minimize/zoom with Apple's exact palette, hover glyphs + glow.
- 🪟 macOS: auto-hide the native lights, reveal them on top-left hover.
- 🧩 Per-tab variant — pass only the handlers you want (close-only, or close+detach).
- 📦 SwiftUI, macOS 12+/iOS 15+, MIT, SPM-ready. ~3 files.

**The bug we document (and fixed)**: revealing native lights shifts layout; a
SwiftUI hover region would flicker. We drive the reveal off the raw cursor vs.
the fixed window corner — decoupled, no oscillation.

```swift
.package(url: "https://github.com/brasico/VerticalSemaphore.git", from: "0.1.0")
```

---

## 4) Show HN (EN)

**Title:** Show HN: VerticalSemaphore — Apple's window traffic lights, stood up vertically (SwiftUI)

**Body:**
Apple's close/minimize/zoom cluster is horizontal — fine for a titlebar, awkward
for a narrow side-rail or a tall tab. We stacked it vertically for our app's
chrome and packaged it. On macOS it also auto-hides the native lights and reveals
them on top-left hover.

The interesting bit is a layout bug: revealing the lights shifts the layout, so a
SwiftUI hover region would move out from under the cursor and flicker forever. We
drive the reveal off the raw cursor position vs. the fixed window corner instead.
SwiftUI, macOS+iOS, MIT.

---

## Notas de uso
- Troque `github.com/brasico/VerticalSemaphore` pela URL final.
- **Anexe um GIF**: cursor entrando no canto → luzes nativas aparecendo → saindo
  → semáforo vertical retomando. É o conteúdo que mais engaja em post de UI.
- Use o `assets/preview.svg` como imagem de capa do README/post (já renderiza no GitHub).
