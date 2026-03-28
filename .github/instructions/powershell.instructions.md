---
description: 'Dodatkowe reguły dla skryptów PowerShell w tym repozytorium'
applyTo: '**/*.ps1, **/*.psm1, **/*.psd1'
---

# PowerShell — instrukcje kontekstowe

- Zachowuj produkcyjny styl obecny w repozytorium: nagłówek pliku, `[CmdletBinding()]`, jawne `param()`, `try/catch` tam gdzie operacje mogą się nie udać.
- Nie usuwaj istniejących zabezpieczeń, walidacji parametrów ani komunikatów ostrzegawczych tylko po to, aby skrócić kod.
- Preferuj zmiany małe i odwracalne — rozszerzaj istniejące skrypty zamiast tworzyć równoległe warianty tej samej logiki.
- Jeśli skrypt dotyczy setupu lub weryfikacji, zachowuj czytelne komunikaty `PASS/WARN/FAIL`, aby wynik nadawał się do ręcznego przeglądu.
- Nie zapisuj sekretów w skryptach; używaj `.env.example`, zmiennych środowiskowych i istniejących mechanizmów konfiguracji.

