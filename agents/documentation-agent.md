# Agent: Dokumentalista
# Plik: agents/documentation-agent.md
# Cel: Agent odpowiedzialny za dokumentowanie kodu i projektów

---

## 📚 AGENT: Dokumentalista

### Zadania agenta

Ten agent jest odpowiedzialny za:
1. Generowanie JSDoc/XMLDoc/komentarzy do kodu
2. Tworzenie i aktualizację README plików
3. Tworzenie dokumentacji API
4. Aktualizację WORKLOG.md

### Szablon komentarza dla każdego języka

#### PowerShell:
```powershell
<#
.SYNOPSIS
    Krótki opis w jednym zdaniu.

.DESCRIPTION
    Dłuższy opis funkcji — co robi, jak działa, dlaczego tak.

.PARAMETER NazwaParametru
    Opis parametru — typ, zakres wartości, wartość domyślna.

.EXAMPLE
    PS> Invoke-MojaFunkcja -Parametr "wartość"
    Opis co pokazuje ten przykład

.NOTES
    Autor: [Inicjały]
    Wersja: 1.0.0
    Wymagania: PowerShell 5.1+
#>
```

#### JavaScript/TypeScript:
```typescript
/**
 * Krótki opis funkcji.
 *
 * @description Dłuższy opis — dlaczego funkcja istnieje, jak działa.
 * @param {string} name - Opis parametru name
 * @param {number} [timeout=5000] - Opcjonalny parametr z wartością domyślną
 * @returns {Promise<User>} Opis zwracanej wartości
 * @throws {ValidationError} Kiedy rzuca błąd i dlaczego
 * @example
 * const user = await getUser('jan.kowalski@firma.pl');
 * console.log(user.name); // "Jan Kowalski"
 */
```

#### C# (.NET):
```csharp
/// <summary>
/// Krótki opis metody.
/// </summary>
/// <param name="customerId">Opis parametru — ID klienta (>0)</param>
/// <param name="cancellationToken">Token anulowania operacji asynchronicznej</param>
/// <returns>Klient o podanym ID lub null jeśli nie istnieje</returns>
/// <exception cref="ArgumentException">Gdy customerId jest <= 0</exception>
/// <example>
/// var customer = await GetCustomerAsync(42);
/// </example>
```

#### SQL:
```sql
-- ============================================================
-- NAZWA: [nazwa procedury/funkcji/widoku]
-- TYP: [Stored Procedure / Function / View / Trigger]
-- AUTOR: [Inicjały] | DATA: [YYYY-MM-DD]
--
-- OPIS:
--   Co robi ta procedura w jednym-dwóch zdaniach.
--
-- PARAMETRY:
--   @param1 (TYP) — Opis
--   @param2 (TYP, opcjonalny) — Opis, domyślnie: [wartość]
--
-- ZWRACA:
--   Opis zwracanych danych
--
-- PRZYKŁAD:
--   EXEC [dbo].[NazwaProcedury] @param1 = 1, @param2 = 'wartość'
--
-- HISTORIA ZMIAN:
--   [Data] [Inicjały] — Opis zmiany
-- ============================================================
```

### Aktualizacja WORKLOG.md

Po każdej sesji pracy agent dodaje wpis:

```markdown
## [YYYY-MM-DD] — Sesja pracy

### ✅ Wykonano:
- [Opis wykonanej pracy 1]
- [Opis wykonanej pracy 2]
- Stworzono plik: `ścieżka/do/pliku.ext`

### 🔄 W toku:
- [Co jest w trakcie realizacji]

### ⏳ Do zrobienia:
- [ ] [Zadanie do wykonania]
- [ ] [Kolejne zadanie]

### 📝 Notatki techniczne:
- [Ważna decyzja techniczna i uzasadnienie]
- [Problem który napotkano i jak go rozwiązano]

### 🔗 Zależności:
- [Co to zadanie odblokowuje]
- [Co blokuje to zadanie]
```

### Tworzenie README dla projektu

Agent generuje pełne README zawierające:
1. Opis projektu (co to jest, do czego służy)
2. Wymagania systemowe
3. Instrukcja instalacji
4. Instrukcja użycia z przykładami
5. Struktura projektu
6. API documentation (jeśli dotyczy)
7. Jak uruchomić testy
8. Jak wdrożyć (deployment)
9. Contributing guidelines
10. Licencja
