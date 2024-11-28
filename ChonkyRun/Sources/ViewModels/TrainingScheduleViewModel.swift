// Copyright © 2024 Rudrank Riyam

import Foundation
import os

private let trainingLogger = Logger(
  subsystem: "com.example.LLMEval",
  category: "Training"
)

/// View model to manage training schedule
@Observable class TrainingScheduleViewModel {
  var weeks: [TrainingWeek] = []
  
  func addWeek(_ week: TrainingWeek) {
    trainingLogger.info("Adding new training week: \(week.weekNumber, privacy: .public)")
    weeks.append(week)
  }
  
  func updateWeek(_ week: TrainingWeek) {
    trainingLogger.info("Updating week \(week.weekNumber, privacy: .public)")
    if let index = weeks.firstIndex(where: { $0.id == week.id }) {
      weeks[index] = week
      trainingLogger.debug("Successfully updated week at index \(index)")
    } else {
      trainingLogger.error("Failed to find week with ID \(week.id) for update")
    }
  }
} 
