// Copyright © 2024 Apple Inc.

import Foundation

/// Represents a day's training schedule
/// - Note: A training day contains information about workouts, notes, and recovery status
struct TrainingDay: Identifiable, Codable {
  var id: UUID
  var dayNumber: Int?
  var workouts: [Workout]
  var notes: String?
  var recoveryFocus: Bool?
  
  init(id: UUID = UUID(), dayNumber: Int? = nil, workouts: [Workout] = [], notes: String? = nil, recoveryFocus: Bool? = nil) {
    self.id = id
    self.dayNumber = dayNumber
    self.workouts = workouts
    self.notes = notes
    self.recoveryFocus = recoveryFocus
  }
}

/// Represents a week of training
/// - Note: A training week contains multiple training days and tracks weekly goals and metrics
struct TrainingWeek: Identifiable, Codable {
  var id: UUID
  var weekNumber: Int
  var days: [TrainingDay]
  var goal: String
  var totalWeeklyDistance: Double?
  var weeklyGoal: String?
  
  init(id: UUID = UUID(), weekNumber: Int, days: [TrainingDay] = [], goal: String, totalWeeklyDistance: Double? = nil, weeklyGoal: String? = nil) {
    self.id = id
    self.weekNumber = weekNumber
    self.days = days
    self.goal = goal
    self.totalWeeklyDistance = totalWeeklyDistance
    self.weeklyGoal = weeklyGoal
  }
}

/// Represents the complete training schedule
/// - Note: Contains all training weeks that make up the full schedule
struct TrainingSchedule: Codable {
  var weeks: [TrainingWeek]
} 