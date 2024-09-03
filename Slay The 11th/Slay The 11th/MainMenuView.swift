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
    @Binding var gameVm: GameViewModel
    @Bindable var db = DatabaseManager.shared

    // New state variables for volume controls
    @State private var isMusicPopoverPresented = false
    @State private var isSFXPopoverPresented = false
    @State private var musicVolume: Double = 0.5
    @State private var sfxVolume: Double = 0.5
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @State private var showingInfoSheet = false
  @State private var showSettings = false

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Spacer()
                    if gameVm.hasSavedRun {
                        Button(NSLocalizedString("continue_run", comment: "Continue Run button text")) {
                            AudioManager.shared.playImmediateSFX("sfxButton")
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

                        Button(NSLocalizedString("abandon_run", comment: "Abandon Run button text")) {
                            AudioManager.shared.playImmediateSFX("sfxButton")
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
                            Button(NSLocalizedString("start_new_run", comment: "Start New Run button text")) {
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
                                        AudioManager.shared.playImmediateSFX("sfxButton")
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
                                AudioManager.shared.playImmediateSFX("sfxButton")
                                AudioManager.shared.changeBackgroundMusic(to: "stage")
                                withAnimation(.easeInOut(duration: 1.0)) {
                                    blackoutOpacity = 0.0
                                }
                            }) {
                                Text(NSLocalizedString("start_tutorial", comment: "Start Tutorial button text"))
                                    .frame(width: 250, height: 100)
                                    .font(.kreonBody)
                                    .foregroundStyle(.white)
                                    .background(Image("bigBtnBackground").resizable().scaledToFit().frame(width: 220, height: 100))
                                    .padding(.top, 16)
                            }
                        }

                        HStack {
                            DifficultyOptionButton(title: NSLocalizedString("easy", comment: "Easy difficulty button text"), difficulty: .easy, selectedDifficulty: $selectedDifficulty)
                            DifficultyOptionButton(title: NSLocalizedString("medium", comment: "Medium difficulty button text"), difficulty: .medium, selectedDifficulty: $selectedDifficulty)
                            DifficultyOptionButton(title: NSLocalizedString("hard", comment: "Hard difficulty button text"), difficulty: .hard, selectedDifficulty: $selectedDifficulty)
                        }
                        .padding()
                    }

                    Spacer()

                    // New Buttons for Popovers
                  VStack(spacing: 0) {
                    HStack(spacing: 20) {
                          Button(action: {
                              showSettings.toggle()
                          }) {
                              Image(systemName: "gear")
                                  .font(.kreonCaption)
                                  .foregroundColor(.white)
                                  .frame(width: 50, height: 50)
                                  .padding(2)
                          }
                          .background(Image("smallBtnBackground").resizable().scaledToFit())
                          .sheet(isPresented: $showSettings) {
                              UnifiedSettingsView(musicVolume: $musicVolume, sfxVolume: $sfxVolume)
                          }

                          Spacer()

                          Button(NSLocalizedString("statistics", comment: "Statistics button text")) {
                              AudioManager.shared.playImmediateSFX("sfxButton")
                              gameVm.showStatistics = true
                          }
                          .font(horizontalSizeClass == .compact ? .kreonSubheadline : .kreonHeadline)
                          .foregroundStyle(.white)
                          .background(
                            Image("bigBtnBackground")
                              .resizable()
                              .scaledToFit()
                              .frame(width: 150, height: 50)
                          )
                          .padding(.trailing, horizontalSizeClass == .compact ? 20 : 24)
                        
                          
                      }
                    .padding(.horizontal, horizontalSizeClass == .compact ? 20 : 24)
                    // New Info Button
                    HStack {
                      Spacer()
                      Button(action: {
                          showingInfoSheet.toggle()
                      }) {
                          Image(systemName: "info.circle")
                              .font(.system(size: 20))
                              .foregroundColor(.white)
                      }
                      .sheet(isPresented: $showingInfoSheet) {
                          InfoSheetView()
                    }.padding(.horizontal, horizontalSizeClass == .compact ? 20 : 24)
                    }
                  }
                }

                // Blackout overlay
                Color.black
                    .opacity(blackoutOpacity)
                    .edgesIgnoringSafeArea(.all)
            }
            .navigationDestination(isPresented: $gameVm.isGameStarted) {
                StageView(gameVm: gameVm, db: db)
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
        .statusBarHidden()
    }
}

struct UnifiedSettingsView: View {
    @Binding var musicVolume: Double
    @Binding var sfxVolume: Double
    @AppStorage("selectedLanguage") private var selectedLanguage = "en" // Default to English
    private let languages = ["en": "English", "vi": "Vietnamese"]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Audio Settings")) {
                    VolumeSliderView(volume: $musicVolume, title: NSLocalizedString("music_volume", comment: "Music volume title"))
                        .onDisappear {
                            AudioManager.shared.setMusicVolume(to: musicVolume)
                        }
                    
                    VolumeSliderView(volume: $sfxVolume, title: NSLocalizedString("sfx_volume", comment: "SFX volume title"))
                        .onDisappear {
                            AudioManager.shared.setSFXVolume(to: sfxVolume)
                        }
                }
                
                Section(header: Text("Language Settings")) {
                    Picker("Language", selection: $selectedLanguage) {
                        ForEach(languages.keys.sorted(), id: \.self) { key in
                            Text(languages[key]!).tag(key)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedLanguage, perform: { value in
                        changeLanguage(to: value)
                    })
                }
            }
            .navigationTitle("Settings")
        }
    }

    private func changeLanguage(to languageCode: String) {
        UserDefaults.standard.setValue([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        // Restart the app to apply the new language setting.
        exit(0)
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
            AudioManager.shared.playImmediateSFX("sfxButton")
        }
        .background(
          Image("bigBtnBackground")
        )
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
            Text(NSLocalizedString("enter_your_name", comment: "Prompt to enter player name"))
                .font(.kreonTitle)
                .foregroundColor(.white)

          TextField(NSLocalizedString("name_placeholder", comment: "Name input placeholder"), text: $playerName, prompt: Text("Enter your name")               .foregroundStyle(.black))
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .font(.kreonCaption)

            HStack {
                Button(action: {
                    isPresented = false
                    AudioManager.shared.playImmediateSFX("sfxButton")
                }) {
                    Text(NSLocalizedString("cancel", comment: "Cancel button text"))
                        .foregroundColor(.white)
                        .font(.kreonHeadline)
                        .padding()
                        .background(
                          Image("bigBtnBackground")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 275, height: 200)
                        )
                        .cornerRadius(8)
                }

                Button(action: {
                    if !playerName.isEmpty {
                        onConfirm()
                    }
                    AudioManager.shared.playImmediateSFX("sfxButton")
                }) {
                    Text(NSLocalizedString("confirm", comment: "Confirm button text"))
                        .foregroundColor(.white)
                        .font(.kreonHeadline)
                        .padding()
                        .background(
                          Image("bigBtnBackground")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 275, height: 200)
                        )
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .frame(alignment: .center)
        .cornerRadius(12)
        .padding()
        .shadow(radius: 20)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct InfoSheetView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Title and Developer Information
                    VStack(alignment: .leading, spacing: 8) {
                        Text("s3978452 - Duong Tran Minh Hoang")
                            .font(.kreonTitle2)
                            .padding(.bottom, 8)
                        
                        Text("Slay The 11th is a mobile card game that takes the inspiration from one of the most popular games called Slay The Spire. In Slay The 11th, the player will have to fight their way from stage 1 to stage 11 and defeat the mighty boss at the end. During the gameplay, the player will find themselves with a unique set of cards, each to their own usage; some of which are to be unlocked when they reach a certain stage of the game. Moreover, player will find buffs as a reward of their choice in order to defeat the monsters in the dungeon.")
                            .font(.kreonBody)
                    }
                    .padding(.bottom, 16)

                    // Basic Information
                    Text("Here are some basic information on how to play the game, or you can play the tutorial:")
                        .font(.kreonHeadline)
                        .padding(.bottom, 8)
                    
                    // Card Variety Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("## Card Variety")
                            .font(.kreonHeadline)
                            .padding(.bottom, 8)
                        
                        Group {
                            Text("1. **Attack card**: Select this card to deal damage equals to the value on the card.")
                            Text("2. **Defend card**: Select this card to shield yourself equals to the value on the card.")
                            Text("3. **Draw card**: When used, this card will draw additional cards equals to the value on the card.")
                            Text("4. **Poison card**: A debuff card, use this card to apply poison on to the enemy.")
                            Text("5. **Silent card**: A debuff card, use this card to apply silent on to the enemy.")
                            Text("6. **Heal card**: Obtained from reward, use this card to heal yourself equals to the value on the card.")
                            Text("7. **XPoison card**: Obtained from reward, use this card on the enemy to double the effect of poison they are inflicted with.")
                        }
                        .font(.kreonBody)
                    }
                    .padding(.bottom, 16)

                    // Debuff Mechanics Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("## Debuff Mechanics")
                            .font(.kreonHeadline)
                            .padding(.bottom, 8)
                        
                        Group {
                            Text("1. **Poison**: When poisoned, the enemies will take damage equals to the current duration they are being inflicted with at the end of player turn. For example, during the player turn, enemy A has 4 stacks of poison, hence taking 4 damage at the end of the player turn. Poison decrements its duration after each player enemy turn. Using the same example, after taking 4 damage, if the enemy is still alive, they will take 3 damage at the end of the next player turn unless they die. Poison will decrement until there is no stack left.")
                            
                            Text("2. **Silent**: Silent shares the same decrementing effect with Poison. Enemy with a silent effect will not perform any action until the effect ceases.")
                        }
                        .font(.kreonBody)
                    }
                    .padding(.bottom, 16)

                    // Enemy Intentions Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("## Enemy Intentions")
                            .font(.kreonHeadline)
                            .padding(.bottom, 8)
                        
                        Text("Similar to Slay The Spire, enemies in Slay The 11th show their intention during the player turn. The intention varies depending on the situation; they can attack, buff, or cleanse debuff from themselves or their allies. Enemies who are silent will still show intention with a muted icon.")
                            .font(.kreonBody)
                    }
                    .padding(.bottom, 16)

                    // Difficulty Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("## Difficulty")
                            .font(.kreonHeadline)
                            .padding(.bottom, 8)
                        
                        Text("Slay The 11th has 3 difficulties: easy, medium, and hard. The more difficult the game, the tougher the enemies. In hard mode only, debuffs against enemies become less effective. Poison now decrements for 2 instead of 1 like in easy and medium. Silent will be removed after one enemy turn despite how many stacks they have.")
                            .font(.kreonBody)
                    }
                    .padding(.bottom, 16)

                    // How to Play Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("## How to play")
                            .font(.kreonHeadline)
                            .padding(.bottom, 8)
                        
                        Text("-- Player can play the tutorial to understand the interactions.")
                            .font(.kreonBody)
                            .padding(.bottom, 8)
                        
                        Group {
                            Text("1. Select the card, tap either on the player or the enemy to apply the card effects.")
                            Text("2. Depending on the type of card, there will be an effect. For negative effects like poison or silent, it can't be applied to the player.")
                            Text("3. Try to utilize all the cards in one turn. After the player decides or the player runs out of card, they can end their turn to draw new cards.")
                            Text("4. After ending the player turn, enemies will execute whatever intention they were displaying during the last player turn.")
                        }
                        .font(.kreonBody)
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Extra Info")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismissView()
                    }
                }
            }
        }
    }
    
    // Function to dismiss the view properly depending on iOS version
    private func dismissView() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
}

#Preview {
    MainMenuView(gameVm: .constant(GameViewModel()))
}


