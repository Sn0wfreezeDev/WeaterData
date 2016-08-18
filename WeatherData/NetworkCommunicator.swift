//
//  NetworkCommunicator.swift
//  WeatherData
//
//  Created by Alexander Heinrich on 16/08/16.
//  Copyright © 2016 Sn0wfreeze Development UG. All rights reserved.
//

import UIKit
import Alamofire

class NetworkCommunicator {
    
    static func loadWeatherData(completed:(success : Bool) -> ()) {
        let url = "http://www.metoffice.gov.uk/pub/data/weather/uk/climate/stationdata/bradforddata.txt"
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        Alamofire.request(.GET, url).validate().responseString { (response) in
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false 
            });
            
            if let responseString = response.result.value {
                //Successfully loaded
                //Load data to weather collection 
                WeatherCollection.sharedCollection.update(responseString)
                completed(success: true)
            }else {
                //Network Connection Error
                completed(success: false)
            }
        }
    }

}