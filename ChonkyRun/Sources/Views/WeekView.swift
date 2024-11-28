// Copyright © 2024 Apple Inc.

import SwiftUI

/// A view that displays a complete week of training
struct WeekView: View {
  let week: TrainingWeek
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      // Week header
      HStack {
        Text("Week \(week.weekNumber)")
          .font(.system(size: 24, weight: .bold))
      }
      .padding(.horizontal)
      
      // Weekly goal right after week number
      Text(week.goal)
        .font(.system(size: 16))
        .foregroundColor(.secondary)
        .padding(.horizontal)

      // Weekly summary at the bottom
      WeeklySummaryView(week: week)
        .padding(.horizontal)
      
      // All days in a vertical scroll
      ScrollView {
        VStack {
          ForEach(Array(week.days.enumerated()), id: \.element.id) { index, day in
            VStack(alignment: .leading) {
              Text("Day \(index + 1)")
                .font(.system(size: 18, weight: .semibold))
                .padding(.horizontal)

              DayWorkoutCard(day: day)
                .padding(.horizontal)
            }
          }
        }
      }
    }
  }
} 