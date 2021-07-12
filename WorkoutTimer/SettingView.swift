//
//  SettingView.swift
//  CircularProgress
//
//  Created by 山崎宏哉 on 2021/07/08.
//

import SwiftUI

struct SettingView: View {
  @ObservedObject var exerciseSetting = ExerciseSetting()
  
  var body: some View {
    ZStack {
      Color.backgroundColor
        .edgesIgnoringSafeArea(.all)
      
      NavigationView {

        Form {

          Section {
            Picker(selection: $exerciseSetting.exerciseTime, label: labelView(title: "Exercise Time", subtitle: "\(exerciseSetting.exerciseTime) sec")) {
              ForEach(5...100, id: \.self) { index in
                if index % 5 == 0 {
                  Text("\(index) sec")
                }
              }
            }
            .pickerStyle(MenuPickerStyle())
          }
          
          Section {
            Picker(selection: $exerciseSetting.restTime, label: labelView(title: "Rest Time", subtitle: "\(exerciseSetting.restTime) sec")) {
              ForEach(5...30, id: \.self) { index in
                if index % 5 == 0 {
                  Text("\(index) sec")
                }
              }
            }
            .pickerStyle(MenuPickerStyle())
          }
          
          Section {
            Picker(selection: $exerciseSetting.howManySets, label: labelView(title: "How many sets", subtitle: "\(exerciseSetting.howManySets) sets")) {
              ForEach(1...10, id: \.self) { index in
                Text("\(index) set")
              }
            }
            .pickerStyle(MenuPickerStyle())
          }

          NavigationLink(
            destination:
              TimerView(exerciseSetting: exerciseSetting),
          label: {
            Text("START")
              .foregroundColor(.blue)
          })
          .font(.title2)
          .padding()
        }

        .navigationTitle("WorkoutTimer")
      } //: NavigationView
//      .colorInvert()
    } //: ZStack
  } //: Body
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
    SettingView(exerciseSetting: ExerciseSetting())
  }
}
