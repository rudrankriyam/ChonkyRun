// Copyright © 2024 Apple Inc.

import SwiftUI

/// A view component that displays a day's workout information
struct DayWorkoutCard: View {
  let day: TrainingDay
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      workoutsList
      notesSection
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 8)
  }
  
  // MARK: - Workout List
  private var workoutsList: some View {
    LazyVStack {
      ForEach(day.workouts) { workout in
        workoutCard(for: workout)
      }
    }
  }
  
  // MARK: - Individual Workout Card
  private func workoutCard(for workout: Workout) -> some View {
    VStack(alignment: .leading, spacing: 4) {
      workoutTitle(workout)
      workoutDescription(workout)
      workoutMetrics(workout)
    }
    .padding(12)
    .background(cardBackground(for: workout))
  }
  
  // MARK: - Card Components
  private func workoutTitle(_ workout: Workout) -> some View {
    Text(workout.name)
      .font(.system(size: 18, weight: .bold))
      .lineLimit(1)
  }
  
  private func workoutDescription(_ workout: Workout) -> some View {
    Text(workout.description)
      .font(.system(size: 12))
      .foregroundColor(.secondary)
      .lineLimit(2)
  }
  
  private func workoutMetrics(_ workout: Workout) -> some View {
    HStack {
      metricView(icon: "timer", value: formatDuration(seconds: workout.duration), color: workout.intensity.color)
      metricView(
        icon: "map",
        value: String(format: "%.1f km", workout.distance ?? 0),
        color: workout.intensity.color
      )
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .font(.system(size: 10))
    .foregroundColor(.secondary)
  }
  
  private func metricView(icon: String, value: String, color: Color) -> some View {
    HStack {
      Image(systemName: icon)
        .foregroundColor(color)
      Text(value)
    }
  }
  
  // MARK: - Card Background
  private func cardBackground(for workout: Workout) -> some View {
    RoundedRectangle(cornerRadius: 12)
      .fill(
        LinearGradient(
          gradient: Gradient(colors: [
            workout.intensity.color.opacity(0.1),
            workout.intensity.color.opacity(0.3)
          ]),
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        )
      )
      .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
  }
  
  // MARK: - Notes Section
  private var notesSection: some View {
    Group {
      if let notes = day.notes {
        Text(notes)
          .font(.system(size: 12))
          .foregroundColor(.secondary)
          .padding(.horizontal)
      }
    }
  }
  
  // MARK: - Helper Functions
  private func formatDuration(seconds: TimeInterval) -> String {
    let minutes = Int(seconds) / 60
    let remainingSeconds = Int(seconds) % 60
    return String(format: "%d:%02d", minutes, remainingSeconds)
  }
} 