//
//  GoldPriceViewModel.swift
//  GodenPrice
//
//  Created by assistant on 2025/10/30.
//

import Foundation
import Combine
import SwiftData

@MainActor
final class GoldPriceViewModel: ObservableObject {
    @Published var usdPerOunce: Double? = nil
    @Published var cnyPerOunce: Double? = nil
    @Published var lastUpdated: Date? = nil
    @Published var errorMessage: String? = nil

    // 1 troy ounce = 31.1034768 grams
    private let gramsPerOunce = 31.1034768

    /// Refresh prices according to the selected unit.
    /// If the selected unit uses CNY, we fetch CNY/oz directly from the API (no exchange rate needed).
    func refresh(for unit: GoldUnit = .usdPerOunce) async {
        errorMessage = nil
        let currencyCode = (unit == .usdPerOunce) ? "USD" : "CNY"
        do {
            let (pricePerOunce, priceDate) = try await fetchPricePerOunce(currency: currencyCode)
            if currencyCode == "USD" {
                usdPerOunce = pricePerOunce
                cnyPerOunce = nil
            } else {
                cnyPerOunce = pricePerOunce
                usdPerOunce = nil
            }
            lastUpdated = priceDate
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // Fetch gold price per ounce for the requested currency (e.g. "USD" or "CNY").
    private func fetchPricePerOunce(currency: String) async throws -> (Double, Date) {
        // The API supports different currency endpoints like /dbXRates/USD or /dbXRates/CNY
        guard let url = URL(string: "https://data-asg.goldprice.org/dbXRates/\(currency)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 10

        let (data, _) = try await URLSession.shared.data(for: request)

        struct Response: Codable {
            let items: [Item]?
        }
        struct Item: Codable {
            let xauPrice: Double?
            let price: Double?
            let ts: Int?
            let date: String?
        }

        let decoder = JSONDecoder()
        if let resp = try? decoder.decode(Response.self, from: data), let itm = resp.items?.first {
            if let p = itm.xauPrice ?? itm.price {
                if let ts = itm.ts {
                    return (p, Date(timeIntervalSince1970: TimeInterval(ts)))
                }
                if let dateStr = itm.date, let date = ISO8601DateFormatter().date(from: dateStr) {
                    return (p, date)
                }
                return (p, Date())
            }
        }

        // Fallback: try decoding flat numeric dict or string->double
        if let flat = try? decoder.decode([String: Double].self, from: data) {
            let candidates = ["xauPrice", "xau_price", "price", "last", "bid", "value"]
            for c in candidates { if let v = flat[c] { return (v, Date()) } }
        }
        if let flatS = try? decoder.decode([String: String].self, from: data) {
            let candidates = ["xauPrice", "xau_price", "price", "last", "bid", "value"]
            for c in candidates { if let s = flatS[c], let v = Double(s) { return (v, Date()) } }
        }

        throw URLError(.cannotParseResponse)
    }

    // Helpers for formatted values
    func formattedPrice(for unit: GoldUnit) -> String {
        switch unit {
        case .usdPerOunce:
            if let v = usdPerOunce {
                let f = NumberFormatter()
                f.numberStyle = .currency
                f.currencyCode = "USD"
                f.maximumFractionDigits = 2
                return f.string(from: NSNumber(value: v)) ?? String(format: "$%.2f", v)
            }
            return "—"
        case .cnyPerGram:
            if let cnyPerOunce = cnyPerOunce {
                let cnyPerGram = cnyPerOunce / gramsPerOunce
                let f = NumberFormatter()
                f.numberStyle = .currency
                f.currencyCode = "CNY"
                f.maximumFractionDigits = 2
                return f.string(from: NSNumber(value: cnyPerGram)) ?? String(format: "¥%.2f", cnyPerGram)
            }
            return "—"
        }
    }
}

// Reuse GoldUnit enum (keep in sync with views)
enum GoldUnit: String, Codable, CaseIterable, Identifiable {
    case usdPerOunce = "USD_OZ"
    case cnyPerGram = "CNY_G"

    var id: String { rawValue }
}
