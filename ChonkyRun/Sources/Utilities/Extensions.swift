// Copyright © 2024 Rudrank Riyam

import Foundation

/// Helper extension for safe array access
extension Array {
  subscript(safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
} 
