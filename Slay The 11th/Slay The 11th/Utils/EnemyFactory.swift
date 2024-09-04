/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Duong Tran Minh Hoang
  ID: 3978452
  Created  date: 14/08/2024
  Last modified: 04/09/2024
  Acknowledgement: None
*/

import Foundation

let enemiesByStage: [Int: [Enemy]] = [
    1: [
        Enemy(name: "Enemy 1", hp: 11, enemyImages: ["Mushroom-Idle.gif", "Mushroom-Damage.gif"]),
    ],
    2: [
        Enemy(name: "Enemy 1", hp: 17, enemyImages: ["Mushroom-Idle.gif", "Mushroom-Damage.gif"]),
        Enemy(name: "Enemy 2", hp: 19, enemyImages: ["Bat-Idle.gif", "Bat-Damage.gif"])
    ],
    3: [
        Enemy(name: "Enemy 1", hp: 22, enemyImages: ["Bat-Idle.gif", "Bat-Damage.gif"]),
        Enemy(name: "Enemy 2", hp: 21, enemyImages: ["Bat-Idle.gif", "Bat-Damage.gif"])
    ],
    4: [
        Enemy(name: "Enemy 1", hp: 24, enemyImages: ["Mushroom-Idle.gif", "Mushroom-Damage.gif"]),
        Enemy(name: "Enemy 2", hp: 25, enemyImages: ["Skeleton-Idle.gif", "Skeleton-Damage.gif"]),
        Enemy(name: "Enemy 3", hp: 20, enemyImages: ["Mushroom-Idle.gif", "Mushroom-Damage.gif"])
    ],
    5: [
        Enemy(name: "Enemy 1", hp: 32, enemyImages: ["Skeleton-Idle.gif", "Skeleton-Damage.gif"]),
        Enemy(name: "Enemy 2", hp: 31, enemyImages: ["Bat-Idle.gif", "Bat-Damage.gif"])
    ],
    6: [
        Enemy(name: "Enemy 1", hp: 49, enemyImages: ["Skeleton-Idle.gif", "Skeleton-Damage.gif"]),
    ],
    7: [
        Enemy(name: "Enemy 1", hp: 36, enemyImages: ["Bat-Idle.gif", "Bat-Damage.gif"]),
        Enemy(name: "Enemy 2", hp: 39, enemyImages: ["Mushroom-Idle.gif", "Mushroom-Damage.gif"]),
    ],
    8: [
        Enemy(name: "Enemy 1", hp: 61, enemyImages: ["Mushroom-Idle.gif", "Mushroom-Damage.gif"]),
    ],
    9: [
        Enemy(name: "Enemy 1", hp: 47, enemyImages: ["Bat-Idle.gif", "Bat-Damage.gif"]),
        Enemy(name: "Enemy 2", hp: 49, enemyImages: ["Mushroom-Idl.gife", "Mushroom-Damage.gif"]),
    ],
    10: [
        Enemy(name: "Enemy 1", hp: 44, enemyImages: ["Skeleton-Idle.gif", "Skeleton-Damage.gif"]),
        Enemy(name: "Enemy 2", hp: 41, enemyImages: ["Mushroom-Idle.gif", "Mushroom-Damage.gif"]),
        Enemy(name: "Enemy 3", hp: 48, enemyImages: ["Skeleton-Idle.gif", "Skeleton-Damage.gif"])
    ],
    11: [
        Enemy(name: "Enemy 1", hp: 59, enemyImages: ["Mushroom-Idle.gif", "Mushroom-Damage.gif"]),
        Enemy(name: "Boss", hp: 250, isBoss: true, enemyImages: ["Boss-Idle.gif", "Boss-Damage.gif"]),
        Enemy(name: "Enemy 3", hp: 51, enemyImages: ["Mushroom-Idle.gif", "Mushroom-Damage.gif"])
    ]
]


class EnemyFactory {
    static func createEnemies(for difficulty: Difficulty, stage: Int) -> [Enemy] {
        guard let baseEnemies = enemiesByStage[stage] else {
            return []
        }
        
        let hpMultiplier: Double
        switch difficulty {
        case .easy:
            hpMultiplier = 0.75
        case .medium:
            hpMultiplier = 1.0
        case .hard:
            hpMultiplier = 1.35
        }
        
        return baseEnemies.map { enemy in
            var newDebuffEffects: [Debuff] = []
            
            // Safely copy debuff effects if they exist
            if !enemy.debuffEffects.isEmpty {
                newDebuffEffects = enemy.debuffEffects
            }
            
            return Enemy(
                name: enemy.name,
                hp: Int(Double(enemy.maxHp) * hpMultiplier),
                debuffEffects: newDebuffEffects, // Safe handling of debuff effects
                isBoss: enemy.isBoss,
                enemyImages: enemy.enemyImages
            )
        }
    }
}


