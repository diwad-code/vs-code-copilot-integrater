# Windows Apps Skill — Definicja umiejętności
# Plik: skills/windows-apps/skill.md
# Cel: Zakres wiedzy dla aplikacji użytkowych Windows

---
name: "Windows Application Expert"
version: "1.0.0"
description: ".NET 8, WPF, WinForms — nowoczesne aplikacje użytkowe dla Windows"
tags:
  - windows
  - dotnet
  - wpf
  - winforms
  - csharp
  - desktop
---

## 🪟 Zakres umiejętności Aplikacji Windows

### Technologie (w kolejności preferencji):

| Typ aplikacji | Technologia | Kiedy użyć |
|--------------|-------------|------------|
| Proste narzędzie | WinForms + .NET 8 | Formularze, narzędzia admina |
| Złożona aplikacja | WPF + MVVM + .NET 8 | Bogaty UI, bindowania danych |
| Nowoczesna UWP/MSIX | WinUI 3 + .NET 8 | Windows 10/11, Store |
| Konsolowe narzędzie | Console + Spectre.Console | CLI tools, daemons |
| Wieloplatformowe | .NET MAUI | Windows + Android + iOS |

### Wzorzec MVVM dla WPF:

```csharp
// Model — czyste dane (POCO)
// Komentarz: Model to klasa danych bez logiki UI
public class Customer
{
    // Właściwość ID klienta — unikalny identyfikator
    public int Id { get; init; }

    // Imię klienta — wymagane, max 100 znaków
    public required string Name { get; set; }

    // Email — opcjonalny
    public string? Email { get; set; }
}

// ViewModel — logika prezentacji
// Komentarz: ViewModel łączy Model z View przez bindingi
public partial class CustomerViewModel : ObservableObject  // CommunityToolkit.Mvvm
{
    // Automatycznie generuje property z notyfikacją zmian
    [ObservableProperty]
    private string _searchText = string.Empty;

    // Kolekcja klientów z notyfikacją zmian
    public ObservableCollection<Customer> Customers { get; } = new();

    // Komenda wyszukiwania — bindowana do przycisku
    [RelayCommand]
    private async Task SearchAsync()
    {
        // Szukamy klientów po frazie w Name lub Email
        var results = await _customerService.SearchAsync(SearchText);

        // Czyścimy i wypełniamy kolekcję wynikami
        Customers.Clear();
        foreach (var customer in results)
            Customers.Add(customer);
    }
}
```

### NuGet packages których używam:
- **CommunityToolkit.Mvvm** — MVVM toolkit od Microsoftu (ObservableObject, RelayCommand)
- **Microsoft.Extensions.DependencyInjection** — DI container
- **Serilog** — logowanie strukturalne
- **Dapper** — lekki ORM dla SQL
- **EntityFramework Core** — pełny ORM
- **Spectre.Console** — piękne CLI
- **Hardcodet.NotifyIcon.Wpf** — ikonka w zasobniku systemowym
- **Ookii.Dialogs.Wpf** — nowoczesne dialogi (Vista-style)

### Wygląd WPF — nowoczesny styl:
```xml
<!-- ResourceDictionary — globalny styl aplikacji -->
<ResourceDictionary>
    <!-- Kolory główne aplikacji -->
    <Color x:Key="AccentColor">#6366F1</Color>         <!-- Indigo -->
    <Color x:Key="BackgroundColor">#0F0F1A</Color>     <!-- Ciemny -->
    <Color x:Key="SurfaceColor">#1A1A2E</Color>        <!-- Panel -->

    <!-- Styl przycisku akcent -->
    <Style x:Key="AccentButton" TargetType="Button">
        <Setter Property="Background" Value="#6366F1"/>
        <Setter Property="Foreground" Value="White"/>
        <Setter Property="Padding" Value="24,10"/>
        <Setter Property="BorderThickness" Value="0"/>
        <Setter Property="FontSize" Value="14"/>
        <Setter Property="Cursor" Value="Hand"/>
        <!-- Zaokrąglone rogi — nowoczesny look -->
        <Setter Property="Template">
            <Setter.Value>
                <ControlTemplate TargetType="Button">
                    <Border Background="{TemplateBinding Background}"
                            CornerRadius="8"
                            Padding="{TemplateBinding Padding}">
                        <ContentPresenter HorizontalAlignment="Center"
                                          VerticalAlignment="Center"/>
                    </Border>
                </ControlTemplate>
            </Setter.Value>
        </Setter>
    </Style>
</ResourceDictionary>
```

### Packaging i dystrybucja:
- **MSIX** — nowoczesny format, podpisywanie, auto-update
- **Inno Setup** — prosty instalator dla firm
- **WinGet** — Windows Package Manager (dla publicznych narzędzi)
- **ClickOnce** — wdrożenia wewnętrzne, auto-update

### Checklist dla każdej aplikacji Windows:
- [ ] Obsługa HiDPI/4K (manifest z dpiAware)
- [ ] Dark mode (Windows accent color support)
- [ ] Skalowanie czcionek (100%/125%/150%)
- [ ] Obsługa wyjątków globalnych (AppDomain.UnhandledException)
- [ ] Logowanie błędów (Serilog do pliku i EventLog)
- [ ] Konfiguracja w appsettings.json (nie hardkodowana)
- [ ] Ikona aplikacji w zasobniku (jeśli potrzebna)
- [ ] Skrót klawiszowy do uruchomienia (opcjonalnie)
