# Dokumentacja: Przewodnik umiejętności i agentów
# Plik: docs/SKILLS_AND_AGENTS.md
# CEL: Opis dostępnych skilli, agentów i narzędzi MCP

# 🛠️ Skills, Agents i MCP — Przewodnik

---

## 📚 Czym jest "skill" w kontekście Copilota?

**Skill** (umiejętność) to zestaw wiedzy i instrukcji które mówią Copilotowi:
- W jakiej dziedzinie jest ekspertem
- Jakich wzorców kodu ma używać
- Jakie standardy ma stosować
- Z jakich narzędzi i bibliotek ma korzystać

W tym projekcie skille są zdefiniowane w katalogu `skills/`.

---

## 🤖 Czym jest "agent" w Copilocie?

**Agent** to tryb pracy Copilota w którym:
- Wykonuje wieloetapowe zadania autonomicznie
- Używa dostępnych narzędzi MCP
- Planuje i wykonuje sekwencję akcji
- Modyfikuje wiele plików naraz

W VS Code agenci są dostępni przez `@` w Copilot Chat:
- `@workspace` — agent z kontekstem całego projektu
- `@terminal` — agent mogący wykonywać komendy w terminalu
- `@vscode` — agent do konfiguracji VS Code

---

## 🔧 Dostępne skille (skills/)

### 1. PowerShell Expert (`skills/powershell/skill.md`)
**Kiedy aktywowany:** Gdy pracujesz z plikami `.ps1`, `.psm1`, `.psd1`

**Co umie:**
- Pisanie produkcyjnych skryptów z obsługą błędów
- Automatyzacja administracji Windows
- Tworzenie modułów PowerShell
- Pisanie testów Pester

**Jak użyć:**
```
"Napisz skrypt PowerShell który [opis zadania]"
"Zrób skrypt PS do automatycznego backupu folderów"
```

### 2. Web Development Expert (`skills/web-development/skill.md`)
**Kiedy aktywowany:** Przy plikach `.html`, `.css`, `.js`, `.ts`, `.jsx`, `.tsx`, `.vue`

**Co umie:**
- Tworzenie aplikacji React/Vue z TypeScript
- Nowoczesny CSS z Tailwind
- REST API z Node.js
- PWA i wydajność web

**Jak użyć:**
```
"Stwórz aplikację React do [opis]"
"Zbuduj landing page dla [opis]"
```

### 3. Database Expert (`skills/database/skill.md`)
**Kiedy aktywowany:** Przy plikach `.sql`, połączeniach z bazą

**Co umie:**
- T-SQL (SQL Server) z optymalizacją
- PL/SQL (Oracle) z pakietami
- Projektowanie schematu bazy
- Stored procedures, views, functions
- Strategie indeksowania

**Jak użyć:**
```
"Napisz stored procedure do [opis]"
"Zaprojektuj schemat bazy dla [opis]"
"Zoptymalizuj to zapytanie SQL: [zapytanie]"
```

### 4. GUI Design Expert (`skills/gui-design/skill.md`)
**Kiedy aktywowany:** Przy zadaniach UI/UX, CSS, komponentach wizualnych

**Co umie:**
- Nowoczesny dark/light theme design
- Glass morphism, gradients, micro-animations
- Tailwind CSS utility patterns
- Dostępność (a11y) WCAG 2.1

**Jak użyć:**
```
"Stwórz nowoczesny hero section dla [opis]"
"Zaprojektuj dashboard do [opis] — użyj dark theme"
```

### 5. Windows Apps Expert (`skills/windows-apps/skill.md`)
**Kiedy aktywowany:** Przy plikach `.cs`, `.xaml`, projektach WPF/WinForms

**Co umie:**
- WPF z MVVM pattern
- WinForms dla prostych narzędzi
- .NET 8 i NuGet packages
- Packaging (MSIX, Inno Setup)

**Jak użyć:**
```
"Stwórz aplikację WPF do [opis]"
"Napisz narzędzie konsolowe .NET do [opis]"
```

### 6. Ultimate Engineering Expert (`skills/ultimate-engineering/skill.md`)
**Kiedy aktywowany:** Przy zadaniach przekrojowych wymagających wielu domen naraz.

**Co umie:**
- Orkiestracja pracy multi-domenowej: architektura + implementacja + jakość + security
- 120+ kompetencji obejmujących programowanie, reasoning i research
- Dobór etapów MVP → hardening → skalowanie
- Decision-making oparte o ryzyko, koszt utrzymania i cele biznesowe

**Jak użyć:**
```
"Rozwiąż to zadanie kompleksowo używając podejścia end-to-end"
"Zaproponuj architekturę i plan wdrożenia z walidacją jakości i bezpieczeństwa"
```

---

## 🤖 Dostępne agenty (agents/)

### 1. Planista Projektu (`agents/planning-agent.md`)

Uruchamia się gdy chcesz zaplanować nowy projekt lub funkcję.

**Jak wywołać:**
```
"Zaplanuj projekt: [opis]"
"Chcę zbudować [opis]. Pomóż zaplanować."
```

**Co zrobi:**
1. Zada pytania wyjaśniające
2. Zaproponuje stack technologiczny
3. Stworzy plan etapami
4. Przy akceptacji — inicjuje strukturę projektu

### 2. Dokumentalista (`agents/documentation-agent.md`)

Generuje i aktualizuje dokumentację kodu i projektów.

**Jak wywołać:**
```
"Udokumentuj ten kod"
"Zaktualizuj WORKLOG.md"
"Napisz README dla tego projektu"
```

**Co zrobi:**
- Dodaje komentarze JSDoc/XMLDoc do każdej funkcji
- Aktualizuje plik WORKLOG.md
- Tworzy/aktualizuje dokumentację projektu

### 3. Code Reviewer (`agents/code-review-agent.md`)

Wykonuje code review z checklistą jakości.

**Jak wywołać:**
```
"Zrób code review tego pliku"
"/review" (zaznacz kod i użyj komendy)
```

**Sprawdza:**
- Bezpieczeństwo (SQL injection, XSS, hardkodowane sekrety)
- Wydajność (N+1, brak indeksów, synchroniczne operacje)
- Jakość kodu (DRY, SRP, czytelność)
- Obsługa błędów

### 4. Research (`agents/research-agent.md`)

Bada i porównuje technologie, proponuje nowoczesne rozwiązania.

**Jak wywołać:**
```
"Porównaj React vs Vue dla [mojego przypadku]"
"Jakie są najlepsze biblioteki do [zadania]?"
"Zrób research na temat [technologia]"
```

### 5. Orchestrator (`agents/orchestrator-agent.md`)

Agent koordynujący złożone zadania end-to-end:
research → decyzja → implementacja → weryfikacja → dokumentacja.

**Jak wywołać:**
```
"Orchestruj realizację: [opis zadania]"
"Przeprowadź pełen workflow od planu do walidacji"
```

**Co zrobi:**
- Podzieli problem na etapy i dobierze właściwych ekspertów
- Uporządkuje zależności między zadaniami
- Dopilnuje testów, review i bezpieczeństwa przed finalizacją

---

## 📚 Katalog 220+ pozycji

Plik: `docs/ULTIMATE_SKILLS_TOOLS_AGENTS_CATALOG.md`

Zawiera:
- **120 skills** (kompetencje inżynierskie)
- **70 tools** (kategorie narzędzi i ekosystemów)
- **30 agents** (role wykonawcze i analityczne)

---

## 🌐 Serwery MCP (mcp/mcp-config.json)

### Co to jest MCP?
Model Context Protocol (MCP) to otwarty standard który pozwala modelom AI
(Copilot) na bezpieczne korzystanie z narzędzi zewnętrznych.

### Dostępne serwery:

| Serwer | Pakiet | Co robi | Wymagania |
|--------|--------|---------|-----------|
| **filesystem** | `@mcp/server-filesystem` | Czytanie i pisanie plików | Brak |
| **memory** | `@mcp/server-memory` | Pamięć między sesjami | Brak |
| **sequential-thinking** | `@mcp/server-sequential-thinking` | Planowanie kroków | Brak |
| **github** | `@mcp/server-github` | GitHub API | `GITHUB_TOKEN` |
| **brave-search** | `@mcp/server-brave-search` | Wyszukiwanie web | `BRAVE_API_KEY` |
| **puppeteer** | `@mcp/server-puppeteer` | Automatyzacja Chrome | Brak |
| **sqlite** | `@mcp/server-sqlite` | Lokalna baza danych | Brak |
| **context7** | `@upstash/context7-mcp` | Dokumentacja frameworków | Brak |
| **playwright** | `@playwright/mcp` | Testy E2E | Brak |
| **magic-ui** | `@21st-dev/magic-mcp` | Generowanie komponentów GUI | `MAGIC_UI_API_KEY` (opcjonalny) |

### Przykłady użycia MCP w Copilot Chat:

```
# Wyszukiwanie aktualnych rozwiązań
"Poszukaj najlepszych praktyk dla SQL Server 2022 performance tuning"

# Pamięć kontekstu
"Zapamiętaj że ten projekt używa Oracle 19c i nie mamy dostępu do internetu"

# Automatyzacja przeglądarki
"Zrób screenshot strony https://... i sprawdź czy formularz logowania działa"

# Aktualna dokumentacja
"Pokaż mi aktualną dokumentację Tailwind CSS dla custom components"
```

---

## 💡 Wskazówki dla efektywnej pracy z Copilotem

### 1. Daj kontekst na początku sesji
```
"Kontekst: pracuję nad aplikacją webową dla firmy XYZ.
Stack: React 18 + TypeScript + Tailwind + ASP.NET Core + SQL Server 2019.
Zawsze komentuj kod po polsku."
```

### 2. Używaj @ mentions
- `@workspace` — Copilot widzi cały projekt
- `@terminal` — Copilot może uruchamiać komendy
- `#file:nazwa.cs` — dołącz konkretny plik do kontekstu

### 3. Podaj przykład oczekiwanego outputu
```
"Napisz stored procedure podobną do tej [wklej przykład],
ale dla tabeli Products zamiast Customers"
```

### 4. Iteruj z Copilotem
Nie próbuj uzyskać idealnego kodu w jednym promptcie.
Zacznij od szkieletu i iteruj: "Dodaj obsługę błędów", "Zoptymalizuj zapytanie"

### 5. Copilot Edits dla zmian wieloplikowych
Użyj `Ctrl+Shift+I` (Copilot Edits) gdy chcesz zmienić wiele plików naraz.
```
"Dodaj dark mode do wszystkich komponentów React w src/components/"
```

### 6. Routing modeli pod ten projekt (GPT-5.3-Codex + GPT-5.4)

- **GPT-5.3-Codex**: implementacja kodu, refaktoryzacja, zadania terminalowe/CLI
- **GPT-5.4**: złożone planowanie, analiza architektury, research i decyzje

Rekomendacja:
1. Zacznij od planu na GPT-5.4
2. Wdrożenie i poprawki rób na GPT-5.3-Codex
3. Walidację końcową i ocenę ryzyk zrób ponownie na GPT-5.4
