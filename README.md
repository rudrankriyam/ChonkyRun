# ChonkyRun

ChonkyRun is an experimental iOS application that combines **HealthKit data analysis** with **on-device AI inference** using **MLX Swift** to create personalized running training plans. This privacy-first approach uses local machine learning to analyze your running history and generate progressive training schedules to improve your 5K and 10K performance.

## What ChonkyRun Does

### Core Purpose
- **Personal Running Coach**: Analyzes your historical running data from HealthKit and generates progressive 4-week training plans
- **Privacy-First AI**: Uses on-device machine learning inference (MLX Swift with Llama 3.2 3B model) rather than cloud-based AI services
- **Performance Optimization**: Specifically designed to help improve your 5K and 10K running times

### Key Features

#### 🏃‍♂️ HealthKit Integration
- Fetches detailed running workout data from the past 2 months
- Analyzes comprehensive metrics including:
  - Distance and duration
  - Average and maximum heart rate
  - Pace and speed data
  - Energy expenditure
  - Running-specific metrics (stride length, ground contact time when available)

#### 🤖 AI-Powered Training Plan Generation
- Uses **MLX Swift** framework for on-device LLM inference
- Runs **Llama 3.2 3B (4-bit quantized)** model locally on your iPhone
- Generates structured JSON training schedules based on your historical performance
- No data leaves your device - complete privacy protection

#### 📅 Progressive Training Structure
The app creates a scientifically-structured 4-week training cycle:
- **Week 1**: Foundation building (20-25km total distance)
- **Week 2**: Build phase (25-30km total distance)
- **Week 3**: Peak training (30-35km total distance)
- **Week 4**: Taper/recovery (20-25km total distance)

#### 🎯 Detailed Workout Planning
- Each week contains exactly 7 days with 4-5 training days and 2-3 rest days
- Workouts include specific intensity levels:
  - **Easy**: Recovery runs at conversational pace
  - **Moderate**: Tempo runs for lactate threshold improvement
  - **Hard**: High-intensity interval training
  - **Recovery**: Active rest and cross-training
- Provides target paces, heart rate zones, and detailed workout descriptions
- Typical weekly structure: Main training (Mon), Easy (Tue), Rest (Wed), Speed work (Thu), Easy (Fri), Long run (Sat), Rest (Sun)

### Technical Architecture

#### Frontend
- **SwiftUI** for modern, responsive user interface
- **Observable** pattern for reactive UI updates
- **MVVM architecture** with clear separation of concerns

#### Data & AI
- **HealthKit** framework for secure health data access
- **MLX Swift** for high-performance on-device AI inference
- **Llama 3.2 3B model** optimized for Apple Silicon
- **JSON-based** structured data parsing for training plans

#### Key Components
- `HealthKitManager`: Handles secure access to workout data
- `LLMEvaluator`: Manages on-device AI model loading and inference
- `TrainingScheduleViewModel`: Coordinates business logic and data flow
- `PromptGenerator`: Creates intelligent prompts for training plan generation

## Requirements

- **iOS 17.0** or later (target: iOS 18.2)
- **Xcode 16.0** or later  
- **Swift 6.0** or later
- **iPhone with A17 Pro or newer** (recommended for optimal MLX performance)
- **HealthKit permissions** for workout data access

## Installation

1. Clone the repository:

```bash
git clone https://github.com/rudrankriyam/ChonkyRun.git
cd ChonkyRun
```

2. Open the project in Xcode:

```bash
open ChonkyRun.xcodeproj
```

3. Build and run the project:
   - Select your target device (iPhone or Simulator)
   - Press ⌘R or click the Play button
   - Grant HealthKit permissions when prompted

## How It Works

1. **Data Collection**: The app requests access to your HealthKit running data from the past 2 months
2. **AI Analysis**: Your workout history is analyzed by the on-device Llama model to understand your current fitness level and training patterns
3. **Plan Generation**: The AI creates a personalized 4-week progressive training plan with specific workouts, intensities, and recovery periods
4. **Schedule Display**: The generated plan is presented in an intuitive weekly view with detailed workout information
5. **Export Options**: You can copy the generated training plan to your clipboard for use in other apps

## Privacy & Security

- **100% On-Device Processing**: All AI inference happens locally on your iPhone
- **No Data Transmission**: Your health data never leaves your device
- **HealthKit Security**: Leverages Apple's secure HealthKit framework
- **Open Source**: Full transparency in how your data is processed

## Target Users

- **Recreational Runners** looking to improve their 5K and 10K times
- **Privacy-Conscious Athletes** who prefer local data processing
- **Tech Enthusiasts** interested in on-device AI applications
- **iOS Users** who want integrated health and fitness tools

## Future Development

This is an **experimental proof-of-concept** demonstrating the potential of combining:
- Modern on-device AI (MLX Swift)
- Health data integration (HealthKit)
- Personalized fitness coaching
- Privacy-preserving machine learning

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the terms found in the LICENSE file.

## Support

For support, please open an issue in the GitHub repository or contact the maintainers.

---

**Note**: ChonkyRun is an experimental application. Always consult with healthcare professionals before starting any new training regimen.
