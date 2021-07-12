//
//  ExerciseSetting.swift
//  WorkoutTimer
//
//  Created by 山崎宏哉 on 2021/07/12.
//

import Foundation

class ExerciseSetting: ObservableObject {
  @Published var exerciseTime: Int = 30
  @Published var restTime: Int = 10
  @Published var howManySets: Int = 5
}
