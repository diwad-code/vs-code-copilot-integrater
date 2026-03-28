# Web Development Skill — Definicja umiejętności
# Plik: skills/web-development/skill.md
# Cel: Definiuje zakres wiedzy dla tworzenia nowoczesnych aplikacji webowych

---
name: "Web Development Expert"
version: "1.0.0"
description: "Nowoczesne aplikacje webowe: frontend, backend, GUI, UX"
tags:
  - frontend
  - backend
  - react
  - vue
  - tailwind
  - api
---

## 🎨 Zakres umiejętności Web Development

### Stack technologiczny (priorytetyzowany):

#### Frontend — Aplikacje SPA:
1. **React 18 + Vite + TypeScript + Tailwind CSS** — dla złożonych aplikacji
2. **Vue 3 + Vite + TypeScript + Tailwind CSS** — dla średnich projektów
3. **HTML5 + CSS3 + Alpine.js** — dla prostych stron/prototypów

#### Backend:
1. **Node.js + Express/Fastify + TypeScript** — API REST
2. **ASP.NET Core 8** — aplikacje enterprise, integracja z SQL/Oracle
3. **Python + FastAPI** — dla skryptów i API data science

#### CSS / Design Systems:
- **Tailwind CSS 3** — utility-first, szybki development
- **shadcn/ui** — gotowe komponenty React (piękne, dostępne)
- **PrimeVue** — komponenty Vue
- **Framer Motion** — animacje React
- **GSAP** — zaawansowane animacje

### Zasady pięknego nowoczesnego GUI:

#### Palety kolorów (przykłady):
```css
/* Dark theme — nowoczesny */
:root {
  --bg-primary: #0a0a0f;        /* bardzo ciemny fioletowy czarny */
  --bg-secondary: #12121a;      /* ciemny granat */
  --bg-card: #1a1a2e;           /* karta/panel */
  --accent-primary: #6366f1;   /* indigo */
  --accent-secondary: #8b5cf6; /* fiolet */
  --accent-gradient: linear-gradient(135deg, #6366f1, #8b5cf6, #ec4899);
  --text-primary: #f8fafc;     /* prawie biały */
  --text-secondary: #94a3b8;   /* szary niebieski */
  --border: rgba(99, 102, 241, 0.2);
}
```

#### Typowe wzorce UI które tworzę:
```html
<!-- Glass morphism karta -->
<div class="backdrop-blur-xl bg-white/5 border border-white/10 rounded-2xl p-6
            shadow-[0_8px_32px_rgba(0,0,0,0.4)]">
  <!-- treść -->
</div>

<!-- Gradient button -->
<button class="bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500
               px-6 py-2.5 rounded-full font-semibold text-white
               hover:shadow-[0_0_20px_rgba(99,102,241,0.5)]
               transition-all duration-300 hover:scale-105">
  Kliknij mnie
</button>
```

#### Animacje microinteractions:
```css
/* Hover efekt na karcie */
.card {
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}
.card:hover {
  transform: translateY(-4px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
}

/* Skeleton loading */
.skeleton {
  background: linear-gradient(90deg, #1a1a2e 25%, #2a2a4e 50%, #1a1a2e 75%);
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
}
@keyframes shimmer {
  0% { background-position: -200% 0; }
  100% { background-position: 200% 0; }
}
```

### Checklist dla każdego projektu webowego:
- [ ] Responsive design (mobile-first, breakpoints: sm/md/lg/xl/2xl)
- [ ] Dark mode (prefers-color-scheme lub toggle)
- [ ] Loading states i skeleton screens
- [ ] Error states i empty states
- [ ] Accessibility: aria labels, focus management, keyboard navigation
- [ ] SEO: meta tags, Open Graph, structured data
- [ ] Performance: lazy loading, code splitting, image optimization
- [ ] PWA: service worker, manifest (dla aplikacji)

### Narzędzia deweloperskie:
- **Vite** — szybki bundler (zamiast CRA/Webpack)
- **Vitest** — testy jednostkowe (zamiast Jest, szybszy)
- **Storybook** — dokumentacja komponentów
- **Chromatic** — visual regression testing
- **Lighthouse CI** — automatyczne audity wydajności
