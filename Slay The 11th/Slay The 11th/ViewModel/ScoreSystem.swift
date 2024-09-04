/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Duong Tran Minh Hoang
  ID: 3978452
  Created  date: 28/08/2024
  Last modified: 04/09/2024
  Acknowledgement: None
*/

import Foundation
extension StageViewModel {
  func startTimer() {
      startTime = Date()
      timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
          self.updateElapsedTime()
      }
  }

  private func updateElapsedTime() {
      guard let startTime = startTime else { return }
      elapsedTime = Date().timeIntervalSince(startTime)
  }
  
  func pauseTimer() {
      timer?.invalidate() // Stop the timer
      timer = nil
      // Update the elapsed time up to the point of pausing
      updateElapsedTime()
  }
  
  func calculateScore() {
      // Define base multipliers
      let difficultyMultiplier: Int
      switch difficulty {
      case .easy:
          difficultyMultiplier = 1
      case .medium:
          difficultyMultiplier = 2
      case .hard:
          difficultyMultiplier = 3
      }

      // Time factor (inverse of elapsed time)
      let timeFactor: Int = max(1, Int(1000 / max(1, elapsedTime))) // Prevent division by zero

      // Non-linear stage multiplier (example using exponential growth)
      let stageMultiplier: Int = Int(pow(Double(currentStage), 2))

      // Calculate the score
      score = difficultyMultiplier * timeFactor * stageMultiplier
  }

  func resumeTimer() {
      startTime = Date() // Reset start time to now
      startTimer() // Start the timer again
  }
}
