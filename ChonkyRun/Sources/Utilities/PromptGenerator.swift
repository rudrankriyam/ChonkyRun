// Copyright © 2024 Apple Inc.

import Foundation

/// Creates a progressive training prompt for the LLM
func createProgressiveTrainingPrompt() -> String {
  return """
  Create a 4-week progressive training plan for 5K and 10K improvement. 
    CRITICAL: Respond with ONLY a SINGLE JSON object containing ALL weeks in one array. Do not split into multiple JSON objects.
  
  IMPORTANT: Each week MUST contain exactly 7 days (dayNumber: 1-7), with:
  - 4-5 training days
  - 2-3 rest/recovery days (typically Wednesday and Sunday)
  - Use ONLY these intensity values:
    - "Easy" - for easy runs and recovery activities
    - "Moderate" - for tempo runs
    - "Hard" - for intense workouts
    - "Recovery" - for rest days
    - "Moderate to Hard" - for progressive runs
    - "Medium" - for strength training
  
      Return ONLY a valid JSON object with this EXACT structure:
   CRITICAL FORMAT:
   {
     "weeks": [
       { week1 data },
       { week2 data },
       { week3 data },
       { week4 data }
     ]
   }

   Weekly progression:
   - Week 1: Foundation (20-25km total)
   - Week 2: Build (25-30km total)
   - Week 3: Peak (30-35km total)
   - Week 4: Taper (20-25km total)

   Weekly Structure:
   - Monday: Main training
   - Tuesday: Easy/recovery
   - Wednesday: Rest
   - Thursday: Speed/tempo work
   - Friday: Easy/recovery
   - Saturday: Long run
   - Sunday: Rest

   Example format (MUST include all 4 weeks in a SINGLE JSON object):
   {
     "weeks": [
       {
         "weekNumber": 1,
         "goal": "Foundation Building",
         "days": [
           {
             "dayNumber": 1,
             "workouts": [
               {
                 "name": "Easy Run",
                 "description": "30-minute easy run at conversational pace",
                 "intensity": "Easy",
                 "duration": 1800,
                 "distance": 5.0,
                 "targetPace": "9:00-10:00 min/km",
                 "heartRateZone": "Zone 2 (60-70% MHR)"
               }
             ],
             "notes": "Focus on maintaining conversation pace",
             "recoveryFocus": false
           }
           // ... remaining 6 days ...
         ],
         "totalWeeklyDistance": 20.0,
         "weeklyGoal": "Build aerobic base"
       }
       // MUST include weeks 2, 3, and 4 in the same format
     ]
   }

  Requirements:
  - Each week MUST include ALL 7 DAYS (no missing days)
  - Follow the distance progression exactly
  - Include 2-3 rest days per week
  - Specify exact durations in seconds
  - Include target pace and heart rate zones
  - Use ONLY the specified intensity values
  - Maintain proper progression and recovery
  - Each week should have a unique goal and focus
  """
} 