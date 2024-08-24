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
}
