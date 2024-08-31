//
//  MainMenuView.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 14/08/2024.
//

import SwiftUI
import NavigationTransitions
import Pow
struct MainMenuView: View {
    @State private var selectedDifficulty: Difficulty = .medium
    @State private var blackoutOpacity: Double = 0.0
    @State private var playerName: String = ""
    @State private var showingPlayerNameInput = false
    @State private var isTutorialMode = false
    @Bindable var gameVm = GameViewModel()
    @Bindable var db = DatabaseManager.shared

    // New state variables for volume controls
    @State private var isMusicPopoverPresented = false
    @State private var isSFXPopoverPresented = false
    @State private var musicVolume: Double = 0.5
    @State private var sfxVolume: Double = 0.5
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

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
                        .font(.kreonTitle)
                        .foregroundStyle(.white)
                        .padding()
                        .background(
                          Image("bigBtnBackground")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 275, height: 200)
                          
                        )
                      

                        Button("Abandon Run") {
                            AudioManager.shared.playSFX("sfxButton")
                            gameVm.abandonRun()
                            gameVm.stageViewModel.updatePlayerScore(db: db)
                        }
                        .font(.kreonTitle2)
                        .foregroundStyle(.white)
                        .padding()
                        .background(
                          Image("bigBtnBackground")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 200)
                          
                        )
                        .padding(.top, 24)
                    } else {
                      VStack {
                        Button("Start New Run") {
                          withAnimation(.easeInOut) {
                                  showingPlayerNameInput = true
                              }
                        }
                        .font(.kreonTitle)
                        .foregroundStyle(.white)
                        .padding()
                        .background(
                          Image("bigBtnBackground")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 275, height: 200)
                          
                        )

                        if showingPlayerNameInput {
                          PlayerNameInputView(playerName: $playerName, isPresented: $showingPlayerNameInput, gameVm: gameVm) {
                              let playerID = db.addNewPlayer(name: playerName)
                              DispatchQueue.main.async {
                                  showingPlayerNameInput = false
                                  gameVm.difficulty = selectedDifficulty
                                gameVm.stageViewModel = StageViewModel(difficulty: selectedDifficulty, player: Player(hp: 44), playerID: playerID, mode: gameVm.mode)
                                  gameVm.stageViewModel.startPlayerTurn()
                                  gameVm.isGameStarted = true
                                gameVm.checkAndUnlockAchievements(db: db, action: .startFirstRun)
                                  AudioManager.shared.playSFX("sfxButton")
                                  AudioManager.shared.changeBackgroundMusic(to: "stage")
                                  withAnimation(.easeInOut(duration: 1.0)) {
                                      blackoutOpacity = 0.0
                                  }
                              }
                          }
                          .transition(.scale)
                      }

                        Button(action: {
                          gameVm.mode = .tutorial
                          gameVm.stageViewModel = StageViewModel(difficulty: selectedDifficulty, player: Player(hp: 99), mode: gameVm.mode)
                          gameVm.isGameStarted = true
                          gameVm.isTutorial = true
                          gameVm.stageViewModel.startPlayerTurn()
                          AudioManager.shared.playSFX("sfxButton")
                          AudioManager.shared.changeBackgroundMusic(to: "stage")
                          withAnimation(.easeInOut(duration: 1.0)) {
                              blackoutOpacity = 0.0
                          }
                      }) {
                        Text("Start Tutorial")
                          .frame(width: 250, height: 100)
                          .font(.kreonBody)
                          .foregroundStyle(.white)
                          .background(Image("bigBtnBackground") .resizable()
                            .scaledToFit()
                            .frame(width: 220, height: 100)
                          )
                          .padding(.top, 16)
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
                         .font(.kreonCaption)
                         .foregroundColor(.white)
                         .frame(width: 50, height: 50)
                         .padding(2)
                     } .background(Image("smallBtnBackground").resizable().scaledToFit())
                     .popover(isPresented: $isMusicPopoverPresented) {
                         VolumeSliderView(volume: $musicVolume, title: "Music Volume")
                             .onDisappear {
                                 AudioManager.shared.setMusicVolume(to: musicVolume)
                             }
                             .padding()
                             .frame(width: 300)
                     }
                     .padding(.horizontal, 8)

                    
                     Button(action: {
                         isSFXPopoverPresented.toggle()
                     }) {
                         Image(systemName: "music.note")
                             .font(.kreonCaption)
                             .foregroundColor(.white)
                             .frame(width: 50, height: 50)
                             .padding(2)
                     }
                     .background(Image("smallBtnBackground").resizable().scaledToFit())
                     .popover(isPresented: $isSFXPopoverPresented) {
                         VolumeSliderView(volume: $sfxVolume, title: "SFX Volume")
                             .onDisappear {
                                 AudioManager.shared.setSFXVolume(to: sfxVolume)
                             }
                             .padding()
                             .frame(width: 300)
                     }

                    Spacer()
                    Button("Statistics") {
                        gameVm.showStatistics = true
                    }
                    .font(.kreonHeadline )
                    .foregroundStyle(.white)
                    .background(
                    Image("bigBtnBackground")
                      .resizable()
                      .scaledToFit()
                      .frame(width: 150, height: 50))
                    .padding(.trailing, horizontalSizeClass == .compact ? 20 : 24)
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
            .navigationDestination(isPresented: $gameVm.isTutorial) {
              TutorialView(gameVm: gameVm, vm: gameVm.stageViewModel, db: db)
            }
            .navigationTransition(.fade(.in))
            .background(Image("mainMenuBackground").resizable().scaledToFill().ignoresSafeArea())
            
            
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.keyboard, edges: .bottom)
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
  @Environment(\.horizontalSizeClass) var horizontalSizeClass


    var body: some View {
        HStack {
            Text(title)
            .font(.kreonSubheadline)
            .foregroundColor(.white)
        }
        .padding()
        .onTapGesture {
            selectedDifficulty = difficulty
        }
        .background(
        Image("bigBtnBackground"))
          .conditionalEffect(
                       .repeat(
                           .glow(color: .yellow, radius: 50),
                           every: 1
                       ),
                       condition: selectedDifficulty == difficulty
                   )
          .padding(.horizontal, horizontalSizeClass == .compact ? 8 : 24)
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
                .font(.kreonTitle)
                .foregroundColor(.white)

            TextField("Name", text: $playerName)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .font(.kreonCaption)
          

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
                        onConfirm()
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
        .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .cornerRadius(12)
        .padding()
        .shadow(radius: 20)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}



#Preview {
    MainMenuView(gameVm: GameViewModel())
}


