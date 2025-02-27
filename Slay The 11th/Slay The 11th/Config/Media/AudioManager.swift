/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2024B
  Assessment: Assignment 2
  Author: Duong Tran Minh Hoang
  ID: 3978452
  Created  date: 24/08/2024
  Last modified: 04/09/2024
  Acknowledgement: None
*/

import Foundation
import AVFoundation

class AudioManager: NSObject {
    static let shared = AudioManager()
    
    private var activePlayers: [AVAudioPlayer] = []
    private var globalMusicVolume: Float = 0.4
    private var globalSFXVolume: Float = 0.6
    private var sfxQueue: [String] = []  // Queue to store SFX filenames
    private var isPlayingSFX = false  // Flag to check if SFX is currently playing

    private override init() {}

    // Play background music, allowing different file extensions
    func playBackgroundMusic(_ filename: String) {
        // Supported extensions
        let supportedExtensions = ["mp3", "wav", "m4a", "aac"]

        var fileURL: URL? = nil
        for ext in supportedExtensions {
            if let url = Bundle.main.url(forResource: filename, withExtension: ext) {
                fileURL = url
                break
            }
        }

        guard let url = fileURL else {
            print("Could not find file: \(filename) with any of the supported extensions.")
            return
        }
        print("Playing background music from path: \(url.path)")

        do {
            let musicPlayer = try AVAudioPlayer(contentsOf: url)
            musicPlayer.numberOfLoops = -1 // Loop indefinitely
            musicPlayer.volume = globalMusicVolume
            musicPlayer.delegate = self
            musicPlayer.play()

            activePlayers.append(musicPlayer)
        } catch {
            print("Could not create audio player for background music: \(error)")
        }
    }
    
    // Play SFX immediately, stopping any currently playing SFX
    func playImmediateSFX(_ filename: String) {
        // Stop any currently playing SFX
        stopCurrentSFX()

        // Play new SFX
        playSFX(filename)
    }

    // Queue SFX to play in sequence, without interrupting currently playing SFX
    func queueSFX(_ filename: String) {
        // Add new SFX to the queue
        sfxQueue.append(filename)
        if !isPlayingSFX {
            playNextSFX()
        }
    }
    
    // Play SFX from the filename
    private func playSFX(_ filename: String) {
        // Supported extensions
        let supportedExtensions = ["mp3", "wav", "m4a", "aac"]

        var fileURL: URL? = nil
        for ext in supportedExtensions {
            if let url = Bundle.main.url(forResource: filename, withExtension: ext) {
                fileURL = url
                break
            }
        }

        guard let url = fileURL else {
            print("Could not find file: \(filename) with any of the supported extensions.")
            return
        }

        do {
            let sfxPlayer = try AVAudioPlayer(contentsOf: url)
            sfxPlayer.volume = globalSFXVolume
            sfxPlayer.delegate = self
            sfxPlayer.play()
            activePlayers.append(sfxPlayer)
            isPlayingSFX = true
        } catch {
            print("Could not create audio player for SFX: \(error)")
            playNextSFX()  // Continue with next SFX in case of an error
        }
    }
  
    func clearSFXQueue() {
        sfxQueue.removeAll()
        isPlayingSFX = false
    }
  
    // Stop any currently playing SFX
    private func stopCurrentSFX() {
        activePlayers.forEach { player in
            if player.numberOfLoops == 0 { // Assuming SFX has numberOfLoops set to 0 for SFX
                player.stop()
            }
        }
        activePlayers.removeAll { $0.numberOfLoops == 0 }
        isPlayingSFX = false
    }

    // Play the next SFX in the queue
    private func playNextSFX() {
        guard !sfxQueue.isEmpty else {
            isPlayingSFX = false
            return
        }

        let filename = sfxQueue.removeFirst()
        playSFX(filename)
    }

    // Stop all background music
    func stopBackgroundMusic() {
        activePlayers.forEach { player in
            if player.numberOfLoops == -1 { // Check if it is looping music
                player.stop()
            }
        }
        activePlayers.removeAll { $0.numberOfLoops == -1 }
    }
    
    // Change background music to a new file
    func changeBackgroundMusic(to filename: String) {
        stopBackgroundMusic()
        playBackgroundMusic(filename)
    }

    // Set global volume for background music
    func setMusicVolume(to volume: Double) {
        globalMusicVolume = Float(volume)
        activePlayers.forEach { player in
            if player.numberOfLoops == -1 { // Apply only to looping music players
                player.volume = globalMusicVolume
            }
        }
    }

    // Set global volume for SFX
    func setSFXVolume(to volume: Double) {
        globalSFXVolume = Float(volume)
        activePlayers.forEach { player in
            if player.numberOfLoops != -1 { // Apply only to SFX players
                player.volume = globalSFXVolume
            }
        }
    }
}

// Extend AudioManager to conform to AVAudioPlayerDelegate
extension AudioManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Remove finished player from the activePlayers array
        if let index = activePlayers.firstIndex(of: player) {
            activePlayers.remove(at: index)
        }
        playNextSFX()  // Continue playing next SFX when the current one finishes
    }
}
