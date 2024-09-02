//
//  TutorialView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 30/08/2024.
//

import SwiftUI
import NavigationTransitions
import SDWebImageSwiftUI

// Define your tutorial steps
enum TutorialStep {
    case introduction
    case highlightHand
    case explainCardTypes
    case selectCard
    case highlightEnemyZone
    case explainEnemyDetails
    case applyCard
    case complete
}

struct TutorialView: View {
    var gameVm: GameViewModel
    @State private var currentStep: TutorialStep = .introduction
    @State private var showSpotlight: Bool = true
    @State private var currentSpot: Int = 0
    @State private var isOverlayActive: Bool = true
    @State private var isInteractive: Bool = false
    var vm: StageViewModel
    var db: DatabaseManager
    var toastManager = ToastManager.shared
    @State private var blackoutOpacity: Double = 0.0
    @State private var showGameOverView: Bool = false
    @State private var isPaused: Bool = false
    @State private var showMenuSheet: Bool = false
  @State var isAnimating: Bool = true

  var body: some View {
    ZStack {
             // Game content view
           VStack(spacing: 0) {
                 // Enemy Zone
             VStack(spacing: 0) {
               GeometryReader { geometry in
                     let offsetValue = geometry.size.width * 0.02
                     let enemyWidth = geometry.size.width * 0.3
                     let enemyHeight = geometry.size.height * 0.35

                     VStack {
                         // No loop; directly place one CharacterBody2D
                       ZStack {
                         ZStack {
                               // Debuff Effects and HP Bar
                               VStack(spacing: 16) {
                                 // Using if let
                                 if let imageName =  vm.enemies.first?.enemyState == .takingDamage ?  vm.enemies.first?.enemyImages[1] :  vm.enemies.first?.enemyImages[0] {
                                     AnimatedImage(name: imageName, isAnimating: $isAnimating)
                                         .resizable()
                                         .aspectRatio(contentMode: .fit)
                                         .frame(width: 150, height: 150)
                                         .offset(y: offsetValue)
                                         .addSpotlight(1, shape: .rectangle, text: NSLocalizedString("step1", comment: "Taps on enemy to use card"))

                                 }


                                   Image(systemName: vm.enemies.first?.intendedAction == .attack ? "flame.fill" :
                                          vm.enemies.first?.intendedAction == .buff ? "arrow.up.circle.fill" :
                                          vm.enemies.first?.intendedAction == .cleanse ? "figure.mind.and.body" :
                                          "speaker.slash.fill"
                                   )
                                   .foregroundColor(.white)
                                   .background(Color.black.opacity(0.7))
                                   .cornerRadius(4)
                                   .padding(4)
                                   .addSpotlight(2, shape: .rectangle, text: NSLocalizedString("step2", comment: "This shows their intentions"))

                                 
                                   Text("\(vm.enemies.first?.curHp ?? 0)/\(vm.enemies.first?.maxHp ?? 0)")
                                       .font(.kreonSubheadline)
                                       .foregroundColor(.white)
                                       .padding(4)
                                       .background(Color.green)
                                       .cornerRadius(4)
                                       .addSpotlight(3, shape: .rectangle, text: NSLocalizedString("step3", comment: "This is their HP bar"))

                               }
                               .frame(width: enemyWidth, height: enemyHeight)
                               .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                               .clipped()
                               .padding(.top, 48)

                               // Debuff Icons
                               HStack(spacing: 2) {
                                   if let enemy = vm.enemies.first {
                                       ForEach(enemy.debuffEffects, id: \.self) { debuff in
                                           VStack {
                                               Text(debuff.type == .poison ? "☠️" : "🔇")
                                               Text("\(debuff.duration)x")
                                                   .font(.kreonSubheadline)
                                                   .foregroundColor(.white)
                                           }
                                           .padding(4)
                                           .background(Color.black.opacity(0.7))
                                           .cornerRadius(4)
                                       }
                                   }
                               }
                               .position(x: geometry.size.width / 2, y: geometry.size.height / 2 - enemyHeight / 2 - 20)
                               .addSpotlight(4, shape: .rectangle, text: NSLocalizedString("step4", comment: "The icon above is their debuff"))

                         }
                         Rectangle()
                             .fill(Color.black.opacity(0.001))
                             .frame(width: enemyWidth, height: enemyHeight)
                             .offset(y: offsetValue)
                             .onTapGesture {
                                 if let firstEnemyIndex = vm.enemies.firstIndex(where: { $0.name == "Dummy" }) {
                                     vm.applyCard(at: firstEnemyIndex)
                                 } else {
                                     print("No enemy found to apply card to.")
                                 }
                             }
                       }
                     }
                     .frame(width: geometry.size.width, height: geometry.size.height)
                     .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                     
                 }
               .frame(height: UIScreen.main.bounds.height * 0.4)
               
               // Player Zone
           GeometryReader { geometry in
               let zoneWidth = geometry.size.width
               let zoneHeight = geometry.size.height

               ZStack {
                   // Background

                   HStack {
                     Spacer()
                       VStack(spacing: 10) {
                           HStack(spacing: 8) {
                               Image(systemName: "shield.fill")
                                   .resizable()
                                   .frame(width: 20, height: 20)
                                   .foregroundColor(.yellow)
                               
                             Text("\(vm.player.tempHP)")
                               .font(.kreonBody)
                                   .foregroundColor(.white)
                           }
                           .padding(.top, 10)
                           .addSpotlight(6, shape: .rectangle, text: NSLocalizedString("step6", comment: "This is the shield you've gained."))


                           ZStack {
                             AnimatedImage(name: vm.player.playerState == .idle ? "Player-Idle.gif" : "Player-Damage.gif", isAnimating: $isAnimating)
                                   .resizable()
                                   .aspectRatio(contentMode: .fit)
                                   .frame(width: zoneWidth * 0.25, height: zoneHeight * 0.4)
                                   .addSpotlight(5, shape: .rectangle, text: NSLocalizedString("step5", comment: "This is you. The player."))


                               Rectangle()
                                   .fill(Color.black.opacity(0.001))
                                   .frame(width: zoneWidth * 0.2, height: zoneHeight * 0.4)
                                   .onTapGesture {
                                       if let card = vm.selectedCard {
                                           switch card.cardType {
                                           case .defense:
                                               vm.applyDefenseEffect(value: card.currentValue)
                                               vm.moveCardToDiscardedDeck(card)
                                               vm.selectedCard = nil
                                               
                                           case .drawCards:
                                               vm.applyDrawEffect(value: card.baseValue)
                                               vm.moveCardToDiscardedDeck(card)
                                               vm.selectedCard = nil
                                               
                                           default:
                                               print("Card type \(card.cardType) is not applicable to the player directly.")
                                           }
                                       }
                                   }
                           }

                         Text("\(vm.player.curHP)/\(vm.player.maxHP)")
                           .font(.kreonBody)
                               .foregroundColor(.white)
                               .padding(4)
                               .background(Color.green)
                               .cornerRadius(4)
                               .addSpotlight(7, shape: .rectangle, text: NSLocalizedString("step7", comment: "This is your HP bar, runs out and you're dead."))

                       }
                       .padding(.leading, 32)
                       
                     
                     Button(action: {
                       vm.endPlayerTurn()
                       AudioManager.shared.playImmediateSFX("sfxButton")
                     }) {
                         Text("End Turn")
                         .font(.kreonBody)
                             .padding(24)
                             .background(Image("bigBtnBackground").resizable())
                             .foregroundColor(.white)
                             .cornerRadius(8)
                             .addSpotlight(8, shape: .rectangle, text: NSLocalizedString("step8", comment: "Click here to end your turn."))

                     }
                     
                     Spacer()
                   }
                   .padding(.horizontal, 16)
               }
               .frame(width: zoneWidth, height: zoneHeight)
           }
           .frame(height: UIScreen.main.bounds.height * 0.2)
             }.background(
              Image("stageBackground")
                .resizable()
                .scaledToFill()
                .blur(radius: 5)
                .frame(height: UIScreen.main.bounds.height * 0.7))
              
                 
                 
                

                 // Player Hand
             GeometryReader { geometry in
                 VStack {
                     ScrollView(.horizontal) {
                         HStack {
                           ForEach(vm.playerHand.indices, id: \.self) { index in
                                 CardView(card: vm.playerHand[index])
                               .shadow(
                                 color: vm.selectedCard?.id == vm.playerHand[index].id ? Color.gray.opacity(0.4) : Color.clear,
                                   radius: vm.selectedCard?.id == vm.playerHand[index].id ? 8 : 0
                               )
                               .onTapGesture {
                                   vm.selectedCard = vm.playerHand[index]
                               }

                           }
                         }
                         .scrollTargetLayout()
                     }
                     .contentMargins(8, for: .scrollContent)
                     .scrollTargetBehavior(.paging)
                 }
                 .frame(width: geometry.size.width, height: geometry.size.height)
                 .background(
                   Image("handBackground")
                     .resizable()
                     .frame(width: geometry.size.width, height: geometry.size.height)
                     .aspectRatio(contentMode: .fill)
                     .clipped()
                 )
                 .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: -5)
             }
                 .frame(height: UIScreen.main.bounds.height * 0.4)
                 .addSpotlight(0, shape: .rectangle, text: NSLocalizedString("step0", comment: "This is your deck, you can select your card from here"))
             
             }
           

             // Header view, if the game is not over
             if !vm.isGameOver {
               StageHeaderView(vm: vm, gameVm: gameVm, isPaused: $isPaused, showMenuSheet: $showMenuSheet, db:db)
             }

             // Pause overlay
             PauseOverlay(isPaused: $isPaused)

             // Handle game over directly in the StageView
             if vm.isGameOver {
                 Color.black
                     .opacity(blackoutOpacity)
                     .edgesIgnoringSafeArea(.all)
                     .onAppear {
                         withAnimation(.easeInOut(duration: 1.2)) {
                             blackoutOpacity = 1.0
                         }
                         DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                             withAnimation(.easeInOut(duration: 0.8)) {
                                 showGameOverView = true
                             }
                         }
                     }

                 if showGameOverView {
                     GameOverView(onConfirm: {
                         vm.isGameOver = false
                       gameVm.isGameStarted = false
                     })
                     .background(Color.black.opacity(0.8))
                     .edgesIgnoringSafeArea(.all)
                     .transition(.opacity.combined(with: .scale))
                     .navigationTransition(.fade(.out))
                 }
             }
           
           // Add this section for the toast
           if toastManager.showToast, let message = toastManager.toastMessage {
               ToastView(message: message)
                   .transition(.move(edge: .top).combined(with: .opacity))
                   .onAppear {
                       DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                           withAnimation {
                               toastManager.showToast = false
                               toastManager.toastMessage = nil
                           }
                       }
                   }
           }
         }
         .navigationBarHidden(true)
         .addSpotlightOverlay(show: $showSpotlight, currentSpot: $currentSpot)
    
  }
    // Handle progression through the tutorial steps
    func handleTutorialStep() {
        switch currentStep {
        case .introduction:
            currentStep = .highlightHand
        case .highlightHand:
            currentSpot = 3
            currentStep = .explainCardTypes
        case .explainCardTypes:
            currentSpot = 3
            currentStep = .selectCard
        case .selectCard:
            isOverlayActive = false // Temporarily dismiss the overlay to allow interaction
            currentStep = .highlightEnemyZone
        case .highlightEnemyZone:
            isOverlayActive = true // Re-enable overlay
            currentSpot = 1
            currentStep = .explainEnemyDetails
        case .explainEnemyDetails:
            currentSpot = 1
            currentStep = .applyCard
        case .applyCard:
            isOverlayActive = false // Temporarily dismiss the overlay to allow interaction
            currentStep = .complete
        case .complete:
            isOverlayActive = false // End tutorial
        }
        updateTutorialStep()
    }

    // Update tutorial step logic, including the highlighted area and interactivity
    func updateTutorialStep() {
        switch currentStep {
        case .introduction:
            isInteractive = false
        case .highlightHand:
            isInteractive = false
            currentSpot = 3 // Highlight PlayerHandView
        case .explainCardTypes:
            isInteractive = false
            currentSpot = 3
        case .selectCard:
            isInteractive = true // Allow interaction to select a card
        case .highlightEnemyZone:
            isInteractive = false
            currentSpot = 1 // Highlight EnemyZoneView
        case .explainEnemyDetails:
            isInteractive = false
            currentSpot = 1
        case .applyCard:
            isInteractive = true // Allow interaction to apply the card
        case .complete:
            isOverlayActive = false
        }
    }
}

#Preview {
  TutorialView(gameVm: GameViewModel(), vm: StageViewModel(difficulty: .medium, player: Player(hp: 44), mode: .tutorial), db: MockDataManager())
}
