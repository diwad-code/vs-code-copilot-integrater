# Szablon: Dokumentacja projektu
# Plik: templates/project-docs-template.md
# CEL: Pełna dokumentacja techniczna projektu dla deweloperów i przyszłych modeli AI

# [NAZWA PROJEKTU] — Dokumentacja Techniczna

> **Ważne dla modeli AI:** Ten plik zawiera pełny kontekst projektu. Przeczytaj go przed
> wprowadzaniem jakichkolwiek zmian. Dokumentuje wszystkie decyzje architektoniczne i założenia.

**Wersja dokumentacji:** 1.0.0  
**Ostatnia aktualizacja:** [YYYY-MM-DD]  
**Technologia:** [Stack]  

---

## 🎯 Cel i zakres projektu

### Problem który rozwiązujemy
[2-3 zdania opisujące problem biznesowy]

### Rozwiązanie
[Opis jak projekt rozwiązuje ten problem]

### Co jest POZA zakresem projektu
- [Czego NIE robi ten projekt — ważne dla uniknięcia scope creep]

---

## 🏗️ Architektura systemu

### Diagram warstw
```
┌─────────────────────────────────────────┐
│           Warstwa prezentacji           │
│        (React/WPF/HTML+CSS+JS)         │
├─────────────────────────────────────────┤
│           Warstwa logiki (API)          │
│       (ASP.NET Core / Node.js)          │
├─────────────────────────────────────────┤
│           Warstwa danych                │
│        (SQL Server / Oracle)            │
└─────────────────────────────────────────┘
```

### Kluczowe komponenty
| Komponent | Technologia | Rola | Lokalizacja kodu |
|-----------|-------------|------|-----------------|
| Frontend | React 18 | UI dla użytkownika | `src/frontend/` |
| API | ASP.NET Core 8 | REST API | `src/api/` |
| Database | SQL Server 2022 | Dane | `src/database/` |

---

## 📁 Struktura projektu

```
.
├── src/
│   ├── frontend/           # Aplikacja frontend
│   │   ├── components/     # Reużywalne komponenty UI
│   │   ├── pages/          # Strony/widoki aplikacji
│   │   ├── hooks/          # Custom React hooks
│   │   ├── services/       # Wywołania API
│   │   └── utils/          # Funkcje pomocnicze
│   │
│   ├── api/                # Backend API
│   │   ├── Controllers/    # Kontrolery REST
│   │   ├── Services/       # Logika biznesowa
│   │   ├── Models/         # Modele danych
│   │   └── Middleware/     # Middleware (auth, logging)
│   │
│   └── database/           # Skrypty bazodanowe
│       ├── migrations/     # Historia zmian schematu
│       ├── procedures/     # Stored procedures
│       ├── views/          # Views
│       └── seed/           # Dane startowe
│
├── tests/
│   ├── unit/               # Testy jednostkowe
│   ├── integration/        # Testy integracyjne
│   └── e2e/                # Testy end-to-end
│
├── docs/                   # Dokumentacja
├── scripts/                # Skrypty pomocnicze
└── .github/                # GitHub Actions, Copilot config
```

---

## 🔑 Konfiguracja i zmienne środowiskowe

### Wymagane zmienne środowiskowe

| Zmienna | Opis | Przykład | Gdzie ustawić |
|---------|------|---------|---------------|
| `DATABASE_CONNECTION_STRING` | Connection string do bazy | `Server=...;Database=...` | Azure Key Vault / .env |
| `JWT_SECRET` | Klucz do podpisywania JWT | 64-znakowy losowy string | Azure Key Vault |
| `API_BASE_URL` | URL backendu | `https://api.firma.pl` | .env.local |

> ⚠️ **NIGDY** nie commituj wartości tych zmiennych do repozytorium!

### Plik .env.example
```env
# Kopiuj do .env.local i wypełnij wartościami
DATABASE_CONNECTION_STRING=Server=localhost;Database=MyApp;Integrated Security=true
JWT_SECRET=REPLACE_WITH_64_CHAR_RANDOM_STRING
API_BASE_URL=http://localhost:5000
```

---

## 🔌 API Reference

### Autentykacja
Wszystkie endpointy (poza `/api/auth/login`) wymagają nagłówka:
```
Authorization: Bearer {jwt_token}
```

### Endpointy

#### POST /api/auth/login
Logowanie użytkownika, zwraca token JWT.
```json
// Request
{ "username": "jan.kowalski", "password": "hasło" }

// Response 200
{ "token": "eyJ...", "expiresAt": "2024-01-01T00:00:00Z" }

// Response 401
{ "error": "Nieprawidłowe dane logowania" }
```

---

## 🗄️ Schemat bazy danych

### Tabele główne

| Tabela | Opis | Klucz główny | Powiązania |
|--------|------|-------------|------------|
| `Users` | Użytkownicy systemu | `UserID` INT IDENTITY | `UserRoles` |
| `Orders` | Zamówienia | `OrderID` INT IDENTITY | `Users`, `OrderItems` |

### Indeksy krytyczne dla wydajności
```sql
-- Indeks na EmailAddress — używany przy logowaniu
CREATE INDEX IX_Users_Email ON Users (EmailAddress) WHERE IsActive = 1;

-- Indeks dla zapytań raportowych
CREATE INDEX IX_Orders_Date_Status ON Orders (OrderDate, Status) INCLUDE (TotalAmount);
```

---

## 🧪 Jak uruchomić testy

```bash
# Testy jednostkowe frontend
npm run test:unit

# Testy integracyjne backend (.NET)
dotnet test tests/integration

# Testy E2E (wymaga uruchomionej aplikacji)
npm run test:e2e

# Testy PowerShell (Pester)
Invoke-Pester -Path ./tests -Output Detailed
```

---

## 🚀 Instrukcja wdrożenia

### Środowisko deweloperskie
```powershell
# 1. Instalacja zależności
npm install
dotnet restore

# 2. Konfiguracja bazy danych
.\scripts\setup-database.ps1 -Environment Development

# 3. Uruchomienie
npm run dev          # Frontend na http://localhost:3000
dotnet run           # Backend na http://localhost:5000
```

### Środowisko produkcyjne
```powershell
# Wdrożenie przez GitHub Actions — patrz .github/workflows/deploy.yml
# Ręczne wdrożenie:
.\scripts\deploy.ps1 -Environment Production
```

---

## 📞 Kontakty i zasoby

- **Backlog:** [Link do Jira/GitHub Issues]
- **Design:** [Link do Figma]
- **Środowisko testowe:** [URL]
- **Monitoring:** [Link do dashboardu]

---

## 📝 Decyzje architektoniczne (ADR)

### ADR-001: Wybór React zamiast Vue
**Data:** [YYYY-MM-DD]  
**Status:** Zaakceptowany  
**Kontekst:** Potrzebujemy frameworka frontend dla złożonej aplikacji.  
**Decyzja:** Używamy React 18 z TypeScript.  
**Uzasadnienie:** Większy ekosystem, team zna React, dostępność komponentów shadcn/ui.  
**Konsekwencje:** Większy bundle niż Vue, ale lepsze wsparcie TypeScript.  
