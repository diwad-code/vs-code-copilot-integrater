# Szablon: Plan Projektu
# Plik: templates/project-plan-template.md
# CEL: Standardowy szablon do planowania każdego nowego projektu
# UŻYCIE: Skopiuj do katalogu projektu jako docs/PROJECT-PLAN.md i wypełnij

# [NAZWA PROJEKTU]

**Data utworzenia:** [YYYY-MM-DD]
**Autor:** [Imię Nazwisko / Inicjały]
**Status:** 🟡 W planowaniu / 🟢 W realizacji / ✅ Zakończony

---

## 📋 1. Opis projektu

### Cel biznesowy
> _Opisz w 2-3 zdaniach jaki problem rozwiązuje ten projekt._

### Użytkownicy docelowi
> _Kto będzie używał tego systemu? Ile osób? Jakie mają kompetencje techniczne?_

### Mierzalny sukces
> _Jak będziemy wiedzieć że projekt zakończył się sukcesem?_
- [ ] Kryterium sukcesu 1
- [ ] Kryterium sukcesu 2

---

## 🔧 2. Wymagania techniczne

### Wymagania funkcjonalne (co system MUSI robić)
| ID | Wymaganie | Priorytet | Uwagi |
|----|-----------|-----------|-------|
| F01 | [Opis wymagania] | Must Have | |
| F02 | [Opis wymagania] | Should Have | |
| F03 | [Opis wymagania] | Could Have | |

### Wymagania niefunkcjonalne
| Kategoria | Wymaganie | Metryka |
|-----------|-----------|---------|
| Wydajność | Czas odpowiedzi | < 2 sekundy dla 95% requestów |
| Dostępność | Uptime | 99.9% (max 8h przestoju/rok) |
| Bezpieczeństwo | Autoryzacja | OAuth2 / Windows Auth |
| Skalowalność | Użytkownicy | Max X równocześnie |

### Ograniczenia techniczne
- **Środowisko:** [np. Windows Server 2022, SQL Server 2019]
- **Sieć:** [np. intranet firmowy, bez dostępu do internetu]
- **Zasoby:** [np. max 4GB RAM, .NET 8 niedostępny → .NET Framework 4.8]
- **Istniejące systemy:** [integracje z innymi systemami]

---

## 🛠️ 3. Stack technologiczny

| Warstwa | Technologia | Wersja | Uzasadnienie |
|---------|-------------|--------|--------------|
| Frontend | [React/Vue/WPF/WinForms] | X.X | |
| Backend | [ASP.NET/Node.js/PS] | X.X | |
| Baza danych | [SQL Server/Oracle] | X.X | |
| Hosting | [Azure/IIS/lokalny] | | |
| CI/CD | [GitHub Actions/ADO] | | |

### Alternatywy rozważane i dlaczego odrzucone:
1. **[Technologia A]** — odrzucona bo [powód]
2. **[Technologia B]** — odrzucona bo [powód]

---

## 🏗️ 4. Architektura

### Diagram (opis słowny lub ASCII)
```
[Użytkownik] → [Frontend] → [API Backend] → [Baza danych]
                                ↓
                         [Zewnętrzne API]
```

### Struktura katalogów projektu
```
projekt/
├── src/
│   ├── components/     # Komponenty UI
│   ├── services/       # Logika biznesowa
│   ├── models/         # Modele danych
│   └── utils/          # Funkcje pomocnicze
├── tests/              # Testy
├── docs/               # Dokumentacja
├── scripts/            # Skrypty pomocnicze
└── README.md
```

### Kluczowe decyzje architektoniczne (ADR)
| Decyzja | Wybór | Uzasadnienie |
|---------|-------|--------------|
| Pattern | MVVM/MVC/Clean Arch | |
| Auth | JWT/Windows Auth/OAuth | |
| Logging | Serilog/PSFramework | |

---

## 📅 5. Plan realizacji

### Etap 1: MVP (minimalny działający produkt)
**Szacowany czas:** X tygodni  
**Cel:** [Co użytkownik może zrobić po tym etapie]

- [ ] Zadanie 1.1: [opis] — ~Xh
- [ ] Zadanie 1.2: [opis] — ~Xh
- [ ] Zadanie 1.3: [opis] — ~Xh

### Etap 2: Pełna funkcjonalność
**Szacowany czas:** X tygodni  
**Cel:** [Co zostanie dodane]

- [ ] Zadanie 2.1: [opis] — ~Xh
- [ ] Zadanie 2.2: [opis] — ~Xh

### Etap 3: Testy, optymalizacja i wdrożenie
**Szacowany czas:** X dni

- [ ] Testy jednostkowe
- [ ] Testy integracyjne
- [ ] Testy wydajnościowe
- [ ] Code review
- [ ] Dokumentacja użytkownika
- [ ] Wdrożenie na środowisko testowe
- [ ] UAT (User Acceptance Testing)
- [ ] Wdrożenie produkcyjne

---

## ⚠️ 6. Ryzyka

| ID | Ryzyko | Prawdopodobieństwo | Wpływ | Mitygacja |
|----|--------|-------------------|-------|-----------|
| R01 | [Ryzyko 1] | Niskie/Średnie/Wysokie | Niski/Średni/Wysoki | [Działanie zapobiegawcze] |
| R02 | [Ryzyko 2] | | | |

---

## ❓ 7. Pytania otwarte

- [ ] [Pytanie wymagające decyzji od klienta/architekta]
- [ ] [Kwestia techniczna do zbadania]
- [ ] [Zależność od zewnętrznego zespołu]

---

## 📝 8. Historia zmian dokumentu

| Data | Autor | Zmiana |
|------|-------|--------|
| [YYYY-MM-DD] | [Inicjały] | Utworzenie dokumentu |
