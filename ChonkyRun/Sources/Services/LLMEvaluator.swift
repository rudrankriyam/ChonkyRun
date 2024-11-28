// Copyright © 2024 Rudrank Riyam

import Foundation
import MLXLLM
import MLX
import MLXRandom
import os

private let llmLogger = Logger(
  subsystem: "com.example.LLMEval",
  category: "LLM"
)

@Observable
final class LLMEvaluator: @unchecked Sendable {
  private let viewModel: TrainingScheduleViewModel
  
  var running = false
  var output = ""
  var modelInfo = ""
  var stat = ""
  var inputTokenCount = 0
  var outputTokenCount = 0

  let modelConfiguration = ModelConfiguration.llama3_2_3B_4bit

  /// parameters controlling the output
  let generateParameters = GenerateParameters(temperature: 1.0)

  /// update the display every N tokens -- 4 looks like it updates continuously
  /// and is low overhead.  observed ~15% reduction in tokens/s when updating
  /// on every token
  let displayEveryNTokens = 4

  enum LoadState {
    case idle
    case loaded(ModelContainer)
  }

  var loadState = LoadState.idle

  init(viewModel: TrainingScheduleViewModel) {
    self.viewModel = viewModel
  }

  /// load and return the model -- can be called multiple times, subsequent calls will
  /// just return the loaded model
  func load() async throws -> ModelContainer {
    switch loadState {
    case .idle:
      llmLogger.info("Starting model load for \(self.modelConfiguration.name)")
      MLX.GPU.set(cacheLimit: 20 * 1024 * 1024)
      
      let modelContainer = try await MLXLLM.loadModelContainer(configuration: modelConfiguration)
      { [modelConfiguration] progress in
        Task { @MainActor in
          llmLogger.debug("Download progress: \(progress.fractionCompleted)")
          self.modelInfo = "Downloading \(modelConfiguration.name): \(Int(progress.fractionCompleted * 100))%"
        }
      }
      
      let numParams = await modelContainer.perform { [] model, _ in
        return model.numParameters()
      }
      
      llmLogger.info("Model loaded successfully. Parameters: \(numParams / (1024*1024))M")
      loadState = .loaded(modelContainer)
      return modelContainer
      
    case .loaded(let modelContainer):
      llmLogger.debug("Returning already loaded model")
      return modelContainer
    }
  }

  func generate(prompt: String) async {
    guard !running else {
      llmLogger.notice("Generation already in progress, skipping")
      return
    }
    
    llmLogger.info("Starting generation with prompt length: \(prompt.count)")
    running = true
    output = ""
    
    do {
      let modelContainer = try await load()
      
      let messages = [
        ["role": "user", "content": prompt + createProgressiveTrainingPrompt()]
      ]
      
      let promptTokens = try await modelContainer.perform { _, tokenizer in
        try tokenizer.applyChatTemplate(messages: messages)
      }

      self.inputTokenCount = promptTokens.count

      MLXRandom.seed(UInt64(Date.timeIntervalSinceReferenceDate * 1000))

      let result = await modelContainer.perform { model, tokenizer in
        MLXLLM.generate(
          promptTokens: promptTokens, parameters: generateParameters, model: model,
          tokenizer: tokenizer, extraEOSTokens: modelConfiguration.extraEOSTokens
        ) { tokens in
          self.outputTokenCount = tokens.count
          return .more
        }
      }

      // Only try to parse JSON after generation is complete
      if let jsonData = result.output.data(using: .utf8) {
        llmLogger.debug("Attempting to parse JSON response")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
          let schedule = try decoder.decode(TrainingSchedule.self, from: jsonData)
          llmLogger.info("Successfully parsed training schedule with \(schedule.weeks.count) weeks")
          await MainActor.run {
            self.viewModel.weeks = schedule.weeks
          }
        } catch {
          llmLogger.error("JSON parsing error: \(error.localizedDescription)")
          if let decodingError = error as? DecodingError {
            switch decodingError {
            case .dataCorrupted(let context):
              print("Data corrupted: \(context)")
            case .keyNotFound(let key, let context):
              print("Key '\(key)' not found: \(context)")
            case .typeMismatch(let type, let context):
              print("Type mismatch for type \(type): \(context)")
            case .valueNotFound(let type, let context):
              print("Value of type \(type) not found: \(context)")
            @unknown default:
              print("Unknown decoding error: \(decodingError)")
            }
          }
        }
      }

      print("""
        Tokens/second: \(String(format: "%.3f", result.tokensPerSecond))
        Input tokens: \(inputTokenCount)
        Output tokens: \(outputTokenCount)
        """)
            
    } catch {
      llmLogger.error("Generation failed: \(error.localizedDescription)")
      output = "Failed: \(error)"
    }
    
    running = false
    llmLogger.info("Generation completed")
  }
} 
