//
//  AudioManager.swift
//  Slay The 11th
//
//  Created by Duong Tran Minh Hoang on 24/08/2024.
//

import Foundation
import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    
    var backgroundMusicPlayer: AVAudioPlayer?
    var sfxPlayer: AVAudioPlayer?
    
    // Global volume levels
    private var globalMusicVolume: Float = 0.5
    private var globalSFXVolume: Float = 0.5

    private init() {}

    func playBackgroundMusic(_ filename: String) {
        guard let url = Bundle.main.url(forResource: "\(filename)", withExtension: "mp3") else {
            print("Could not find file: \(filename)")
            return
        }
        print("Playing background music from path: \(url.path)")

        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.numberOfLoops = -1 // Loop indefinitely
            backgroundMusicPlayer?.volume = globalMusicVolume // Apply global volume
            backgroundMusicPlayer?.play()
        } catch {
            print("Could not create audio player: \(error)")
        }
    }
    
    func playSFX(_ filename: String) {
        guard let url = Bundle.main.url(forResource: "\(filename)", withExtension: "mp3") else {
            print("Could not find file: \(filename)")
            return
        }

        do {
            sfxPlayer = try AVAudioPlayer(contentsOf: url)
            sfxPlayer?.volume = globalSFXVolume // Apply global volume
            sfxPlayer?.play()
        } catch {
            print("Could not create audio player: \(error)")
        }
    }

    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
    }
    
    func changeBackgroundMusic(to filename: String) {
        stopBackgroundMusic()
        playBackgroundMusic(filename)
    }

    // Set global volume for background music and apply it to any active player
    func setMusicVolume(to volume: Double) {
        globalMusicVolume = Float(volume)
        backgroundMusicPlayer?.volume = globalMusicVolume
    }

    // Set global volume for SFX and apply it to any active player
    func setSFXVolume(to volume: Double) {
        globalSFXVolume = Float(volume)
        sfxPlayer?.volume = globalSFXVolume
    }
}

