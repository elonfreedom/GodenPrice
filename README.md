# GodenPrice

A simple and elegant iOS app for tracking real-time gold prices in multiple currencies and units.

## Features

- 📊 **Real-time Gold Prices**: Fetch current gold prices from goldprice.org API
- 💱 **Multiple Units**: Support for USD per ounce ($/oz) and CNY per gram (¥/g)
- 🔄 **Manual Refresh**: Update prices on demand with a single tap
- 📱 **Widget Support**: Live Activity and widgets for quick price checks
- ⚙️ **Persistent Settings**: Your preferred unit is saved between app launches
- 🎨 **Modern UI**: Built with SwiftUI for a native iOS experience

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

2. Open the project in Xcode:
   ```bash
   open GodenPrice.xcodeproj
   ```

3. Select your target device or simulator

4. Build and run the project (⌘R)

## Usage

### Main App

The app consists of two main tabs:

1. **Price Tab**: Displays the current gold price in your selected unit
   - Tap the "Refresh" button to update the price
   - Price automatically loads when the app opens

2. **Settings Tab**: Configure your preferred display unit
   - Choose between $/oz (USD per ounce) or ¥/g (CNY per gram)
   - Settings are automatically saved and shared with widgets

### Widgets

The app includes widget support for home screen integration:
- Widget automatically updates with current gold prices
- Respects your unit preference from the settings

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture pattern:

- **Views**: 
  - `ContentView.swift`: Main tab view container
  - `PriceTabView.swift`: Gold price display
  - `SettingsTabView.swift`: User preferences
  
- **ViewModels**:
  - `GoldPriceViewModel.swift`: Handles data fetching and formatting

- **Widgets**:
  - `CurrentPrice`: Widget extension for home screen

## API

The app uses the [GoldPrice.org](https://goldprice.org) API to fetch real-time gold prices:
- Endpoint: `https://data-asg.goldprice.org/dbXRates/{CURRENCY}`
- Supports both USD and CNY currencies
- Returns price per troy ounce (converted to per gram for CNY)

## Project Structure

```
GodenPrice/
├── GodenPrice/              # Main app
│   ├── Views/              # SwiftUI views
│   ├── ViewModels/         # Business logic
│   ├── GodenPriceApp.swift # App entry point
│   └── ContentView.swift   # Main view
├── CurrentPrice/           # Widget extension
├── GodenPriceTests/        # Unit tests
├── GodenPriceUITests/      # UI tests
└── GodenPrice.xcodeproj/   # Xcode project
```

## License

This project is open source and available under the MIT License.

## Acknowledgments

- Gold price data provided by [GoldPrice.org](https://goldprice.org)
- Created by elon (2025)
