//
//  MainMenuView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 14/08/2024.
//

import SwiftUI
import NavigationTransitions

struct MainMenuView: View {
    @State private var selectedDifficulty: Difficulty = .medium
    @State private var blackoutOpacity: Double = 0.0
    @State private var playerName: String = "" // Player name input
    @State private var showingPlayerNameInput = false // Controls input modal visibility
    @Bindable var gameVm = GameViewModel()
  @Bindable var db = DatabaseManager.shared

    // New state variables for volume controls
    @State private var isMusicPopoverPresented = false
    @State private var isSFXPopoverPresented = false
    @State private var musicVolume: Double = 0.5
    @State private var sfxVolume: Double = 0.5

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Spacer()
                    if gameVm.hasSavedRun {
                        Button("Continue Run") {
                            AudioManager.shared.playSFX("sfxButton")
                            withAnimation(.easeInOut(duration: 1.0)) {
                                blackoutOpacity = 1.0
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                gameVm.isGameStarted = true
                                AudioManager.shared.changeBackgroundMusic(to: "stage")
                                withAnimation(.easeInOut(duration: 1.0)) {
                                    blackoutOpacity = 0.0
                                }
                            }
                        }
                        .font(.largeTitle)
                        .padding()

                        Button("Abandon Run") {
                            AudioManager.shared.playSFX("sfxButton")
                            gameVm.abandonRun()
                        }
                        .font(.title2)
                        .padding()
                    } else {
                      VStack {
                        Button("Start New Run") {
                          withAnimation(.easeInOut) {
                                  showingPlayerNameInput = true
                              }
                        }
                        .font(.custom("Kreon", size: 22))
                        .padding()

                        if showingPlayerNameInput {
                          PlayerNameInputView(playerName: $playerName, isPresented: $showingPlayerNameInput, gameVm: gameVm) {
                              let playerID = db.addNewPlayer(name: playerName)
                              DispatchQueue.main.async {
                                  showingPlayerNameInput = false
                                  gameVm.difficulty = selectedDifficulty
                                  gameVm.stageViewModel = StageViewModel(difficulty: selectedDifficulty, player: Player(hp: 44), playerID: playerID)
                                  gameVm.stageViewModel.startPlayerTurn()
                                  gameVm.isGameStarted = true
                                gameVm.checkAchievements(db: db, action: .startFirstRun)
                                  AudioManager.shared.playSFX("sfxButton")
                                  AudioManager.shared.changeBackgroundMusic(to: "stage")
                                  withAnimation(.easeInOut(duration: 1.0)) {
                                      blackoutOpacity = 0.0
                                  }
                              }
                          }
                          .transition(.scale)
                      }

                        
                        Button("Statistics") {
                            gameVm.showStatistics = true
                        }
                      }

                        HStack {
                            DifficultyOptionButton(title: "Easy", difficulty: .easy, selectedDifficulty: $selectedDifficulty)
                            DifficultyOptionButton(title: "Medium", difficulty: .medium, selectedDifficulty: $selectedDifficulty)
                            DifficultyOptionButton(title: "Hard", difficulty: .hard, selectedDifficulty: $selectedDifficulty)
                        }
                        .padding()
                    }

                    Spacer()

                    // New Buttons for Popovers
                  HStack(spacing: 20) {
                     Button(action: {
                         isMusicPopoverPresented.toggle()
                     }) {
                         Image(systemName: "speaker.2.fill")
                             .font(.system(size: 25))
                             .foregroundColor(.blue)
                     }
                     .popover(isPresented: $isMusicPopoverPresented) {
                         VolumeSliderView(volume: $musicVolume, title: "Music Volume")
                             .onDisappear {
                                 AudioManager.shared.setMusicVolume(to: musicVolume)
                             }
                             .padding()
                             .frame(width: 300)
                     }
                    
                     Button(action: {
                         isSFXPopoverPresented.toggle()
                     }) {
                         Image(systemName: "music.note")
                             .font(.system(size: 25))
                             .foregroundColor(.blue)
                     }
                     .popover(isPresented: $isSFXPopoverPresented) {
                         VolumeSliderView(volume: $sfxVolume, title: "SFX Volume")
                             .onDisappear {
                                 AudioManager.shared.setSFXVolume(to: sfxVolume)
                             }
                             .padding()
                             .frame(width: 300)
                     }
                    Spacer()
                 }
                 .padding()
                }

                // Blackout overlay
                Color.black
                    .opacity(blackoutOpacity)
                    .edgesIgnoringSafeArea(.all)
            }
            .navigationDestination(isPresented: $gameVm.isGameStarted) {
              StageView(vm: gameVm.stageViewModel, gameVm: gameVm, db: db)
            }
            .navigationDestination(isPresented: $gameVm.stageViewModel.allStagesCleared) {
              VictoryView(gameVm: gameVm)
            }
            .navigationDestination(isPresented: $gameVm.showStatistics) {
              StatisticsView(db: db)
            }
            .navigationTransition(.fade(.in))
        }
        .navigationBarHidden(true)
        .onAppear {
            AudioManager.shared.playBackgroundMusic("mainMenu")
        }
        .onDisappear {
            AudioManager.shared.stopBackgroundMusic()
        }
    }
}

struct VolumeSliderView: View {
    @Binding var volume: Double
    let title: String

    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            Slider(value: $volume, in: 0...1)
                .accentColor(.blue)
        }
    }
}

struct DifficultyOptionButton: View {
    let title: String
    let difficulty: Difficulty
    @Binding var selectedDifficulty: Difficulty

    var body: some View {
        HStack {
            Circle()
                .fill(selectedDifficulty == difficulty ? Color.blue : Color.clear)
                .frame(width: 12, height: 24)
                .overlay(
                    Circle().stroke(Color.blue, lineWidth: 2)
                )

            Text(title)
                .font(.title2)
                .foregroundColor(.black)
        }
        .padding()
        .onTapGesture {
            selectedDifficulty = difficulty
        }
    }
}

struct PlayerNameInputView: View {
    @Binding var playerName: String
    @Binding var isPresented: Bool
    var gameVm: GameViewModel
    var onConfirm: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Enter Your Name")
                .font(.custom("Kreon", size: 24))
                .foregroundColor(.white)

            TextField("Name", text: $playerName)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .font(.custom("Kreon", size: 18))

            HStack {
                Button(action: {
                    isPresented = false
                }) {
                    Text("Cancel")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                }

                Button(action: {
                    if !playerName.isEmpty {
                        onConfirm()  // Trigger confirm action
                    }
                }) {
                    Text("Confirm")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(
            Image("wooden_background")  // Use your wooden texture image here
                .resizable()
                .scaledToFill()
        )
        .cornerRadius(12)
        .padding()
        .shadow(radius: 20)
    }
}



#Preview {
    MainMenuView(gameVm: GameViewModel())
}


