// Copyright © 2024 Rudrank Riyam

import Foundation

extension TrainingWeek {
  static func mockDetailed() -> TrainingSchedule {
    TrainingSchedule(weeks: [
      TrainingWeek(
        weekNumber: 1,
        days: [
          TrainingDay(
            workouts: [
              Workout(
                name: "Easy Run", 
                description: "Light aerobic run to build endurance",
                intensity: .easy, 
                duration: 2700, 
                distance: 5.0
              ),
              Workout(
                name: "Interval Training", 
                description: "Alternate between faster and slower paces to improve cardiovascular fitness",
                intensity: .moderate, 
                duration: 1800, 
                distance: 3.0
              )
            ],
            notes: "Focus on maintaining a consistent pace and breathe naturally"
          )
        ],
        goal: "Build base endurance"
      ),
      TrainingWeek(
        weekNumber: 2,
        days: [
          TrainingDay(
            workouts: [
              Workout(
                name: "Easy Run", 
                description: "Light aerobic run to build endurance",
                intensity: .easy, 
                duration: 2700, 
                distance: 5.0
              ),
              Workout(
                name: "Tempo Run", 
                description: "Run at a moderate to high intensity to improve running efficiency",
                intensity: .moderateToHard, 
                duration: 1200, 
                distance: 2.0
              )
            ],
            notes: "Pay attention to your form and try to maintain a consistent pace"
          )
        ],
        goal: "Increase endurance and introduce speed work"
      ),
      TrainingWeek(
        weekNumber: 3,
        days: [
          TrainingDay(
            workouts: [
              Workout(
                name: "Easy Run", 
                description: "Light aerobic run to build endurance",
                intensity: .easy, 
                duration: 2700, 
                distance: 5.0
              ),
              Workout(
                name: "Interval Training", 
                description: "Alternate between faster and slower paces to improve cardiovascular fitness",
                intensity: .moderate, 
                duration: 1800, 
                distance: 3.0
              ),
              Workout(
                name: "Hill Repeats", 
                description: "Run up hills at a high intensity to improve running efficiency and endurance",
                intensity: .hard, 
                duration: 600, 
                distance: 1.0
              )
            ],
            notes: "Focus on proper form and technique, especially on the hill repeats"
          )
        ],
        goal: "Introduce interval training and hill repeats"
      ),
      TrainingWeek(
        weekNumber: 4,
        days: [
          TrainingDay(
            workouts: [
              Workout(
                name: "Easy Run", 
                description: "Light aerobic run to build endurance",
                intensity: .easy, 
                duration: 2700, 
                distance: 5.0
              ),
              Workout(
                name: "Tempo Run", 
                description: "Run at a moderate to high intensity to improve running efficiency",
                intensity: .moderateToHard, 
                duration: 1200, 
                distance: 2.0
              )
            ],
            notes: "Pay attention to your form and try to maintain a consistent pace"
          )
        ],
        goal: "Maintain endurance and introduce speed work"
      )
    ])
  }
} 
