import ActivityKit

// Duplicate of the Attributes used by the extension so the app can start/update activities.
struct CurrentPriceAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var price: Double
        var lastUpdated: Date
    }

    var name: String
}
