// Copyright © 2024 Apple Inc.

import Foundation

/// Represents a single workout
///
/// A workout contains information about a planned exercise activity including:
/// - A unique identifier
/// - Name and description
/// - Intensity level
/// - Duration and optional distance
/// - Optional target pace and heart rate zone
struct Workout: Identifiable, Codable {
  let id: UUID
  var name: String
  var description: String
  var intensity: WorkoutIntensity
  var duration: TimeInterval
  var distance: Double?
  var targetPace: String?
  var heartRateZone: String?
  
  init(id: UUID = UUID(), name: String, description: String, intensity: WorkoutIntensity, duration: TimeInterval, distance: Double? = nil, targetPace: String? = nil, heartRateZone: String? = nil) {
    self.id = id
    self.name = name
    self.description = description
    self.intensity = intensity
    self.duration = duration
    self.distance = distance
    self.targetPace = targetPace
    self.heartRateZone = heartRateZone
  }
}