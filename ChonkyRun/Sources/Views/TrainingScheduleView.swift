// Copyright © 2024 Rudrank Riyam

import SwiftUI

/// The main view for displaying the training schedule
struct TrainingScheduleView: View {
  let trainingSchedule: TrainingSchedule
  @State private var selectedWeek: Int = 1
  @State private var selectedDay: Int = 1
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        Text("Training Plan")
          .font(.system(size: 34, weight: .black))
          .padding(.horizontal)
        
        // Week selector
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 12) {
            ForEach(trainingSchedule.weeks) { week in
              WeekSelectorButton(
                weekNumber: week.weekNumber,
                isSelected: selectedWeek == week.weekNumber,
                action: { selectedWeek = week.weekNumber }
              )
            }
          }
          .padding(.horizontal)
        }
        
        // Current week view
        if let currentWeek = trainingSchedule.weeks.first(where: { $0.weekNumber == selectedWeek }) {
          WeekView(week: currentWeek)
        }
      }
      .padding(.vertical)
    }
  }
} 
