//
//  CurrentPrice.swift
//  CurrentPrice
//
//  Created by elon on 2025/10/29.
//

import WidgetKit
import SwiftUI

// Shared App Group identifier. You must enable this App Group in the main app and widget targets
// and replace the value below with your actual App Group (for example: "group.com.yourcompany.GodenPrice").
private let appGroupID = "group.com.elon.GodenPrice"

// conversion constant
private let gramsPerOunce = 31.1034768

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), price: 2250.50, currencyCode: "USD", unitRaw: "USD_OZ", suffix: "/oz", lastUpdate: Date())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, price: 2250.50, currencyCode: "USD", unitRaw: "USD_OZ", suffix: "/oz", lastUpdate: Date())
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let now = Date()

        // Determine user's selected unit. Try App Group shared UserDefaults first, then fall back to standard UserDefaults.
        let userDefaults = UserDefaults(suiteName: appGroupID) ?? UserDefaults.standard
        let stored = userDefaults.string(forKey: "goldUnit") ?? UserDefaults.standard.string(forKey: "goldUnit")
        let unitRaw = stored ?? "USD_OZ"

        // Map unit to currency endpoint and whether we need per-gram conversion.
        let usesCNY = (unitRaw == "CNY_G")
        let currencyEndpoint = usesCNY ? "CNY" : "USD"

        var priceSample: Double = 2250.50 // fallback
        var lastUpdate = now
        var suffix = usesCNY ? "/g" : "/oz"

        do {
            let (fetchedPricePerOunce, fetchedAt) = try await Self.fetchLatestGoldPrice(currency: currencyEndpoint)
            if usesCNY {
                // convert CNY per ounce -> CNY per gram
                priceSample = fetchedPricePerOunce / gramsPerOunce
            } else {
                priceSample = fetchedPricePerOunce
            }
            lastUpdate = fetchedAt
        } catch {
            // keep fallback values
        }

        let entry = SimpleEntry(date: now, configuration: configuration, price: priceSample, currencyCode: usesCNY ? "CNY" : "USD", unitRaw: unitRaw, suffix: suffix, lastUpdate: lastUpdate)

        // refresh after 15 minutes
        let nextRefresh = Calendar.current.date(byAdding: .minute, value: 15, to: now) ?? now.addingTimeInterval(15 * 60)
        return Timeline(entries: [entry], policy: .after(nextRefresh))
    }

    // MARK: - Networking
    /// Fetch latest gold price (per ounce) for given currency (e.g. USD or CNY).
    static func fetchLatestGoldPrice(currency: String) async throws -> (Double, Date) {
        guard let url = URL(string: "https://data-asg.goldprice.org/dbXRates/\(currency)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 10

        let (data, _) = try await URLSession.shared.data(for: request)

        struct GoldPriceResponse: Codable {
            let items: [GoldItem]?
        }

        struct GoldItem: Codable {
            let xauPrice: Double?
            let price: Double?
            let ts: Int?
            let date: String?
        }

        let decoder = JSONDecoder()
        if let resp = try? decoder.decode(GoldPriceResponse.self, from: data), let item = resp.items?.first {
            if let p = item.xauPrice ?? item.price {
                if let ts = item.ts {
                    return (p, Date(timeIntervalSince1970: TimeInterval(ts)))
                }
                if let dateStr = item.date, let date = ISO8601DateFormatter().date(from: dateStr) {
                    return (p, date)
                }
                return (p, Date())
            }
        }

        // Fallbacks
        if let flat = try? decoder.decode([String: String].self, from: data) {
            let candidates = ["xauPrice", "xau_price", "price", "last", "bid", "value"]
            for key in candidates {
                if let s = flat[key], let d = Double(s) {
                    return (d, Date())
                }
            }
        }
        if let numFlat = try? decoder.decode([String: Double].self, from: data) {
            let candidates = ["xauPrice", "xau_price", "price", "last", "bid", "value"]
            for key in candidates {
                if let d = numFlat[key] {
                    return (d, Date())
                }
            }
        }

        throw URLError(.cannotParseResponse)
    }

}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    // price expressed according to selection: either USD per ounce or CNY per gram
    let price: Double
    // currency code for formatting
    let currencyCode: String
    // raw storage key value for unit selection
    let unitRaw: String
    // human suffix to display after price ("/oz" or "/g")
    let suffix: String
    // the exact Date when this price was last updated
    let lastUpdate: Date
}

struct CurrentPriceEntryView : View {
    var entry: Provider.Entry

    // formatter for price
    private func priceFormatter(code: String) -> NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = code
        f.maximumFractionDigits = 2
        return f
    }

    // helper to format elapsed time between two dates
    private func formattedElapsed(since lastUpdate: Date, now: Date) -> String {
        let elapsed = max(0, Int(now.timeIntervalSince(lastUpdate)))
        let hours = elapsed / 3600
        let minutes = (elapsed % 3600) / 60
        let seconds = elapsed % 60
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }

    var body: some View {
        ZStack {
            // Centered price
            VStack {
                Spacer()
                let formatter = priceFormatter(code: entry.currencyCode)
                if let priceText = formatter.string(from: NSNumber(value: entry.price)) {
                    Text(priceText + " " + entry.suffix)
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                        .multilineTextAlignment(.center)
                } else {
                    Text(String(format: "%.2f %@", entry.price, entry.suffix))
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                }
                Spacer()
            }

            // Bottom-right elapsed time since lastUpdate, updated every second using TimelineView
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    TimelineView(.periodic(from: .now, by: 1.0)) { timeline in
                        Text("Updated: " + formattedElapsed(since: entry.lastUpdate, now: timeline.date))
                            .font(.system(size: 12, weight: .regular, design: .monospaced))
                            .foregroundColor(.secondary)
                            .padding(6)
                    }
                }
            }
        }
        .padding(6)
    }
}

struct CurrentPrice: Widget {
    let kind: String = "CurrentPrice"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            CurrentPriceEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    CurrentPrice()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, price: 2250.50, currencyCode: "USD", unitRaw: "USD_OZ", suffix: "/oz", lastUpdate: .now)
    SimpleEntry(date: .now, configuration: .starEyes, price: 1999.99 / gramsPerOunce, currencyCode: "CNY", unitRaw: "CNY_G", suffix: "/g", lastUpdate: .now)
}

