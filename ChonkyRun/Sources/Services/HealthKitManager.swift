// Copyright © 2024 Rudrank Riyam

import Foundation
import HealthKit
import os

private let healthKitLogger = Logger(
  subsystem: "com.example.LLMEval",
  category: "HealthKit"
)

@Observable final class HealthKitManager: @unchecked Sendable {
  private let healthStore = HKHealthStore()
  var workouts: [HKWorkout] = []
  var error: Error?
  
  // Add new properties for detailed metrics
  private let relevantTypes: Set<HKSampleType> = [
    HKObjectType.workoutType(),
    HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
    HKObjectType.quantityType(forIdentifier: .heartRate)!,
    HKObjectType.quantityType(forIdentifier: .runningSpeed)!,
    HKObjectType.quantityType(forIdentifier: .runningStrideLength)!,
    HKObjectType.quantityType(forIdentifier: .runningGroundContactTime)!,
    HKObjectType.quantityType(forIdentifier: .vo2Max)!
  ]

  func requestAuthorization() async throws {
    healthKitLogger.info("Requesting HealthKit authorization")
    try await healthStore.requestAuthorization(toShare: [], read: relevantTypes)
    healthKitLogger.info("HealthKit authorization granted")
  }

  // Add new function to fetch heart rate data for a workout
  private func fetchHeartRateData(for workout: HKWorkout) async throws -> [Double] {
    let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
    let predicate = HKQuery.predicateForSamples(
      withStart: workout.startDate,
      end: workout.endDate,
      options: .strictStartDate
    )
    
    return try await withCheckedThrowingContinuation { continuation in
      let query = HKSampleQuery(
        sampleType: heartRateType,
        predicate: predicate,
        limit: HKObjectQueryNoLimit,
        sortDescriptors: nil
      ) { _, samples, error in
        if let error = error {
          continuation.resume(throwing: error)
          return
        }
        let heartRates = (samples as? [HKQuantitySample])?.map { sample in
          sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
        } ?? []
        
        continuation.resume(returning: heartRates)
      }
      healthStore.execute(query)
    }
  }

  // Update workout formatting to include detailed metrics
  func formatWorkoutsForPrompt() async -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    
    var workoutSummaries: [String] = []
    
    for workout in workouts {
      // Convert duration from seconds to minutes properly
      let durationMinutes = Int(workout.duration / 60)
      
      // Convert distance from meters to kilometers properly
      let distanceKm = (workout.totalDistance?.doubleValue(for: .meter()) ?? 0) / 1000.0
      
      // Calculate pace (minutes per kilometer) - convert to Double for division
      let paceMinPerKm = Double(durationMinutes) / (distanceKm == 0 ? 1.0 : distanceKm)
      
      // Fetch heart rates asynchronously
      let heartRates = (try? await fetchHeartRateData(for: workout)) ?? []
      let avgHR = heartRates.isEmpty ? 0 : heartRates.reduce(0, +) / Double(heartRates.count)
      let maxHR = heartRates.max() ?? 0
      
      let summary = """
      Date: \(formatter.string(from: workout.startDate))
      Duration: \(durationMinutes) minutes
      Distance: \(String(format: "%.2f", distanceKm)) km
      Average Pace: \(String(format: "%.2f", paceMinPerKm)) min/km
      Average Heart Rate: \(Int(avgHR)) bpm
      Max Heart Rate: \(Int(maxHR)) bpm
      Energy: \(Int(workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0)) kcal
      """
      
      healthKitLogger.info("Workout Summary:\n\(summary)")
      workoutSummaries.append(summary)
    }
    
    let summariesString = workoutSummaries.joined(separator: "\n\n")
    
    let currentDate = formatter.string(from: Date())
    
    return """
    Today's date is \(currentDate).
    Here are my detailed running workouts from the past 2 months. I'm training to improve my 5K and 10K times:
    
    \(summariesString)
    """
  }

  func fetchWorkouts() async throws {
    healthKitLogger.debug("Starting workout fetch")
    
    let workoutType = HKObjectType.workoutType()
    let twoMonthsAgo = Calendar.current.date(byAdding: .month, value: -2, to: Date())!
    
    let predicate = HKQuery.predicateForSamples(
      withStart: twoMonthsAgo,
      end: Date(),
      options: .strictStartDate
    )
    
    // Only fetch running workouts
    let runningPredicate = HKQuery.predicateForWorkouts(with: .running)
    let combinedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, runningPredicate])
    
    let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
    
    return try await withCheckedThrowingContinuation { continuation in
      let query = HKSampleQuery(
        sampleType: workoutType,
        predicate: combinedPredicate,
        limit: HKObjectQueryNoLimit,
        sortDescriptors: [sortDescriptor]
      ) { [weak self] _, samples, error in
        if let error = error {
          healthKitLogger.error("Workout fetch failed: \(error.localizedDescription)")
          continuation.resume(throwing: error)
          return
        }
        
        guard let workouts = samples as? [HKWorkout] else {
          healthKitLogger.error("Failed to cast samples to HKWorkout array")
          continuation.resume(throwing: NSError(domain: "HealthKitManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to cast samples to workouts"]))
          return
        }
        
        healthKitLogger.info("Successfully fetched \(workouts.count) workouts")
        self?.workouts = workouts
        continuation.resume()
      }
      
      healthStore.execute(query)
    }
  }
} 
