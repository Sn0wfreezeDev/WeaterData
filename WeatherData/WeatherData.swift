//
//  WeatherData.swift
//  WeatherData
//
//  Created by Alexander Heinrich on 16/08/16.
//  Copyright © 2016 Sn0wfreeze Development UG. All rights reserved.
//

import UIKit

class WeatherData: NSObject {
    var date : NSDate!
    var maxTemperature : Float! = 0.0
    var minTemperature : Float! = 0.0
    var afDays : Int!  = 0
    var rain : Float! = 0.0
    var sunHours : Float = 0.0
    
    var year : Int?
    var month : Int?
    
    func setYear(year : Int) {
        self.year = year
        
        if let m = self.month {
            self.setDate(m, year: year)
        }
    }
    
    func setMonth(month : Int) {
        self.month  = month
        
        if let year = self.year {
            self.setDate(month, year: year)
        }
    }
    
    private func setDate(month : Int, year: Int) {
        let dateComps = NSDateComponents()
        dateComps.year = year
        dateComps.month = month
        let calendar =  NSCalendar.currentCalendar()
        calendar.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        self.date = calendar.dateFromComponents(dateComps)
    }
   
}
