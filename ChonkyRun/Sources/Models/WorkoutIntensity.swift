// Copyright © 2024 Apple Inc.

import SwiftUI

/// Represents the intensity level of a workout
enum WorkoutIntensity: String, Codable {
  case easy = "Easy"
  case moderate = "Moderate" 
  case hard = "Hard"
  case recovery = "Recovery"
  case moderateToHard = "Moderate to Hard"
  case medium = "Medium"  // Added for strength training
}

extension WorkoutIntensity {
  var color: Color {
    switch self {
    case .easy:
      return .green
    case .moderate:
      return .blue
    case .hard:
      return .red
    case .recovery:
      return .mint
    case .moderateToHard:
      return .orange
    case .medium:
      return .purple
    }
  }
} 