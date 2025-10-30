# GodenPrice

> 本文为中文说明。查看英文请点击： [English](README.md)

一个简洁优雅的 iOS 应用，用于实时追踪多种货币和单位的黄金价格。

## 功能

- 📊 实时黄金价格：从 GoldPrice.org API 获取当前黄金价格
- 💱 多单位支持：支持美元/盎司（$/oz）和人民币/克（¥/g）
- 🔄 手动刷新：一键更新价格
- 📱 小组件支持：动态岛与桌面小组件，快速查看金价
- ⚙️ 持久化设置：偏好单位在应用间保持一致
- 🎨 现代 UI：基于 SwiftUI 构建

## 环境要求

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## 安装方法

1. 克隆仓库：

```bash
git clone https://github.com/elonfreedom/GodenPrice.git
cd GodenPrice
```

1. 用 Xcode 打开项目：

```bash
open GodenPrice.xcodeproj
```

1. 选择目标设备或模拟器。

1. 构建并运行项目（⌘R）。

## 使用说明

### 主应用

应用包含两个主要标签页：

1. **价格页** — 显示当前金价并支持一键刷新，启动时自动加载。
2. **设置页** — 选择显示单位（$/oz 或 ¥/g），设置会持久化并同步到小组件。

### 小组件

- 小组件会自动更新并遵循你的单位偏好。

## 架构

采用 MVVM：

- Views: `ContentView.swift`、`PriceTabView.swift`、`SettingsTabView.swift`
- ViewModel: `GoldPriceViewModel.swift`
- Widgets: `CurrentPrice` 扩展

## API

使用 GoldPrice.org API：

- 接口：`https://data-asg.goldprice.org/dbXRates/{CURRENCY}`
- 支持 USD 与 CNY
- 返回盎司价；展示 CNY/g 时会将 CNY/oz 转换为 CNY/g（除以 31.1034768）

## App Group（重要）

如需在主应用与小组件之间共享偏好，请为主应用目标与小组件扩展启用 App Group，并在 widget 代码中将 `appGroupID` 常量替换为你的 App Group 标识（例如：`group.com.yourcompany.GodenPrice`）。

## 项目结构

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

## 协议

MIT

## 鸣谢

- 金价数据由 [GoldPrice.org](https://goldprice.org) 提供
- 作者：elon (2025)
