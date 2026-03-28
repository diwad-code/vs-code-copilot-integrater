---
name: gpt54-final-audit
description: Końcowa kontrola kompletności i ryzyk pod GPT-5.4 przed zamknięciem zadania
agent: ask
argument-hint: Podaj zakres zmian, wynik testów i obszary ryzyka do sprawdzenia
---

# Finalny audyt na GPT-5.4

Przeprowadź końcową kontrolę jakości dla bieżącego zadania w tym repozytorium.

## Sprawdź

1. Czy wdrożenie jest kompletne względem celu zadania.
2. Czy dokumentacja, taski, skrypty setupu i walidacja repo są spójne.
3. Czy są pominięte edge case'y, ryzyka bezpieczeństwa lub niespójności nazewnicze.
4. Czy routing pracy między `GPT-5.3-Codex` i `GPT-5.4` jest dobrze opisany dla użytkownika końcowego.
5. Czy można jeszcze wskazać brakujący element, który utrudniłby realne wdrożenie w VS Code.

## Format odpowiedzi

- Krótka lista: ✅ gotowe
- Krótka lista: ⚠️ do poprawy
- Krótka decyzja końcowa: czy projekt jest gotowy do użycia w VS Code

## Ograniczenia

- Nie wymyślaj nowych funkcji, jeśli nie wynikają z realnych braków.
- Traktuj dokumentację i skrypty wdrożeniowe jako równie ważne jak kod.
