//
//  CircularProgressView.swift
//  CircularProgress
//
//  Created by 山崎宏哉 on 2021/07/08.
//

import SwiftUI
import AVFoundation

struct TimerView: View {
  @State private var startingCount = 3
  @State private var isStarted = false

  @State private var remainingCount: Int = 0
  @State private var isExercising = false
  @State private var stateLabel = "START"
  @State private var setCount: Int = 0

  @ObservedObject var countSound = AudioPlayer(name: "Count")
  @ObservedObject var completionSound = AudioPlayer(name: "Completion")
  @ObservedObject var finishSound = AudioPlayer(name: "Finish")
  
  @ObservedObject var exerciseSetting: ExerciseSetting
  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  
  var body: some View {
    ZStack {
      Color.backgroundColor
        .edgesIgnoringSafeArea(.all)
      
      VStack {
        Spacer()
        Text("Set count: \(setCount) / \(exerciseSetting.howManySets)")
          .font(.system(size: 25))
          .fontWeight(.heavy)
          .foregroundColor(.white)
        Text(stateLabel)
          .font(.system(size: 45))
          .fontWeight(.heavy)
          .foregroundColor(.white)
        
        
        Spacer()
        ZStack {
          Pulsation()
          Track()
          Label(percentage: CGFloat(remainingCount))
          OutLine(percentage: CGFloat(remainingCount), multipleBy: multipleValue())
        }
        Spacer()
//        HStack(spacing: 80) {
//          Button(action: {
//            timer.upstream.connect()
//          }) {
//            Image(systemName: "play.circle.fill").resizable()
//              .frame(width: 65, height: 65)
//              .aspectRatio(contentMode: .fit)
//              .foregroundColor(.white)
//          }
//          
//          Button(action: {
//            timer.upstream.connect().cancel()
//          }) {
//            Image(systemName: "pause.circle.fill").resizable()
//              .frame(width: 65, height: 65)
//              .aspectRatio(contentMode: .fit)
//              .foregroundColor(.white)
//          }
//        }
      }
    }
    .onReceive(timer) { _ in
      if !isStarted {
        fireStartingCount()
      } else {
        workoutCountDown()
      }
    }
    .onDisappear(perform: {
      timer.upstream.connect().cancel()
      countSound.stop()
      completionSound.stop()
      finishSound.stop()
    })
  }
  
  func fireStartingCount() {
    fireSoundEffect(count: startingCount)
    if startingCount > 0 {
      stateLabel = "\(startingCount)"
      startingCount -= 1
    } else if startingCount == 0 {
      setCount += 1
      switchExerciseAndRest()
      isStarted = true
    }
  }
  
  func workoutCountDown() {
    remainingCount -= 1
    if remainingCount == 0 {
      if finishExerciseIfNeeded() {
        return
      }
      
      switchExerciseAndRest()
      
      if isExercising {
        setCount += 1
      }
    }
    fireSoundEffect(count: remainingCount)
  }
  
  func multipleValue() -> CGFloat {
    var divideHundred: CGFloat = 0.0
    if isExercising {
      divideHundred = 100.0 / CGFloat(exerciseSetting.exerciseTime)
    } else {
      divideHundred = 100.0 / CGFloat(exerciseSetting.restTime)
    }
    return divideHundred * 0.01
  }
  
  func switchExerciseAndRest() {
    isExercising.toggle()
    
    if isExercising {
      remainingCount = exerciseSetting.exerciseTime
      stateLabel = "START"
    } else {
      remainingCount = exerciseSetting.restTime
      stateLabel = "REST"
    }
  }
  
  func finishExerciseIfNeeded() -> Bool {
    if !isExercising && setCount == exerciseSetting.howManySets {
      remainingCount = 0
      stateLabel = "Finish!"
      finishSound.play()
      timer.upstream.connect().cancel()
      return true
    }
    return false
  }
  
  func fireSoundEffect(count: Int) {
    if count <= 3 && count != 0 {
      countSound.play()
    } else if count == 0 {
      completionSound.play()
    }
  }
}

struct Label: View {
  var percentage: CGFloat = 0
  var body: some View {
    ZStack {
      Text(String(format: "%.0f", percentage))
        .font(.system(size: 65))
        .fontWeight(.heavy)
        .foregroundColor(.white)
    }
  }
}

struct OutLine: View {
  var percentage: CGFloat = 0.0
  var multipleBy: CGFloat = 0.0
  var colors: [Color] = [Color.outlineColor]
  
  var body: some View {
    ZStack {
      Circle()
        .fill(Color.clear)
        .frame(width: 250, height: 250)
        .overlay(
          Circle()
            .trim(from: 0, to: percentage * multipleBy)
            .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
            .fill(AngularGradient(gradient: .init(colors: colors), center: .center, startAngle: .zero, endAngle: .init(degrees: 360)))
        )
        .animation(.spring(response: 0.5, dampingFraction: 1.0, blendDuration: 1.0))
    }
  }
}

struct Track: View {
  var colors: [Color] = [Color.trackColor]
  var body: some View {
    ZStack {
      Circle()
        .fill(Color.backgroundColor)
        .frame(width: 250, height: 250)
        .overlay(
          Circle()
            .stroke(style: StrokeStyle(lineWidth: 20))
            .fill(AngularGradient(gradient: .init(colors: colors), center: .center))
        )
    }
  }
}

struct Pulsation: View {
  @State private var pulsate = false
  var colors: [Color] = [Color.pulsatingColor]
  var body: some View {
    ZStack {
      Circle()
        .fill(Color.pulsatingColor)
        .frame(width: 245, height: 245)
        .scaleEffect(pulsate ? 1.3 : 1.1)
        .animation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true))
        .onAppear {
          self.pulsate.toggle()
        }
    }
  }
}

struct CircularProgressView_Previews: PreviewProvider {
  static var previews: some View {
    TimerView(exerciseSetting: ExerciseSetting())
  }
}
