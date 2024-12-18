// Copyright © 2024 Rudrank Riyam

import SwiftUI
import MLXLLM
import MLX
import MLXRandom
import Metal
import os

private let healthKitLogger = Logger(
  subsystem: "com.example.LLMEval",
  category: "HealthKit"
)

/// The main content view of the application
struct ContentView: View {
  @State var prompt = ""
  @State private var viewModel = TrainingScheduleViewModel()
  @State var llm: LLMEvaluator
  @State private var healthKitManager = HealthKitManager()
  @State private var isLoadingWorkouts = false
  @State private var showHealthKitError = false
  @State private var healthKitError: Error?
  
  init() {
    let viewModel = TrainingScheduleViewModel()
    _viewModel = State(initialValue: viewModel)
    _llm = State(initialValue: LLMEvaluator(viewModel: viewModel))
  }
  
  enum DisplayStyle: String, CaseIterable, Identifiable {
    case schedule
    var id: Self { self }
  }
  
  @State private var selectedDisplayStyle = DisplayStyle.schedule

  var body: some View {
    NavigationStack {
      VStack {
        HStack {
          Spacer()
          if llm.running {
            ProgressView()
              .frame(maxHeight: 20)
            Spacer()
          }
        }
        TrainingScheduleView(trainingSchedule: TrainingSchedule(weeks: viewModel.weeks))
      }
    }
    .alert("HealthKit Error", isPresented: $showHealthKitError) {
      Button("OK", role: .cancel) { }
    } message: {
      Text(healthKitError?.localizedDescription ?? "Unknown error")
    }
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Button {
          Task {
            copyToClipboard(llm.output)
          }
        } label: {
          Label("Copy Output", systemImage: "doc.on.doc.fill")
        }
        .disabled(llm.output == "")
        .labelStyle(.titleAndIcon)
      }
    }
    .task {
      // pre-load the weights on launch to speed up the first generation
      _ = try? await llm.load()

      await loadHealthKitData()

      generate()  
    }
  }
  
  private func generate() {
    Task {
      await llm.generate(prompt: prompt)
    }
  }
  
  private func copyToClipboard(_ string: String) {
    #if os(macOS)
      NSPasteboard.general.clearContents()
      NSPasteboard.general.setString(string, forType: .string)
    #else
      UIPasteboard.general.string = string
    #endif
  }
  
  private func loadHealthKitData() async {
    healthKitLogger.info("Starting HealthKit data load")
    isLoadingWorkouts = true
    do {
      healthKitLogger.debug("Requesting HealthKit authorization")
      try await healthKitManager.requestAuthorization()
      
      healthKitLogger.debug("Fetching workouts")
      try await healthKitManager.fetchWorkouts()
      
      healthKitLogger.debug("Formatting workouts for prompt")
      prompt = await healthKitManager.formatWorkoutsForPrompt()

      print("Prompt: \(prompt)")

      healthKitLogger.info("Successfully loaded HealthKit data")
    } catch {
      healthKitLogger.error("HealthKit error: \(error.localizedDescription)")
      healthKitError = error
      showHealthKitError = true
    }
    isLoadingWorkouts = false
  }
} 
