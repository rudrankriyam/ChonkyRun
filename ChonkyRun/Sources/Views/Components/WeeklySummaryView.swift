// Copyright © 2024 Rudrank Riyam

import SwiftUI

/// A view component that displays the weekly training summary
struct WeeklySummaryView: View {
  let week: TrainingWeek
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Weekly Goal")
        .font(.system(size: 18, weight: .bold))
      
      Text(week.goal)
        .font(.system(size: 14))
        .foregroundColor(.secondary)
      
      if let totalDistance = week.totalWeeklyDistance {
        HStack {
          Image(systemName: "figure.run")
          Text("Total Distance: \(totalDistance, specifier: "%.1f") km")
        }
        .font(.system(size: 14))
        .foregroundColor(.secondary)
      }
      
      if let weeklyGoal = week.weeklyGoal {
        Text(weeklyGoal)
          .font(.system(size: 14))
          .foregroundColor(.secondary)
      }
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 12)
        .fill(Color.gray.opacity(0.1))
    )
  }
} 
