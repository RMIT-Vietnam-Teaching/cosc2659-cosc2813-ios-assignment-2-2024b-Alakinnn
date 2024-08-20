//
//  EnemyFactory.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 14/08/2024.
//

import Foundation

let enemiesByStage: [Int: [Enemy]] = [
    1: [
        Enemy(name: "Enemy 1", hp: 11),
    ],
    2: [
        Enemy(name: "Enemy 1", hp: 16),
        Enemy(name: "Enemy 2", hp: 22)    
    ],
    3: [
        Enemy(name: "Enemy 1", hp: 30),
        Enemy(name: "Enemy 2", hp: 25)
    ],
    4: [
        Enemy(name: "Enemy 1", hp: 39),
        Enemy(name: "Enemy 2", hp: 31),
        Enemy(name: "Enemy 3", hp: 34)
    ],
    5: [
        Enemy(name: "Enemy 1", hp: 45),
        Enemy(name: "Enemy 3", hp: 43)
    ],
    6: [
        Enemy(name: "Enemy 1", hp: 89),
    ],
    7: [
        Enemy(name: "Enemy 1", hp: 64),
        Enemy(name: "Enemy 2", hp: 71),
    ],
    8: [
        Enemy(name: "Enemy 1", hp: 112),
    ],
    9: [
        Enemy(name: "Enemy 1", hp: 90),
        Enemy(name: "Enemy 2", hp: 92),
    ],
    10: [
        Enemy(name: "Enemy 1", hp: 99),
        Enemy(name: "Enemy 2", hp: 101),
        Enemy(name: "Enemy 3", hp: 93)
    ],
    11: [
        Enemy(name: "Enemy 1", hp: 40),
        Enemy(name: "Boss", hp: 300, isBoss: true),
        Enemy(name: "Enemy 3", hp: 40)
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
                isBoss: enemy.isBoss
            )
        }
    }
}


