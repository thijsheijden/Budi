//
//  DailyProgressClass.swift
//  Budi
//
//  Created by Thijs van der Heijden on 3/18/18.
//  Copyright © 2018 Thijs van der Heijden. All rights reserved.
//

import Foundation

public class DailyProgress {
    
    var numberOfFocusRounds: Int
    var dayNumber: Int
    
    init(numberOfFocusRounds: Int, dayNumber: Int) {
        self.numberOfFocusRounds = numberOfFocusRounds
        self.dayNumber = dayNumber
    }
    
}

let todaysDate: Date = Date()
let calendar = Calendar.current

let month = calendar.component(.month, from: todaysDate)
let day = calendar.component(.day, from: todaysDate)

var dailyProgressArray = [DailyProgress]()

let day18_3 = DailyProgress(numberOfFocusRounds: 10, dayNumber: day)
let day19_3 = DailyProgress(numberOfFocusRounds: 10, dayNumber: 19)
let day20_3 = DailyProgress(numberOfFocusRounds: 10, dayNumber: 20)

public func addDailyProgressToArray() {
    dailyProgressArray.append(day18_3)
    dailyProgressArray.append(day19_3)
    dailyProgressArray.append(day20_3)
}

