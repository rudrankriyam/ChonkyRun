// Copyright © 2024 Rudrank Riyam

import SwiftUI

/// A button component for selecting a training week
struct WeekSelectorButton: View {
  let weekNumber: Int
  let isSelected: Bool
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      VStack {
        Text("Week \(weekNumber)")
          .font(.system(size: 16, weight: .bold))
        Text("\(weekNumber * 5)km")
          .font(.system(size: 12))
      }
      .padding(.vertical, 8)
      .padding(.horizontal, 16)
      .background(
        RoundedRectangle(cornerRadius: 12)
          .fill(isSelected ? Color.blue : Color.gray.opacity(0.1))
      )
      .foregroundColor(isSelected ? .white : .primary)
    }
  }
} 
