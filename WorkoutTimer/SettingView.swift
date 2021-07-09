//
//  SettingView.swift
//  CircularProgress
//
//  Created by 山崎宏哉 on 2021/07/08.
//

import SwiftUI

struct ExerciseSetting {
  var exerciseTime: Int
  var restTime: Int
  var howManySets: Int
}

struct SettingView: View {
  @State private var exerciseSetting: ExerciseSetting?
  @State private var exerciseTime: Int = 30
  @State private var restTime: Int = 10
  @State private var howManySets: Int = 5
  
  var body: some View {
    if exerciseSetting == nil {
      ZStack {
        Color.backgroundColor
          .edgesIgnoringSafeArea(.all)
        
        Form {
          
          Section {
            Picker(selection: $exerciseTime, label: labelView(title: "Exercise Time", subtitle: "\(exerciseTime) sec")) {
              ForEach(5...100, id: \.self) { index in
                if index % 5 == 0 {
                  Text("\(index) sec")
                }
              }
            }
            .pickerStyle(MenuPickerStyle())
          }
          
          Section {
            Picker(selection: $restTime, label: labelView(title: "Rest Time", subtitle: "\(restTime) sec")) {
              ForEach(5...30, id: \.self) { index in
                if index % 5 == 0 {
                  Text("\(index) sec")
                }
              }
            }
            .pickerStyle(MenuPickerStyle())
          }
          
          Section {
            Picker(selection: $howManySets, label: labelView(title: "How many sets", subtitle: "\(howManySets) sets")) {
              ForEach(1...10, id: \.self) { index in
                Text("\(index) set")
              }
            }
            .pickerStyle(MenuPickerStyle())
          }
        }
        .colorInvert()
        
        Button("Start") {
          exerciseSetting = ExerciseSetting(exerciseTime: exerciseTime, restTime: restTime, howManySets: howManySets)
        }
        .font(.title)
        .padding()
        .border(Color.blue, width: 4.0)
        .cornerRadius(10.0)
      }
      
    } else {
      TimerView(exerciseSetting: $exerciseSetting)
    }
  }
}

struct labelView: View {
  let title: String
  let subtitle: String
  
  var body: some View {
    HStack {
      Text(title)
      Spacer()
      Text(subtitle)
    }
    
  }
}
struct SettingView_Previews: PreviewProvider {
  static var previews: some View {
    SettingView()
  }
}
