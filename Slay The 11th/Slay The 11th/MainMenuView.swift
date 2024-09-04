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
                                        gameVm.mode = .regular
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
            AudioManager.shared.clearSFXQueue()
            AudioManager.shared.playBackgroundMusic("mainMenu")
        }
        .onDisappear {
            AudioManager.shared.clearSFXQueue()
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
                        Text(NSLocalizedString("developer_info", comment: "Developer Information"))
                            .font(.kreonTitle2)
                            .padding(.bottom, 8)
                        
                        Text(NSLocalizedString("game_description", comment: "Game Description"))
                            .font(.kreonBody)
                    }
                    .padding(.bottom, 16)

                    // Basic Information
                    Text(NSLocalizedString("basic_info", comment: "Basic Information"))
                        .font(.kreonHeadline)
                        .padding(.bottom, 8)
                    
                    // Card Variety Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text(NSLocalizedString("card_variety_title", comment: "Card Variety Title"))
                            .font(.kreonHeadline)
                            .padding(.bottom, 8)
                        
                        Group {
                            Text(NSLocalizedString("card_variety_1", comment: "Description of Attack card"))
                            Text(NSLocalizedString("card_variety_2", comment: "Description of Defend card"))
                            Text(NSLocalizedString("card_variety_3", comment: "Description of Draw card"))
                            Text(NSLocalizedString("card_variety_4", comment: "Description of Poison card"))
                            Text(NSLocalizedString("card_variety_5", comment: "Description of Silent card"))
                            Text(NSLocalizedString("card_variety_6", comment: "Description of Heal card"))
                            Text(NSLocalizedString("card_variety_7", comment: "Description of XPoison card"))
                        }
                        .font(.kreonBody)
                    }
                    .padding(.bottom, 16)

                    // Debuff Mechanics Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text(NSLocalizedString("debuff_mechanics_title", comment: "Debuff Mechanics Title"))
                            .font(.kreonHeadline)
                            .padding(.bottom, 8)
                        
                        Group {
                            Text(NSLocalizedString("debuff_mechanics_1", comment: "Poison debuff explanation"))
                            Text(NSLocalizedString("debuff_mechanics_2", comment: "Silent debuff explanation"))
                        }
                        .font(.kreonBody)
                    }
                    .padding(.bottom, 16)

                    // Enemy Intentions Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text(NSLocalizedString("enemy_intentions_title", comment: "Enemy Intentions Title"))
                            .font(.kreonHeadline)
                            .padding(.bottom, 8)
                        
                        Text(NSLocalizedString("enemy_intentions_description", comment: "Description of enemy intentions"))
                            .font(.kreonBody)
                    }
                    .padding(.bottom, 16)

                    // Difficulty Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text(NSLocalizedString("difficulty_title", comment: "Difficulty Title"))
                            .font(.kreonHeadline)
                            .padding(.bottom, 8)
                        
                        Text(NSLocalizedString("difficulty_description", comment: "Description of game difficulties"))
                            .font(.kreonBody)
                    }
                    .padding(.bottom, 16)

                    // How to Play Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text(NSLocalizedString("how_to_play_title", comment: "How to Play Title"))
                            .font(.kreonHeadline)
                            .padding(.bottom, 8)
                        
                        Text(NSLocalizedString("how_to_play_intro", comment: "Introductory text for how to play"))
                            .font(.kreonBody)
                            .padding(.bottom, 8)
                        
                        Group {
                            Text(NSLocalizedString("how_to_play_1", comment: "First instruction on how to play"))
                            Text(NSLocalizedString("how_to_play_2", comment: "Second instruction on how to play"))
                            Text(NSLocalizedString("how_to_play_3", comment: "Third instruction on how to play"))
                            Text(NSLocalizedString("how_to_play_4", comment: "Fourth instruction on how to play"))
                        }
                        .font(.kreonBody)
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle(NSLocalizedString("extra_info_title", comment: "Navigation title for extra information"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("close", comment: "Close button")) {
                        dismissView()
                    }
                }
            }
        }
    }
    
    private func dismissView() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
}


#Preview {
    MainMenuView(gameVm: .constant(GameViewModel()))
}


