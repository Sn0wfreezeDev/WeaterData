
//
//  Helper.swift
//  WeatherData
//
//  Created by Alexander Heinrich on 19/08/16.
//  Copyright © 2016 Sn0wfreeze Development UG. All rights reserved.
//

import UIKit

class Helper: NSObject {
    
    static func nameForDataMode(type : ViewController.DataMode) -> String {
        switch type {
        case .MaxTemperature:
            return NSLocalizedString("Maximum Temperature", comment: "")
        case .MinTemperature:
            return NSLocalizedString("Minimum Temperature", comment: "")
        case .Rain:
            return NSLocalizedString("Rain in mm", comment: "")
        case .Af:
            return NSLocalizedString("Air frost in days", comment: "")
        case .Sun:
            return NSLocalizedString("Sun hours", comment: "")
        default:
            break
        }

        return ""
    }
    
    
    static func monthForNumber(num : Int) -> String{
        switch num {
        case 0:
            return NSLocalizedString("January", comment: "")
        case 1:
            return NSLocalizedString("February", comment: "")
        case 2:
            return NSLocalizedString("March", comment: "")
        case 3:
            return NSLocalizedString("April", comment: "")
        case 4:
            return NSLocalizedString("May", comment: "")
        case 5:
            return NSLocalizedString("June", comment: "")
        case 6:
            return NSLocalizedString("July", comment: "")
        case 7:
            return NSLocalizedString("August", comment: "")
        case 8:
            return NSLocalizedString("September", comment: "")
        case 9:
            return NSLocalizedString("October", comment: "")
        case 10:
            return NSLocalizedString("November", comment: "")
        case 11:
            return NSLocalizedString("December", comment: "")
        default:
            break
        }
        
        return ""
    }

}
