//
//  AchievementSystem.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 29/08/2024.
//

import Foundation
import SwiftUI

extension GameViewModel {
  func checkAchievements(db: DatabaseManager,action: AchievementAction) {
        switch action {
        case .startFirstRun:
            if db.isFirstRun() {
                db.unlockAchievement("first_run")
                ToastManager.shared.showToast(message: "Achievement Unlocked: First Run!")
                db.setFirstRun()
            }
        case .gainAttackBuff:
            if !db.isAchievementUnlocked("gain_attack_buff") {
                db.unlockAchievement("gain_attack_buff")
                ToastManager.shared.showToast(message: "Achievement Unlocked: Attack Buff!")
            }
        case .gainShieldBuff:
            if !db.isAchievementUnlocked("gain_shield_buff") {
                db.unlockAchievement("gain_shield_buff")
                ToastManager.shared.showToast(message: "Achievement Unlocked: Shield Buff!")
            }
        case .reachStageSeven:
            if !db.isAchievementUnlocked("reach_stage_7") {
                db.unlockAchievement("reach_stage_7")
                ToastManager.shared.showToast(message: "Achievement Unlocked: Reached Stage 7!")
            }
        case .clearGame:
            if !db.isAchievementUnlocked("clear_game") {
                db.unlockAchievement("clear_game")
                ToastManager.shared.showToast(message: "Achievement Unlocked: Cleared the Game!")
            }
        case .clearGameOnDifficulty(let difficulty):
                let achievementID = "clear_game_\(difficulty.rawValue)"
                if !db.isAchievementUnlocked(achievementID) {
                    db.unlockAchievement(achievementID)
                    ToastManager.shared.showToast(message: "Achievement Unlocked: Cleared the Game on \(difficulty.name.capitalized) Difficulty!")
                }
        }
    }
}

enum AchievementAction {
    case startFirstRun
    case gainAttackBuff
    case gainShieldBuff
    case reachStageSeven
    case clearGame
    case clearGameOnDifficulty(Difficulty)
}
