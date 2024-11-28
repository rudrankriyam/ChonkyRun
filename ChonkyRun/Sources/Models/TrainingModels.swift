// Copyright © 2024 Apple Inc.

import Foundation

/// Represents a day's training schedule
struct TrainingDay: Identifiable, Codable {
  let id = UUID()
  var dayNumber: Int?
  var workouts: [Workout]
  var notes: String?
  var recoveryFocus: Bool?
}

/// Represents a week of training
struct TrainingWeek: Identifiable, Codable {
  let id = UUID()
  var weekNumber: Int
  var days: [TrainingDay]
  var goal: String
  var totalWeeklyDistance: Double?
  var weeklyGoal: String?
}

/// Represents the complete training schedule
struct TrainingSchedule: Codable {
  var weeks: [TrainingWeek]
} 