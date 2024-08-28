//
//  StageContentView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 23/08/2024.
//

import SwiftUI
import NavigationTransitions

struct StageContentView: View {
    @Bindable var vm: StageViewModel

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                EnemyZoneView(vm: vm)
                    .frame(height: UIScreen.main.bounds.height * 0.4)
                    .disabled(vm.isTutorialActive && vm.currentTutorialStep == 0) // Disable until card selected
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(vm.isEnemyZoneHighlighted ? Color.yellow : Color.clear, lineWidth: 3)
                            .animation(.easeInOut, value: vm.isEnemyZoneHighlighted)
                    )

                PlayerZoneView(vm: vm)
                    .frame(height: UIScreen.main.bounds.height * 0.2)
                    .disabled(vm.isTutorialActive && vm.currentTutorialStep <= 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(vm.isPlayerZoneHighlighted ? Color.yellow : Color.clear, lineWidth: 3)
                            .animation(.easeInOut, value: vm.isPlayerZoneHighlighted)
                    )

                PlayerHandView(vm: vm)
                    .frame(height: UIScreen.main.bounds.height * 0.4)
                    .disabled(vm.isTutorialActive && vm.currentTutorialStep > 0)
                    .onTapGesture {
                        if vm.currentTutorialStep == 1 {
                            vm.nextTutorialStep()
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(vm.isPlayerHandHighlighted ? Color.yellow : Color.clear, lineWidth: 3)
                            .animation(.easeInOut, value: vm.isPlayerHandHighlighted)
                    )
            }
            .navigationDestination(isPresented: $vm.isShowingRewards) {
                RewardSelectionOverlay(vm: vm)
            }
            .navigationTransition(.fade(.cross))

            if vm.isTutorialActive {
                TutorialOverlayView(
                    step: vm.tutorialSteps[vm.currentTutorialStep],
                    onNext: vm.nextTutorialStep,
                    position: tutorialPosition(for: vm.currentTutorialStep)
                )
                .transition(.opacity)
            }
        }
    }

    private func tutorialPosition(for step: Int) -> CGPoint {
        let screenBounds = UIScreen.main.bounds
        
        switch step {
        case 0: // Player Hand Tutorial
            // Position near the top of the player hand
            return CGPoint(x: screenBounds.midX, y: screenBounds.height * 0.75)
            
        case 1: // Enemy Zone Tutorial
            // Position above the enemy zone
            return CGPoint(x: screenBounds.midX, y: screenBounds.height * 0.35)
            
        case 2: // Player Area Tutorial
            // Position above the player area (below the enemy zone)
            return CGPoint(x: screenBounds.midX, y: screenBounds.height * 0.55)
            
        case 3: // Card Type Tutorial
            // Position centrally within the player hand area
            return CGPoint(x: screenBounds.midX, y: screenBounds.height * 0.75)
            
        default: // End Turn Tutorial or other default positions
            // Position near the center for general instructions
            return CGPoint(x: screenBounds.midX, y: screenBounds.height * 0.5)
        }
    }
}

#Preview {
    StageContentView(vm: StageViewModel(difficulty: .medium, player: Player(hp: 44), mode: .tutorial))
}
