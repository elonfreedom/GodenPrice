# GodenPrice

[English](#english) | [中文](#中文)

---

## <a id="english"></a>English

A simple and elegant iOS app for tracking real-time gold prices in multiple currencies and units.

### Features

- 📊 **Real-time Gold Prices**: Fetch current gold prices from goldprice.org API
- 💱 **Multiple Units**: Support for USD per ounce ($/oz) and CNY per gram (¥/g)
- 🔄 **Manual Refresh**: Update prices on demand with a single tap
- 📱 **Widget Support**: Live Activity and widgets for quick price checks
- ⚙️ **Persistent Settings**: Your preferred unit is saved between app launches
- 🎨 **Modern UI**: Built with SwiftUI for a native iOS experience

### Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

### Installation

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

### Usage

#### Main App

The app consists of two main tabs:

1. **Price Tab**: Displays the current gold price in your selected unit
   - Tap the "Refresh" button to update the price
   - Price automatically loads when the app opens

2. **Settings Tab**: Configure your preferred display unit
   - Choose between $/oz (USD per ounce) or ¥/g (CNY per gram)
   - Settings are automatically saved and shared with widgets

#### Widgets

- Widget automatically updates with current gold prices
- Respects your unit preference from the settings

### Architecture

The app follows the MVVM (Model-View-ViewModel) architecture pattern:

- **Views**:
  - `ContentView.swift`: Main tab view container
  - `PriceTabView.swift`: Gold price display
  - `SettingsTabView.swift`: User preferences
- **ViewModels**:
  - `GoldPriceViewModel.swift`: Handles data fetching and formatting
- **Widgets**:
  - `CurrentPrice`: Widget extension for home screen

### API

The app uses the [GoldPrice.org](https://goldprice.org) API to fetch real-time gold prices:
- Endpoint: `https://data-asg.goldprice.org/dbXRates/{CURRENCY}`
- Supports both USD and CNY currencies
- Returns price per troy ounce (converted to per gram for CNY)

### Project Structure

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

### License

This project is open source and available under the MIT License.

### Acknowledgments

- Gold price data provided by [GoldPrice.org](https://goldprice.org)
- Created by elon (2025)

---

## <a id="中文"></a>中文

一个简洁优雅的 iOS 应用，用于实时追踪多种货币和单位的黄金价格。

### 功能

- 📊 **实时黄金价格**：从 goldprice.org API 获取当前黄金价格
- 💱 **多单位支持**：支持美元/盎司（$/oz）和人民币/克（¥/g）
- 🔄 **手动刷新**：一键更新价格
- 📱 **小组件支持**：支持动态岛和桌面小组件，随时查看金价
- ⚙️ **持久化设置**：你的单位偏好会自动保存
- 🎨 **现代UI**：基于 SwiftUI 构建，原生体验

### 环境要求

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

### 安装方法

1. 克隆本仓库  
   ```bash
   git clone https://github.com/elonfreedom/GodenPrice.git
   cd GodenPrice
   ```
2. 用 Xcode 打开项目  
   ```bash
   open GodenPrice.xcodeproj
   ```
3. 选择你的目标设备或模拟器
4. 构建并运行项目（⌘R）

### 使用说明

#### 主应用

本应用包含两个主要标签页：

1. **价格页**：显示当前金价，支持一键刷新，启动时自动加载
2. **设置页**：选择显示单位（$/oz 或 ¥/g），设置会自动保存并同步到小组件

#### 小组件

- 支持桌面小组件，显示实时金价
- 遵循你的单位偏好设置

### 架构

采用 MVVM 架构：

- **Views**：
  - `ContentView.swift`：主页面
  - `PriceTabView.swift`：金价显示
  - `SettingsTabView.swift`：用户设置
- **ViewModels**：
  - `GoldPriceViewModel.swift`：数据获取和格式化
- **Widgets**：
  - `CurrentPrice`：小组件扩展

### API

使用 [GoldPrice.org](https://goldprice.org) API 获取实时金价：  
- 接口：`https://data-asg.goldprice.org/dbXRates/{CURRENCY}`
- 支持 USD、CNY 货币
- 返回盎司价（CNY 单位自动转换为克）

### 项目结构

```
GodenPrice/
├── GodenPrice/              # 主应用
│   ├── Views/              # SwiftUI 视图
│   ├── ViewModels/         # 业务逻辑
│   ├── GodenPriceApp.swift # 入口
│   └── ContentView.swift   # 主视图
├── CurrentPrice/           # 小组件扩展
├── GodenPriceTests/        # 单元测试
├── GodenPriceUITests/      # UI 测试
└── GodenPrice.xcodeproj/   # Xcode 工程文件
```

### 协议

本项目基于 MIT 协议开源。

### 鸣谢

- 金价数据由 [GoldPrice.org](https://goldprice.org) 提供
- 作者：elon (2025)

---

[↑ English](#english) | [中文](#中文)