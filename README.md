# GodenPrice

> This README defaults to English. 阅读中文请见 `README_zh.md`。

A simple and elegant iOS app for tracking real-time gold prices in multiple currencies and units.

## Features

- 📊 Real-time Gold Prices: Fetch current gold prices from GoldPrice.org API
- 💱 Multiple Units: Support for USD per ounce ($/oz) and CNY per gram (¥/g)
- 🔄 Manual Refresh: Update prices on demand with a single tap
- 📱 Widget Support: Live Activity and widgets for quick price checks
- ⚙️ Persistent Settings: Your preferred unit is saved between app launches
- 🎨 Modern UI: Built with SwiftUI for a native iOS experience

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Installation

1. Clone this repository:

```bash
git clone https://github.com/elonfreedom/GodenPrice.git
cd GodenPrice
```

1. Open the project in Xcode:

```bash
open GodenPrice.xcodeproj
```

1. Select your target device or simulator.

1. Build and run the project (⌘R).

## Usage

### Main App

The app consists of two main tabs:

1. **Price Tab** — Displays the current gold price in your selected unit. Tap the "Refresh" button to update the price; it also loads automatically on launch.
2. **Settings Tab** — Configure your preferred display unit (USD/oz or CNY/g). Settings are persisted and shared with widgets.

### Widgets

- Widgets automatically update with current gold prices and respect your unit preference.

## Architecture

MVVM (Model-View-ViewModel):

- Views: `ContentView.swift`, `PriceTabView.swift`, `SettingsTabView.swift`
- ViewModel: `GoldPriceViewModel.swift`
- Widgets: `CurrentPrice` extension

## API

Uses GoldPrice.org API:

- Endpoint: `https://data-asg.goldprice.org/dbXRates/{CURRENCY}`
- Supports USD and CNY
- Returns price per troy ounce; the app converts to per gram when showing CNY/g

## App Group (Important)

To share the user's unit preference between the app and the widget, enable an App Group for both the main app target and the widget extension. Update the `appGroupID` constant in the widget code to match your App Group identifier (for example: `group.com.yourcompany.GodenPrice`).

## Project Structure

```text
GodenPrice/
├── GodenPrice/              # Main app
│   ├── Views/              # SwiftUI views
│   ├── ViewModels/         # Business logic
   ├── GodenPriceApp.swift # App entry point
   └── ContentView.swift   # Main view
├── CurrentPrice/           # Widget extension
├── GodenPriceTests/        # Unit tests
├── GodenPriceUITests/      # UI tests
└── GodenPrice.xcodeproj/   # Xcode project
```

## License

MIT

## Acknowledgments

- Gold price data provided by [GoldPrice.org](https://goldprice.org)
- Created by elon (2025)
