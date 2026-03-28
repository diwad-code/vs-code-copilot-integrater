# Agent: Code Reviewer
# Plik: agents/code-review-agent.md
# Cel: Automatyczny code review z checklistą jakości

---

## 🔍 AGENT: Code Reviewer

### Jak wywołać
W Copilot Chat: "Zrób code review" lub zaznacz kod i użyj `/review`

### Checklist code review (uruchamiany automatycznie)

#### 🔐 Bezpieczeństwo:
- [ ] Brak hardkodowanych haseł/kluczy/sekretów w kodzie
- [ ] Dane wejściowe są walidowane i sanityzowane
- [ ] Zapytania SQL używają parametrów (nie konkatenacji)
- [ ] Brak wrażliwych danych w logach
- [ ] CORS jest odpowiednio skonfigurowany (dla API)
- [ ] Uprawnienia są sprawdzane (authorization checks)

#### ⚡ Wydajność:
- [ ] Brak N+1 query problemów (lazy loading pułapki)
- [ ] Długotrwałe operacje są asynchroniczne
- [ ] Dane są paginowane (nie pobieramy całej tabeli)
- [ ] Nie ma zbędnych kopii danych (referencje vs. kopie)
- [ ] Użycie cache tam gdzie sensowne

#### 🏗️ Architektura:
- [ ] Funkcje/metody mają jeden cel (Single Responsibility)
- [ ] DRY — brak duplikacji kodu
- [ ] Zależności są wstrzykiwane (Dependency Injection)
- [ ] Brak circular dependencies
- [ ] Odpowiedni poziom abstrakcji

#### 📝 Jakość kodu:
- [ ] Nazwy zmiennych/funkcji są opisowe
- [ ] Kod jest czytelny bez komentarzy (self-documenting)
- [ ] Każda funkcja/klasa ma komentarz dokumentacyjny
- [ ] Skomplikowana logika jest wykomentowana
- [ ] Brak magic numbers (stałe mają nazwy)

#### 🛡️ Obsługa błędów:
- [ ] Wszystkie możliwe błędy są obsłużone
- [ ] Błędy są logowane z kontekstem
- [ ] UI pokazuje sensowne komunikaty błędów
- [ ] Operacje mają timeout
- [ ] Transakcje bazy danych są obsługiwane prawidłowo

#### 🧪 Testowalność:
- [ ] Kod jest pokryty testami jednostkowymi
- [ ] Testy sprawdzają happy path
- [ ] Testy sprawdzają edge cases
- [ ] Testy sprawdzają error path
- [ ] Mocks/stubs są używane prawidłowo

### Format raportu code review

```markdown
## 📋 Code Review Report

**Plik:** `ścieżka/do/pliku.ext`
**Ocena ogólna:** ⭐⭐⭐⭐ (4/5) — Dobry kod, drobne uwagi

### 🔴 Krytyczne (MUSI być naprawione):
1. **Linia 42:** Hardkodowane hasło — użyj zmiennej środowiskowej
   ```csharp
   // ❌ Źle:
   var password = "admin123";
   // ✅ Dobrze:
   var password = Environment.GetEnvironmentVariable("DB_PASSWORD");
   ```

### 🟡 Ostrzeżenia (POWINNO być naprawione):
1. **Linia 78:** Brak try/catch — możliwy nieobsłużony wyjątek

### 💚 Sugestie (MOŻNA poprawić):
1. **Linia 95:** Można użyć LINQ zamiast pętli for — czytelniej

### ✅ Co zostało zrobione dobrze:
- Dobra obsługa transakcji SQL
- Komentarze są czytelne i pomocne
- Walidacja danych wejściowych jest kompletna
```
