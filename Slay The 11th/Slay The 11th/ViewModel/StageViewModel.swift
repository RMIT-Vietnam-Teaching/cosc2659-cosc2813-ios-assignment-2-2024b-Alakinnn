import SwiftUI
import Observation

@Observable class StageViewModel {
    var availableDeck: [Card] = createStaticDeck() // Cards available to draw
    var discardedDeck: [Card] = [] // Cards that have been used
    var playerHand: [Card] = [] // Cards currently in the player's hand
    var player: Player
    var selectedCard: Card? = nil
    var isStageCompleted: Bool = false
    var enemies: [Enemy] = []
    var currentStage: Int = 1
    var isPlayerTurn: Bool = true  // Track if it's the player's turn

    init(difficulty: Difficulty, player: Player) {
        self.player = player
        self.enemies = EnemyFactory.createEnemies(for: difficulty, stage: currentStage)
        startPlayerTurn()
    }

    // Start player's turn
    func startPlayerTurn() {
        isPlayerTurn = true
        resetPlayerTempHP() // Reset temp HP at the start of the player's turn
        drawInitialHand()
    }

    // Reset player's temporary HP
    private func resetPlayerTempHP() {
        player.tempHP = 0
    }

    // End player's turn
    func endPlayerTurn() {
        isPlayerTurn = false
        discardPlayerHand()
        applyPoisonEffects() // Apply poison effects to all enemies
        startEnemyTurn()
    }

    // Helper function to calculate cumulative weights
    func cumulativeSum(_ input: [Double]) -> [Double] {
        var sum: Double = 0
        return input.map { sum += $0; return sum }
    }

  func startEnemyTurn() {
      var cleanseChance = 0.1 // Lower initial cleanse chance

      for (index, enemy) in enemies.enumerated() where enemy.curHp > 0 {
          // Skip the turn if the enemy is silenced
          if enemy.isSilenced() {
              print("Enemy \(enemy.name) is silenced and skips its turn.")
              decrementSilenceEffectDuration(for: &enemies[index])
              continue
          }

          // Increase cleanse chance for each subsequent enemy
          let actionPerformed = performEnemyAction(enemy: &enemies[index], at: index, cleanseChance: cleanseChance)
          if actionPerformed == .cleanse {
              cleanseChance = 0.1 // Reset chance after successful cleanse
          } else {
              cleanseChance += 0.1 // Increase chance if not cleansed
          }

          // Decrement poison and silence effects after the enemy's action
          decrementPoisonEffectDuration(for: &enemies[index])
          decrementSilenceEffectDuration(for: &enemies[index])
      }

      startPlayerTurn() // Back to player turn
  }

  // Function to decrement the silence effect duration
  private func decrementSilenceEffectDuration(for enemy: inout Enemy) {
      if let index = enemy.debuffEffects.firstIndex(where: { $0.type == .silence }) {
          enemy.debuffEffects[index].duration -= 1
          if enemy.debuffEffects[index].duration <= 0 {
              enemy.debuffEffects.removeAll { $0.type == .silence }
          }
      }
  }

  // Function to decrement the poison effect duration
  private func decrementPoisonEffectDuration(for enemy: inout Enemy) {
      if let index = enemy.debuffEffects.firstIndex(where: { $0.type == .poison }) {
          enemy.debuffEffects[index].duration -= 1
          if enemy.debuffEffects[index].duration <= 0 {
              enemy.debuffEffects.removeAll { $0.type == .poison }
          }
      }
  }


    // Perform an action for a given enemy
    func performEnemyAction(enemy: inout Enemy, at index: Int, cleanseChance: Double) -> EnemyAction {
        let possibleActions: [EnemyAction] = [.attack, .buff, .cleanse]
        var chosenAction: EnemyAction = .attack // Default to attack
        var actionWeights: [Double] = [0.6, 0.2, 0.2] // Initial weights: attack is more likely

        // Adjust weights based on current conditions
        if hasDebuffedAlly(excluding: index) {
            actionWeights[2] = cleanseChance // Increase chance for cleanse if there's a debuffed ally
        }

        // Calculate cumulative weights for random selection
        let cumulativeWeights = cumulativeSum(actionWeights)
        let randomValue = Double.random(in: 0...1)
        for (i, weight) in cumulativeWeights.enumerated() where randomValue <= weight {
            chosenAction = possibleActions[i]
            break
        }

        // Perform the chosen action
        switch chosenAction {
        case .attack:
            performAttack(enemy: &enemy)
        case .buff:
            performBuff(enemy: &enemy)
        case .cleanse:
            performCleanse(for: &enemy)
        }

        return chosenAction
    }

    // Perform attack action
    func performAttack(enemy: inout Enemy) {
        let damageRange: ClosedRange<Int>
        if currentStage <= 5 {
            damageRange = 2...6
        } else if currentStage <= 10 {
            damageRange = 4...8
        } else {
            damageRange = enemy.isBoss ? 5...10 : 4...8
        }

        let damage = Int.random(in: damageRange) + enemy.attackBuff
        player.curHP -= max(0, damage - player.tempHP) // Apply temp HP first, then curHP
        player.tempHP = max(0, player.tempHP - damage)

        print("Enemy \(enemy.name) attacks the player for \(damage) damage. Player HP: \(player.curHP)")
    }

    // Check if any ally is debuffed (excluding the current enemy)
    func hasDebuffedAlly(excluding index: Int) -> Bool {
        for (i, ally) in enemies.enumerated() where i != index && ally.isDebuffed() {
            return true
        }
        return false
    }

    // Perform buff action
    func performBuff(enemy: inout Enemy) {
        enemy.applyBuff()
        print("Enemy \(enemy.name) gains +1 attack. Total attack buff: \(enemy.attackBuff)")
    }

    // Perform cleanse action
    func performCleanse(for enemy: inout Enemy) {
        if let debuffedAllyIndex = enemies.firstIndex(where: { $0.isDebuffed() }) {
            enemies[debuffedAllyIndex].cleanse()
            print("Enemy \(enemy.name) cleanses debuffs from \(enemies[debuffedAllyIndex].name).")
        }
    }

    // Draw initial hand (e.g., 5 cards)
    func drawInitialHand() {
        for _ in 0..<5 {
            drawCard()
        }
    }

    // Draw a card from the available deck to the player's hand
    func drawCard() {
        if availableDeck.isEmpty {
            reshuffleDiscardedDeck()
        }
        availableDeck.shuffle()
        if let card = availableDeck.popLast() {
            playerHand.append(card)
        }
    }

    // Reshuffle the discarded deck into the available deck
    func reshuffleDiscardedDeck() {
        availableDeck = discardedDeck.shuffled()
        discardedDeck.removeAll()
    }

    // Discard all cards in the player's hand
    func discardPlayerHand() {
        discardedDeck.append(contentsOf: playerHand)
        playerHand.removeAll()
    }

    // Apply poison effects to all enemies
    func applyPoisonEffects() {
        for index in enemies.indices where enemies[index].curHp > 0 {
            if let poisonIndex = enemies[index].debuffEffects.firstIndex(where: { $0.type == .poison }) {
                let poison = enemies[index].debuffEffects[poisonIndex]
                enemies[index].curHp -= poison.value
                enemies[index].curHp = max(0, enemies[index].curHp)
                enemies[index].debuffEffects[poisonIndex].duration -= 1
                print("Enemy \(enemies[index].name) takes \(poison.value) poison damage. Remaining HP: \(enemies[index].curHp)")
                if enemies[index].debuffEffects[poisonIndex].duration <= 0 {
                    enemies[index].debuffEffects.remove(at: poisonIndex)
                }
            }
        }
        checkIfStageCompleted()
    }

    // Apply a card's effect to the enemy or the player
    func applyCard(at index: Int? = nil) {
        guard let card = selectedCard else {
            print("No card selected")
            return
        }

        // Check if the card is player-specific (defense or draw)
        switch card.cardType {
        case .defense:
            applyDefenseEffect(value: card.value)
        case .drawCards:
            applyDrawEffect(value: card.value)
        default:
            if let enemyIndex = index, enemies[enemyIndex].curHp > 0 { // Ensure enemy is alive
                applyCardToEnemy(at: enemyIndex)
            } else {
                print("This card requires a target or the target is dead")
                return
            }
        }

        // Move the used card to the discarded deck
        moveCardToDiscardedDeck(card)

        // Clear the selected card after applying
        selectedCard = nil
    }

    // Apply a card to an enemy
    private func applyCardToEnemy(at index: Int) {
        guard let card = selectedCard else {
            print("No card selected")
            return
        }

        // Ensure the index is valid
        guard index >= 0 && index < enemies.count else {
            print("Invalid enemy index")
            return
        }

        // Work directly with the enemy in the array
        var enemy = enemies[index]

        switch card.cardType {
        case .attack:
            enemy.curHp -= card.value
            enemy.curHp = max(0, enemy.curHp) // Ensure HP does not drop below 0
            print("Enemy \(enemy.name) takes \(card.value) damage. Remaining HP: \(enemy.curHp)")

        case .poison:
            addOrUpdateDebuff(on: &enemy, type: .poison, value: card.value, duration: 3)
            print("Enemy \(enemy.name) is poisoned for \(card.value) damage per turn.")

        case .silence:
            addOrUpdateDebuff(on: &enemy, type: .silence, value: card.value, duration: 1)
            print("Enemy \(enemy.name) is silenced.")

        default:
            print("Unhandled card type: \(card.cardType)")
        }

        // Update the enemy in the array
        enemies[index] = enemy

        // Move the used card to the discarded deck
        moveCardToDiscardedDeck(card)

        // Clear the selected card after applying
        selectedCard = nil

        // Check if the stage is completed after the attack
        checkIfStageCompleted()
    }

    // Add or update a debuff on the enemy
    private func addOrUpdateDebuff(on enemy: inout Enemy, type: DebuffType, value: Int, duration: Int) {
        if let index = enemy.debuffEffects.firstIndex(where: { $0.type == type }) {
            enemy.debuffEffects[index].value += value
            enemy.debuffEffects[index].duration = max(enemy.debuffEffects[index].duration, duration)
        } else {
            let debuff = Debuff(type: type, value: value, duration: duration)
            enemy.debuffEffects.append(debuff)
        }
    }

    // Apply defense effect to the player
    func applyDefenseEffect(value: Int) {
        player.tempHP += value
        print("Player gains \(value) temporary HP. Total temporary HP: \(player.tempHP)")
    }

    // Apply draw effect (draw additional cards)
    func applyDrawEffect(value: Int) {
        for _ in 0..<value {
            drawCard()
        }
        print("Player draws \(value) cards.")
    }

    // Move a card to the discarded deck
    func moveCardToDiscardedDeck(_ card: Card) {
        if let cardIndex = playerHand.firstIndex(where: { $0.id == card.id }) {
            let removedCard = playerHand.remove(at: cardIndex)
            discardedDeck.append(removedCard)
        }
    }

    private func checkIfStageCompleted() {
        if enemies.allSatisfy({ $0.curHp <= 0 }) {
            isStageCompleted = true
            player.tempHP = 0
        }
    }
}
