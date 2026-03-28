# Database Skill — Definicja umiejętności
# Plik: skills/database/skill.md
# Cel: Zakres wiedzy dla SQL Server i Oracle SQL

---
name: "Database Expert"
version: "1.0.0"
description: "SQL Server T-SQL i Oracle PL/SQL — projektowanie, optymalizacja, administracja"
tags:
  - sql
  - mssql
  - oracle
  - plsql
  - tsql
  - database-design
---

## 🗄️ Zakres umiejętności Baz Danych

### SQL Server (T-SQL):

#### Co tworzę:
- Stored procedures z pełną obsługą błędów
- Views i indexed views
- Functions (scalar, table-valued)
- Triggers (zamiast IF/INSTEAD OF)
- Jobs i harmonogramy SSMS
- SSRS raporty (podstawowe)
- Replikacja i mirroring (podstawowe)

#### Wzorce T-SQL których zawsze używam:
```sql
-- ============================================================
-- Stored Procedure — wzorzec produkcyjny
-- ============================================================
CREATE OR ALTER PROCEDURE [dbo].[usp_GetCustomerOrders]
    @CustomerID     INT,                    -- ID klienta (wymagane)
    @DateFrom       DATE = NULL,            -- Data od (opcjonalna)
    @DateTo         DATE = NULL,            -- Data do (opcjonalna)
    @PageNumber     INT = 1,               -- Numer strony dla paginacji
    @PageSize       INT = 50               -- Rozmiar strony (max 100)
AS
BEGIN
    -- Wyłączamy liczbę wierszy z każdej instrukcji — optymalizacja wydajności
    SET NOCOUNT ON;

    -- Walidacja parametrów wejściowych
    IF @CustomerID IS NULL OR @CustomerID <= 0
        THROW 50001, 'CustomerID musi być wartością dodatnią', 1;

    IF @PageSize > 100 SET @PageSize = 100; -- Zabezpieczenie przed dużymi requestami

    -- Główne zapytanie z paginacją
    SELECT
        o.OrderID,
        o.OrderDate,
        o.TotalAmount,
        c.CustomerName,
        c.Email
    FROM Orders o
    INNER JOIN Customers c ON c.CustomerID = o.CustomerID
    WHERE
        o.CustomerID = @CustomerID
        AND (@DateFrom IS NULL OR o.OrderDate >= @DateFrom)
        AND (@DateTo IS NULL OR o.OrderDate <= @DateTo)
    ORDER BY o.OrderDate DESC
    OFFSET ((@PageNumber - 1) * @PageSize) ROWS
    FETCH NEXT @PageSize ROWS ONLY;      -- Paginacja server-side dla wydajności
END;
```

#### Wzorce indeksowania:
```sql
-- Indeks złożony dla typowych zapytań filtrujących po dacie i kliencie
CREATE NONCLUSTERED INDEX IX_Orders_CustomerID_Date
ON Orders (CustomerID, OrderDate DESC)
INCLUDE (TotalAmount, Status);   -- INCLUDE dodaje kolumny bez ich indeksowania

-- Indeks filtrowany — tylko dla aktywnych rekordów
CREATE NONCLUSTERED INDEX IX_Customers_Active_Email
ON Customers (Email)
WHERE IsActive = 1;
```

### Oracle PL/SQL:

#### Wzorzec Package:
```sql
-- Pakiet — grupuje powiązaną logikę (jak klasa w OOP)
CREATE OR REPLACE PACKAGE pkg_customer AS
    -- Deklaracje publiczne (interfejs pakietu)
    PROCEDURE get_orders(
        p_customer_id   IN  NUMBER,
        p_result        OUT SYS_REFCURSOR
    );

    FUNCTION get_balance(
        p_customer_id   IN NUMBER
    ) RETURN NUMBER;

END pkg_customer;
/

CREATE OR REPLACE PACKAGE BODY pkg_customer AS

    PROCEDURE get_orders(
        p_customer_id   IN  NUMBER,
        p_result        OUT SYS_REFCURSOR
    ) AS
    BEGIN
        -- Otwieramy kursor z wynikami zapytania
        OPEN p_result FOR
            SELECT order_id, order_date, total_amount
            FROM orders
            WHERE customer_id = p_customer_id
              AND status != 'CANCELLED'
            ORDER BY order_date DESC;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- Logujemy błąd i rzucamy czytelny wyjątek
            raise_application_error(-20001, 'Klient o ID ' || p_customer_id || ' nie istnieje');
    END get_orders;

END pkg_customer;
/
```

#### BULK COLLECT dla wydajności:
```sql
DECLARE
    -- Typ kolekcji dla wydajnego przetwarzania wsadowego
    TYPE t_order_ids IS TABLE OF orders.order_id%TYPE;
    l_order_ids t_order_ids;
BEGIN
    -- BULK COLLECT — pobiera wszystko naraz zamiast row-by-row
    SELECT order_id
    BULK COLLECT INTO l_order_ids
    FROM orders
    WHERE status = 'PENDING';

    -- FORALL — wsadowe aktualizacje (dużo szybsze niż pętla)
    FORALL i IN l_order_ids.FIRST..l_order_ids.LAST
        UPDATE orders
        SET status = 'PROCESSED', updated_at = SYSDATE
        WHERE order_id = l_order_ids(i);

    COMMIT;
END;
/
```

### Narzędzia baz danych:
- **SSMS** — SQL Server Management Studio (SQL Server)
- **Azure Data Studio** — nowoczesna alternatywa dla SSMS
- **DBeaver** — cross-platform, obsługuje Oracle i SQL Server
- **SQL Developer** — Oracle (darmowe od Oracle)
- **Database Client JDBC** — rozszerzenie VS Code

### Dobre praktyki:
- Zawsze używaj transakcji dla operacji modyfikujących wiele tabel
- Indeksy na kolumnach FK i WHERE/ORDER BY
- Unikaj CURSOR — używaj BULK COLLECT/FORALL lub set-based operations
- Planuj capacity i archiwizację od początku
- Testy wydajnościowe przed produkcją (EXECUTION PLAN)
