# GUI Design Skill — Definicja umiejętności
# Plik: skills/gui-design/skill.md
# Cel: Zakres wiedzy dla tworzenia pięknych nowoczesnych interfejsów

---
name: "GUI Design Expert"
version: "1.0.0"
description: "Nowoczesny, piękny design UI/UX dla aplikacji webowych i desktopowych"
tags:
  - design
  - ui
  - ux
  - css
  - tailwind
  - animation
  - accessibility
---

## 🎨 Zakres umiejętności Projektowania GUI

### Zasady projektowania które zawsze stosuję:

#### 1. Hierarchia wizualna
- Jeden wyraźny element CTA (call-to-action) na sekcję
- Kontrast typograficzny: duże nagłówki + małe podpisy
- Biała przestrzeń (white space) jako element projektu
- Grid 8px/4px — wszystkie wymiary są wielokrotnościami 4px lub 8px

#### 2. Typografia (system)
```css
/* System skali typografii */
:root {
  --font-xs:    0.75rem;   /* 12px — etykiety, meta */
  --font-sm:    0.875rem;  /* 14px — pomocniczy tekst */
  --font-base:  1rem;      /* 16px — treść */
  --font-lg:    1.125rem;  /* 18px — lead text */
  --font-xl:    1.25rem;   /* 20px — podtytuły */
  --font-2xl:   1.5rem;    /* 24px — H3 */
  --font-3xl:   1.875rem;  /* 30px — H2 */
  --font-4xl:   2.25rem;   /* 36px — H1 */
  --font-5xl:   3rem;      /* 48px — Hero */
  --font-hero:  4.5rem;    /* 72px — Landing hero */
}
```

#### 3. System spacing (oparty na Tailwind)
- p-2 (8px), p-4 (16px), p-6 (24px), p-8 (32px), p-12 (48px)

### Komponenty które tworzę perfekcyjnie:

#### Hero Section (landing page):
```html
<!-- Nowoczesna sekcja hero z gradientem i animacją -->
<section class="relative min-h-screen flex items-center justify-center overflow-hidden">
  <!-- Tło z gradientem i efektem glow -->
  <div class="absolute inset-0 bg-[#0a0a0f]">
    <div class="absolute top-1/4 left-1/4 w-96 h-96 bg-purple-600/20 rounded-full
                blur-[120px] animate-pulse"></div>
    <div class="absolute bottom-1/4 right-1/4 w-96 h-96 bg-indigo-600/20 rounded-full
                blur-[120px] animate-pulse delay-1000"></div>
  </div>

  <!-- Siatka w tle (opcjonalna) -->
  <div class="absolute inset-0 bg-[url('/grid.svg')] opacity-[0.02]"></div>

  <!-- Treść hero -->
  <div class="relative z-10 text-center max-w-4xl mx-auto px-4">
    <!-- Badge/pill -->
    <div class="inline-flex items-center gap-2 px-4 py-1.5 rounded-full
                border border-purple-500/30 bg-purple-500/10 text-purple-300
                text-sm mb-8">
      <span class="w-2 h-2 rounded-full bg-purple-400 animate-pulse"></span>
      Nowa wersja dostępna
    </div>

    <!-- Nagłówek z gradientem -->
    <h1 class="text-5xl md:text-7xl font-bold mb-6 leading-tight">
      <span class="bg-gradient-to-r from-white via-purple-200 to-indigo-200
                   bg-clip-text text-transparent">
        Tworzę coś
      </span>
      <br>
      <span class="bg-gradient-to-r from-indigo-400 via-purple-400 to-pink-400
                   bg-clip-text text-transparent">
        niesamowitego
      </span>
    </h1>

    <!-- Lead text -->
    <p class="text-xl text-gray-400 mb-10 max-w-2xl mx-auto leading-relaxed">
      Opis wartości projektu w jednym lub dwóch zdaniach.
    </p>

    <!-- CTA buttons -->
    <div class="flex flex-wrap gap-4 justify-center">
      <button class="px-8 py-3 rounded-full bg-gradient-to-r from-indigo-500 to-purple-600
                     text-white font-semibold hover:shadow-[0_0_30px_rgba(99,102,241,0.5)]
                     transition-all duration-300 hover:scale-105">
        Zacznij teraz
      </button>
      <button class="px-8 py-3 rounded-full border border-white/20 text-white
                     hover:bg-white/5 transition-all duration-300">
        Dowiedz się więcej
      </button>
    </div>
  </div>
</section>
```

#### Dashboard Card:
```html
<!-- Karta statystyki — nowoczesny dashboard -->
<div class="group relative overflow-hidden rounded-2xl border border-white/10
            bg-gradient-to-br from-white/5 to-white/0
            backdrop-blur-sm p-6 hover:border-purple-500/30
            transition-all duration-300">
  <!-- Glow effect na hover -->
  <div class="absolute inset-0 opacity-0 group-hover:opacity-100 transition-opacity
              duration-300 bg-gradient-to-br from-purple-600/10 to-transparent
              rounded-2xl"></div>

  <div class="relative z-10">
    <!-- Ikona -->
    <div class="w-12 h-12 rounded-xl bg-purple-500/20 border border-purple-500/30
                flex items-center justify-center mb-4 text-purple-400">
      <!-- Ikona SVG -->
    </div>

    <!-- Wartość -->
    <div class="text-3xl font-bold text-white mb-1">42,891</div>
    <!-- Etykieta -->
    <div class="text-sm text-gray-400 mb-3">Aktywnych użytkowników</div>

    <!-- Trend -->
    <div class="flex items-center gap-1 text-emerald-400 text-sm">
      <span>↑ 12.5%</span>
      <span class="text-gray-500">vs zeszły miesiąc</span>
    </div>
  </div>
</div>
```

### Narzędzia projektowe:
- **Figma** — projektowanie (można eksportować CSS)
- **shadcn/ui** — https://ui.shadcn.com — gotowe komponenty React
- **Radix UI** — headless komponenty dostępne
- **Magic UI** — animowane komponenty React (magicui.design)
- **Aceternity UI** — efektowne komponenty (ui.aceternity.com)
- **Tailwind CSS** — https://tailwindcss.com
- **Heroicons** — ikony SVG od twórców Tailwind
- **Lucide Icons** — piękne ikony SVG

### Wbudowane animacje CSS (bez bibliotek):
```css
/* Fade in z dołu — używaj dla elementów pojawiających się */
@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(20px); }
  to   { opacity: 1; transform: translateY(0); }
}

/* Glow pulse — dla akcentów i CTA */
@keyframes glowPulse {
  0%, 100% { box-shadow: 0 0 20px rgba(99, 102, 241, 0.4); }
  50%       { box-shadow: 0 0 40px rgba(99, 102, 241, 0.8); }
}
```
