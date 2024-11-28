// Copyright © 2024 Apple Inc.

import SwiftUI

/// A button component for selecting a training day
struct DaySelectorButton: View {
  let dayNumber: Int
  let isSelected: Bool
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      Text("Day \(dayNumber)")
        .font(.system(size: 14, weight: .medium))
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