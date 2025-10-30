//
//  PriceTabView.swift
//  GodenPrice
//
//  Created by assistant on 2025/10/30.
//

import SwiftUI

struct PriceTabView: View {
  @StateObject private var vm = GoldPriceViewModel()
  @AppStorage("goldUnit") private var storedUnit: String = GoldUnit.usdPerOunce.rawValue

  var unit: GoldUnit { GoldUnit(rawValue: storedUnit) ?? .usdPerOunce }

  var body: some View {
    VStack(spacing: 16) {
      Spacer()
      Text(vm.formattedPrice(for: unit))
        .font(.system(size: 36, weight: .bold, design: .rounded))
        .multilineTextAlignment(.center)

      if let date = vm.lastUpdated {
        Text("Updated: \(date, style: .time)")
          .font(.footnote)
          .foregroundColor(.secondary)
      }

      if let err = vm.errorMessage {
        Text(err)
          .font(.caption)
          .foregroundColor(.red)
      }

      Spacer()

      HStack {
        Button(action: { Task { await vm.refresh(for: unit) } }) {
          Label("Refresh", systemImage: "arrow.clockwise")
        }
        .buttonStyle(.borderedProminent)

        Spacer()
      }
      .padding([.leading, .trailing], 20)
    }
    .task {
      await vm.refresh(for: unit)
    }
    .padding()
  }
}

struct PriceTabView_Previews: PreviewProvider {
  static var previews: some View {
    PriceTabView()
  }
}
