//
//  EnemyFactory.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 14/08/2024.
//

import Foundation

let enemiesByStage: [Int: [Enemy]] = [
    1: [
        Enemy(name: "Enemy 1", hp: 1, enemyImages: ["Mushroom-Idle.gif", "Mushroom-Damage.gif"]),
    ],
    2: [
        Enemy(name: "Enemy 1", hp: 1, enemyImages: ["Mushroom-Idle.gif", "Mushroom-Damage.gif"]),
        Enemy(name: "Enemy 2", hp: 1, enemyImages: ["Bat-Idle.gif", "Bat-Damage.gif"])
    ],
    3: [
        Enemy(name: "Enemy 1", hp: 1, enemyImages: ["Bat-Idle.gif", "Bat-Damage.gif"]),
        Enemy(name: "Enemy 2", hp: 1, enemyImages: ["Bat-Idle.gif", "Bat-Damage.gif"])
    ],
    4: [
        Enemy(name: "Enemy 1", hp: 1, enemyImages: ["Mushroom-Idle.gif", "Mushroom-Damage.gif"]),
        Enemy(name: "Enemy 2", hp: 1, enemyImages: ["Skeleton-Idle.gif", "Skeleton-Damage.gif"]),
        Enemy(name: "Enemy 3", hp: 1, enemyImages: ["Mushroom-Idle.gif", "Mushroom-Damage.gif"])
    ],
    5: [
        Enemy(name: "Enemy 1", hp: 1, enemyImages: ["Skeleton-Idle.gif", "Skeleton-Damage.gif"]),
        Enemy(name: "Enemy 2", hp: 1, enemyImages: ["Bat-Idle.gif", "Bat-Damage.gif"])
    ],
    6: [
        Enemy(name: "Enemy 1", hp: 1, enemyImages: ["Skeleton-Idle.gif", "Skeleton-Damage.gif"]),
    ],
    7: [
        Enemy(name: "Enemy 1", hp: 1, enemyImages: ["Bat-Idle.gif", "Bat-Damage.gif"]),
        Enemy(name: "Enemy 2", hp: 1, enemyImages: ["Mushroom-Idle.gif", "Mushroom-Damage.gif"]),
    ],
    8: [
        Enemy(name: "Enemy 1", hp: 1, enemyImages: ["Mushroom-Idle.gif", "Mushroom-Damage.gif"]),
    ],
    9: [
        Enemy(name: "Enemy 1", hp: 1, enemyImages: ["Bat-Idle.gif", "Bat-Damage.gif"]),
        Enemy(name: "Enemy 2", hp: 1, enemyImages: ["Mushroom-Idl.gife", "Mushroom-Damage.gif"]),
    ],
    10: [
        Enemy(name: "Enemy 1", hp: 1, enemyImages: ["Skeleton-Idle.gif", "Skeleton-Damage.gif"]),
        Enemy(name: "Enemy 2", hp: 1, enemyImages: ["Mushroom-Idle.gif", "Mushroom-Damage.gif"]),
        Enemy(name: "Enemy 3", hp: 1, enemyImages: ["Skeleton-Idle.gif", "Skeleton-Damage.gif"])
    ],
    11: [
        Enemy(name: "Enemy 1", hp: 1, enemyImages: ["Mushroom-Idle.gif", "Mushroom-Damage.gif"]),
        Enemy(name: "Boss", hp: 1, isBoss: true, enemyImages: ["Boss-Idle.gif", "Boss-Damage.gif"]),
        Enemy(name: "Enemy 3", hp: 1, enemyImages: ["Mushroom-Idle.gif", "Mushroom-Damage.gif"])
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
            hpMultiplier = 0.8
        case .medium:
            hpMultiplier = 1.0
        case .hard:
            hpMultiplier = 1.2
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


