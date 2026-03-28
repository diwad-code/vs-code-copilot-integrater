# Dokumentacja: Przepływy pracy z Copilotem
# Plik: docs/DEVELOPMENT_WORKFLOWS.md
# CEL: Opis standardowych procesów pracy dla różnych typów zadań

# 🔄 Przepływy pracy — Development Workflows

Dokument opisuje standardowe procesy pracy z GitHub Copilot Pro+
dla każdego typu projektu.

---

## 🆕 Workflow: Nowy projekt

```
1. ZBIERZ WYMAGANIA
   Copilot Chat: "Zaplanuj projekt: [opis]"
   → Copilot zada pytania wyjaśniające
   → Odpowiedz na pytania
   
2. ZATWIERDŹ PLAN
   → Copilot proponuje plan i stack
   → Akceptujesz lub modyfikujesz
   
3. INICJUJ STRUKTURĘ
   Copilot Chat: "Stwórz strukturę katalogów dla zatwierdzonego planu"
   → Copilot tworzy pliki i foldery
   
4. STWÓRZ DOKUMENTACJĘ STARTOWĄ
   Copilot Chat: "Stwórz docs/PROJECT.md i WORKLOG.md dla tego projektu"
   
5. INICJUJ GIT
   git init && git add . && git commit -m "feat: initial project structure"
```

---

## 🖥️ Workflow: Skrypt PowerShell

```
1. OPISZ ZADANIE
   "Napisz skrypt PowerShell który: [opis co skrypt ma robić]
    Parametry: [lista parametrów]
    Środowisko: Windows Server 2022, PS 5.1"

2. COPILOT PISZE SKRYPT
   → Skrypt z nagłówkiem dokumentacyjnym
   → Parametry z [CmdletBinding()]
   → Obsługa błędów try/catch
   → Logowanie z Write-Log
   → Komentarze po polsku

3. PRZEJRZYJ I PRZETESTUJ
   Copilot Chat: "Zrób code review tego skryptu"
   Uruchom: .\NazwaSkryptu.ps1 -WhatIf
   PSScriptAnalyzer: Invoke-ScriptAnalyzer -Path .\NazwaSkryptu.ps1

4. NAPISZ TESTY PESTER
   "Napisz testy Pester dla tego skryptu"

5. UDOKUMENTUJ
   "Zaktualizuj WORKLOG.md — skrypt X został ukończony"
```

---

## 🌐 Workflow: Aplikacja webowa (React/Vue)

```
1. ZAPLANUJ KOMPONENTY
   "Zaprojektuj strukturę komponentów dla [opis aplikacji]
    Stack: React 18 + TypeScript + Tailwind + Vite"

2. INICJUJ PROJEKT
   npm create vite@latest nazwa-projektu -- --template react-ts
   cd nazwa-projektu && npm install
   npm install -D tailwindcss postcss autoprefixer
   npx tailwindcss init -p

3. GENERUJ KOMPONENTY
   "Stwórz komponent [NazwaKomponentu] który:
    - [opis funkcjonalności]
    - Używa Tailwind CSS
    - Dark mode
    - Jest dostępny (aria labels)
    - TypeScript props"

4. DODAJ LOGIKĘ
   "Dodaj hook do pobierania danych z API [opis endpointu]"

5. TESTY
   "Napisz testy Vitest dla komponentu [nazwa]"

6. OPTYMALIZUJ WYDAJNOŚĆ
   "Sprawdź kod pod kątem wydajności React — memo, useMemo, useCallback"
```

---

## 🗄️ Workflow: Baza danych (SQL/Oracle)

```
1. ZAPLANUJ SCHEMAT
   "Zaprojektuj schemat bazy danych dla [opis systemu].
    Baza: SQL Server 2019 / Oracle 19c"
   → Copilot tworzy diagram tabel i relacji

2. STWÓRZ MIGRACJE
   "Napisz skrypt SQL tworzący tabele dla zatwierdzonego schematu.
    Każda kolumna ma być skomentowana."

3. PROCEDURY I WIDOKI
   "Napisz stored procedure do [opis operacji].
    Wzorzec: BEGIN TRY/CATCH, SET NOCOUNT ON, paginacja"

4. INDEKSY
   "Przeanalizuj zapytania i zaproponuj indeksy dla wydajności"

5. TESTY
   "Napisz skrypty testowe dla procedury [nazwa]:
    - Test happy path
    - Test z niepoprawnymi danymi  
    - Test wydajności"
```

---

## 🪟 Workflow: Aplikacja Windows (.NET)

```
1. WYBIERZ FRAMEWORK
   WinForms: proste formularze, narzędzia admina
   WPF: złożone GUI, bindowania danych
   Console: CLI tools

2. INICJUJ PROJEKT
   dotnet new wpf -n NazwaAplikacji
   dotnet new winforms -n NazwaAplikacji
   dotnet new console -n NazwaAplikacji

3. GENERUJ UI
   "Stwórz MainWindow dla [opis aplikacji].
    MVVM pattern, CommunityToolkit.Mvvm,
    Dark theme, HiDPI support"

4. LOGIKA BIZNESOWA
   "Stwórz serwis [NazwaSerwisu] który [opis].
    Dependency Injection, async/await"

5. PACKAGING
   "Stwórz skrypt Inno Setup dla aplikacji [nazwa]"
```

---

## 🔄 Workflow: Code Review

```
# Opcja 1: Przez Copilot Chat
Zaznacz kod → Copilot Chat → "Zrób code review"

# Opcja 2: Pull Request Review (GitHub)
gh pr create → GitHub Copilot automatycznie sugeruje review

# Opcja 3: Cały plik
Otwórz plik → Copilot Chat: "Przejrzyj ten plik pod kątem: 
bezpieczeństwo, wydajność, obsługa błędów"
```

---

## 📝 Workflow: Dokumentacja

```
# Po każdej sesji pracy:
Copilot Chat: "@workspace Zaktualizuj WORKLOG.md:
- Wykonano: [lista zrobionych rzeczy]
- Następna sesja: [co dalej]"

# Dokumentowanie nowego kodu:
Copilot Chat: "Dodaj komentarze dokumentacyjne do wszystkich
funkcji publicznych w [plik]"

# Generowanie README:
Copilot Chat: "@workspace Wygeneruj README.md dla tego projektu
z: opisem, instalacją, użyciem, strukturą projektu"
```

---

## 🐛 Workflow: Debugowanie

```
1. OPISZ PROBLEM
   "Mam błąd: [treść błędu / stack trace].
    Kontekst: [co robiłem gdy wystąpił błąd]"

2. COPILOT ANALIZUJE
   → Wskazuje prawdopodobną przyczynę
   → Proponuje rozwiązanie

3. WERYFIKACJA
   "Czy to rozwiązanie może spowodować inne problemy?"

4. DOKUMENTACJA
   "Dodaj komentarz wyjaśniający co i dlaczego przy poprawce"
```

---

## 📊 Skróty klawiszowe Copilota

| Skrót | Akcja |
|-------|-------|
| `Alt+\` | Pokaż/ukryj sugestię inline |
| `Tab` | Akceptuj sugestię |
| `Esc` | Odrzuć sugestię |
| `Ctrl+Enter` | Otwórz Completions Panel (wiele sugestii) |
| `Ctrl+Alt+I` | Otwórz Copilot Chat |
| `Ctrl+Shift+I` | Otwórz Copilot Edits |
| `Ctrl+I` | Inline Chat (w edytorze) |

---

## 💬 Efektywne prompty dla każdego języka

### PowerShell:
```
"Napisz skrypt PowerShell [PS 5.1/7+] który [opis].
Wymagania: obsługa błędów try/catch, logowanie, parametr -WhatIf,
komentarze po polsku, wzorzec produkcyjny"
```

### SQL Server:
```
"Napisz [stored procedure/view/function] T-SQL który [opis].
SQL Server [wersja]. Użyj: SET NOCOUNT ON, BEGIN TRY/CATCH,
komentarze po polsku, paginacja [OFFSET/FETCH]"
```

### React/TypeScript:
```
"Stwórz komponent React [nazwa] który [opis].
Użyj: TypeScript, Tailwind CSS, shadcn/ui, dark mode,
dostępność aria, mobile-first"
```

### C#/.NET:
```
"Stwórz [klasa/serwis/kontroler] w C# który [opis].
.NET 8, async/await, Dependency Injection, XMLDoc komentarze,
obsługa wyjątków, logowanie Serilog"
```
