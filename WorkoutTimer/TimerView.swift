//
//  CircularProgressView.swift
//  CircularProgress
//
//  Created by 山崎宏哉 on 2021/07/08.
//

import SwiftUI
import AVFoundation

struct TimerView: View {
  @State private var percentage: Int = 0
  @State private var isExercising = false
  @State private var readyToStart = "START"
  @State private var setCount: Int = 0
  
  @Binding var exerciseSetting: ExerciseSetting?
//  @State private var timer = Timer()

  var body: some View {
    ZStack {
      Color.backgroundColor
        .edgesIgnoringSafeArea(.all)
      
      VStack {
        Button("Back to Setting View") {
          exerciseSetting = nil
        }
        Spacer()
        Text("Set count: \(setCount) / \(exerciseSetting!.howManySets)")
          .font(.system(size: 25))
          .fontWeight(.heavy)
          .colorInvert()
        Text(readyToStart)
          .font(.system(size: 45))
          .fontWeight(.heavy)
          .colorInvert()
        
        Spacer()
        ZStack {
          Pulsation()
          Track()
          Label(percentage: CGFloat(percentage))
          OutLine(percentage: CGFloat(percentage), multipleBy: multipleValue())
        }
        Spacer()
        //        HStack(spacing: 80) {
        //          Button(action: {
        //            start()
        //          }) {
        //            Image(systemName: "play.circle.fill").resizable()
        //              .frame(width: 65, height: 65)
        //              .aspectRatio(contentMode: .fit)
        //              .foregroundColor(.white)
        //          }
        //
//        Button(action: {
//          timer.invalidate()
//        }) {
//          Image(systemName: "pause.circle.fill").resizable()
//            .frame(width: 65, height: 65)
//            .aspectRatio(contentMode: .fit)
//            .foregroundColor(.white)
//        }
      }
    }
    .onAppear(perform: {
      var timer = Timer()
      var count = 3
      timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//        timer.invalidate()
        fireSoundEffect(count: count+1)
        if count == 0 {
          timer.invalidate()
          setCount += 1
          switchExerciseAndRest()
          start()
        } else {
          readyToStart = "\(count)"
          count -= 1
        }
      }
    })
  }
  
  func multipleValue() -> CGFloat {
    var divideHundred: CGFloat = 0.0
    if isExercising {
      divideHundred = 100.0 / CGFloat(exerciseSetting!.exerciseTime)
    } else {
      divideHundred = 100.0 / CGFloat(exerciseSetting!.restTime)
    }
    return divideHundred * 0.01
  }

  func switchExerciseAndRest() {
    isExercising.toggle()

    if isExercising {
      percentage = exerciseSetting!.exerciseTime
      readyToStart = "START"
    } else {
      percentage = exerciseSetting!.restTime
      readyToStart = "REST"
    }
  }

  func finishExerciseIfNeeded() -> Bool {
    if !isExercising && setCount == exerciseSetting!.howManySets {
      percentage = 0
      readyToStart = "Finish!"
      return true
    }
    return false
  }

  func start() {
    var timer = Timer()
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
      _ in
      
      fireSoundEffect(count: percentage)

      if percentage == 1 {
        timer.invalidate()

        if finishExerciseIfNeeded() {
          return
        }

        switchExerciseAndRest()

        if isExercising {
          setCount += 1
        }

        start()
        return
      }
      
      percentage -= 1
    }
  }
  
  func fireSoundEffect(count: Int) {
    if count <= 4 && count != 1 {
      AudioServicesPlaySystemSound(1052)
    } else if count == 1 {
      AudioServicesPlaySystemSound(1001)
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
        .colorInvert()
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
    let exercise: ExerciseSetting = ExerciseSetting(exerciseTime: 10, restTime: 5, howManySets: 2)
      TimerView(exerciseSetting: .constant(exercise))
//    TimerView(exerciseSetting: .constant(nil))
  }
}
