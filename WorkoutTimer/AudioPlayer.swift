//
//  AudioPlayer.swift
//  WorkoutTimer
//
//  Created by 山崎宏哉 on 2021/07/11.
//

import Foundation
import AVFoundation

class AudioPlayer: ObservableObject {
  var player = AVAudioPlayer()

  init(name: String, volume: Float = 1) {
    if let url = Bundle.main.url(forResource: name, withExtension:  "m4a") {
      print("success audio file : \(url)")
      do {
       player = try AVAudioPlayer(contentsOf: url)
        player.prepareToPlay()
        player.setVolume(volume, fadeDuration: 0)
      } catch {
        print("Erro getting audio \(error.localizedDescription)")
      }
    }
    print("failed audio file : \(name)")
  }

  func play() {
    player.play()
  }

  func stop() {
    player.setVolume(0, fadeDuration: 0)
    player.stop()
  }
}
