//
//  WeatherCollection.swift
//  WeatherData
//
//  Created by Alexander Heinrich on 16/08/16.
//  Copyright © 2016 Sn0wfreeze Development UG. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherCollection {
    static let sharedCollection = WeatherCollection()
    
    var locationName : String!
    var location : CLLocationCoordinate2D!
    
    var maxTemp : Float = 0.0
    var minTemp : Float = 0.0
    var maxSun : Float = 0.0
    var minRain : Float = 0.0
    var maxRain : Float = 0.0
    var maxAf : Int = 0
    
    var data : [WeatherData]?
    
    init() {
        locationName = "Not set"
        location = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        data = nil
    }

    func update(weatherString : String) {
        let newlineChars = NSCharacterSet.newlineCharacterSet()
        let lines = weatherString.utf16.split { newlineChars.characterIsMember($0) }.flatMap(String.init)
        
        self.data = [WeatherData]()
        
        for (idx, line) in lines.enumerate()  {
            switch idx {
            case 0:
                //Name of city 
                self.locationName = line
            case 1:
                //Location
                
                //First guard to create substring wich starts at the correct location coordinates
                guard
                let subline = line.rangeOfString("Lat ")?.startIndex
                    else {break}
                let line =  line.substringFromIndex(subline)
                
                //Second guard to find the correct location coordinates
                guard
                let latStart = line.rangeOfString("Lat "),
                let lonStart = line.rangeOfString("Lon "),
                let commaStart = line.rangeOfString(",")
                    else {break}
                
                //Find the locations data
                let latRange = latStart.endIndex ..< lonStart.startIndex.advancedBy(-1)
                let lat = Double(line.substringWithRange(latRange))!
                let lonRange = lonStart.endIndex ..< lonStart.startIndex.advancedBy(lonStart.startIndex.distanceTo(commaStart.startIndex))
                let lon = Double(line.substringWithRange(lonRange))!
                self.location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                
            case let x where x >= 7:
                self.parseDataLine(line)
            default:
                break
            }
        }
    
    }
    
    func parseDataLine(weatherLine: String){
        var weatherArray = weatherLine.componentsSeparatedByString(" ")
        weatherArray = weatherArray.filter({$0 != ""})
        
        
        
        //Use a for loop to prevent a crash when data is lost 
        let weatherData = WeatherData()
        
        for (idx, entry) in weatherArray.enumerate() {
            //Replace all characters that are not usable for presenting the data
            let unsusableChars = NSCharacterSet(charactersInString: "*#")
            let entry  =  entry.stringByTrimmingCharactersInSet(unsusableChars)
            switch idx {
            case 0:
                //Year
                guard let year = Int(entry)
                    else{break}
                weatherData.setYear(year)
            case 1:
                //Month
                guard let month = Int(entry)
                    else{break}
                weatherData.setMonth(month)
            case 2:
                //Minimum Temp
                guard let degrees = Float(entry)
                    else{break}
                if degrees < minTemp {
                    self.minTemp = degrees
                }
                weatherData.maxTemperature = degrees
            case 3:
                //Maximum Temp
                guard let degrees = Float(entry)
                    else{break}
                if maxTemp < degrees {
                    self.maxTemp = degrees
                }
                weatherData.minTemperature = degrees
            case 4:
                //AF days
                guard let af = Int(entry)
                    else{break}
                if self.maxAf < af {
                    self.maxAf = af
                }
                weatherData.afDays = af
            case 5:
                //Rain in mm
                guard let rain = Float(entry)
                    else{break}
                if self.maxRain < rain {
                    self.maxRain = rain
                }
                weatherData.rain = rain
            case 6:
                //Sun hours
                guard let sun = Float(entry)
                    else{break}
                if self.maxSun < sun {
                    self.maxSun = sun
                }
                weatherData.sunHours = sun
                
            default:
                break
            }
        }
        
        self.data?.append(weatherData)
    }
    
    //MARK: - Max min Data 
    
    func maxSunForMonth(month: Int) -> Float{
        if let filter = data?.filter({$0.month == month}) {
            let maxValue =  filter.sort({$0.sunHours > $1.sunHours})
            if let hrs =  maxValue.first?.sunHours {
                return hrs
            }
        }
        return 0
    }
    
    
    
}
