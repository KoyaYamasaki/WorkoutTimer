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
  var session = AVAudioSession.sharedInstance()
  
  init(name: String, volume: Float = 1) {
    do {
      try session.setCategory(.ambient)
      try session.setActive(true)
    } catch {
      print("failed to initialize AVAudioSession")
    }
    
    if let url = Bundle.main.url(forResource: name, withExtension:  "m4a") {
      print("success audio file : \(url)")
      do {
        player = try AVAudioPlayer(contentsOf: url)
        player.prepareToPlay()
        player.setVolume(volume, fadeDuration: 0)
      } catch {
        print("Erro getting audio \(error.localizedDescription)")
      }
    } else {
      print("failed audio file : \(name)")
    }
  }
  
  func play() {
    player.play()
  }
  
  func stop() {
    print("player stop")
    player.setVolume(0, fadeDuration: 0)
    player.stop()
  }
}
