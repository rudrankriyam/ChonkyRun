// Copyright © 2024 Apple Inc.

import Foundation

/// Represents a single workout
struct Workout: Identifiable, Codable {
  let id = UUID()
  var name: String
  var description: String
  var intensity: WorkoutIntensity
  var duration: TimeInterval
  var distance: Double?
  var targetPace: String?
  var heartRateZone: String?
} 