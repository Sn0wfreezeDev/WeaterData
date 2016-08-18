//
//  ViewController.swift
//  WeatherData
//
//  Created by Alexander Heinrich on 16/08/16.
//  Copyright © 2016 Sn0wfreeze Development UG. All rights reserved.
//

import UIKit
import Charts



class ViewController: UIViewController, UITableViewDataSource {
    enum DataMode {
        case MinTemperature
        case MaxTemperature
        case Rain
        case Sun
        case Af
        case All
    }
    
    @IBOutlet weak var chart: LineChartView!
    @IBOutlet weak var tableView: UITableView?
    
    var month : Int? //Month whichs data should be shown 
    var year : Int? // For possible year comparison
    var dataMode : DataMode = .MaxTemperature

    var currentData : [WeatherData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.updateWeatherData(self)
        
    }
    
    
    @IBAction func updateWeatherData(sender: AnyObject) {
        NetworkCommunicator.loadWeatherData { (success) in
            if success {
                //Display weatherData
                self.displayWeatherData()
            }else {
                //An error occured
                //TODO: Present Error
            }
        }
    }
    
    func displayWeatherData() {
        let weather = WeatherCollection.sharedCollection
        self.navigationItem.title = weather.locationName
        
        self.chart.dragEnabled = true
        self.chart.pinchZoomEnabled = true
        self.chart.drawGridBackgroundEnabled = false
        
        self.chart.animate(xAxisDuration: 2.0)
        
        let yAxis = self.chart.leftAxis
        self.yAxisValue(weather, yAxis: yAxis)
        yAxis.drawZeroLineEnabled = true
        
        self.chart.rightAxis.enabled = false
        
        self.chart.legend.form = .Line
        
        self.charDataForCurrentMode()
    
        
        self.chart.data?.notifyDataChanged()
        self.chart.notifyDataSetChanged()
        
        self.tableView?.reloadData()
        
    }
    
    func yAxisValue(weather : WeatherCollection, yAxis: ChartYAxis) {
        
        switch self.dataMode {
        case .MinTemperature:
            yAxis.axisMaxValue = Double(weather.maxTemp + 5)
            yAxis.axisMinValue = Double(weather.minTemp - 5)

        case .MaxTemperature:
            yAxis.axisMaxValue = Double(weather.maxTemp + 5)
            yAxis.axisMinValue = Double(weather.minTemp - 5)

        case .Rain:
            yAxis.axisMaxValue = Double(weather.maxRain + 5)
            yAxis.axisMinValue = Double(0.0)

        case .Sun:
            if let month = self.month {
                yAxis.axisMaxValue = Double(weather.maxSunForMonth(month) + 5)
            }
            
            yAxis.axisMinValue = Double( 0.0 )

        case .Af: 
            yAxis.axisMaxValue = Double(weather.maxAf)
            yAxis.axisMinValue = Double(0.0)
        default:
            yAxis.axisMaxValue = Double(50.0)
            yAxis.axisMinValue = Double(-10.0)

        }
        
    }
    
    func charDataForCurrentMode() {
        let weather = WeatherCollection.sharedCollection
        guard let data = weather.data
            else {return}
        
        var chartData : LineChartDataSet!
        var xValues  : [String]!
        var entries =  [ChartDataEntry]()
        var fillColors = [CGColor]()
        
        switch self.dataMode {
        case .MaxTemperature:
            let monthData = data.filter({$0.month == month})
            self.currentData = monthData
            let yValues  =  monthData.map({ $0.maxTemperature })
            xValues  = monthData.map({ "\($0.month!)-\($0.year!)" })
            
            for (idx, _) in xValues.enumerate() {
                let yValue = Double(yValues[idx])
                entries.append(ChartDataEntry(value: yValue, xIndex: idx))
            }
            
            chartData = LineChartDataSet(yVals: entries, label: "Maximum Temperature")
            fillColors = [
                UIColor ( red: 0.9869, green: 0.1829, blue: 0.2316, alpha: 0.65 ).CGColor,
                UIColor ( red: 0.7016, green: 0.0, blue: 0.0, alpha: 1.0 ).CGColor
            ]
            
        case .MinTemperature:
            let monthData = data.filter({$0.month == month})
            self.currentData = monthData
            let yValues  =  monthData.map({ $0.minTemperature })
            xValues  = monthData.map({ "\($0.month!)-\($0.year!)" })
            
            for (idx, _) in xValues.enumerate() {
                let yValue = Double(yValues[idx])
                entries.append(ChartDataEntry(value: yValue, xIndex: idx))
            }
            
            chartData = LineChartDataSet(yVals: entries, label: "Minimum Temperature")
            
            fillColors = [
                UIColor ( red: 0.1019, green: 0.8367, blue: 0.8948, alpha: 1.0 ).CGColor,
                UIColor ( red: 0.0, green: 0.9722, blue: 1.0, alpha: 0.43 ).CGColor
            ]
            
        case .Rain:
            let monthData = data.filter({$0.month == month})
            self.currentData = monthData
            let yValues  =  monthData.map({ $0.rain })
            xValues  = monthData.map({ "\($0.month!).\($0.year!)" })
            
            for (idx, _) in xValues.enumerate() {
                let yValue = Double(yValues[idx])
                entries.append(ChartDataEntry(value: yValue, xIndex: idx))
            }
            
            chartData = LineChartDataSet(yVals: entries, label: "Rain in mm")
            
            fillColors = [
                UIColor ( red: 0.0, green: 0.2964, blue: 0.8684, alpha: 1.0 ).CGColor,
                UIColor ( red: 0.0, green: 0.315, blue: 0.999, alpha: 0.43 ).CGColor
            ]

            
        case .Af:
            let monthData = data.filter({$0.month == month})
            self.currentData = monthData
            let yValues  =  monthData.map({ $0.afDays})
            xValues  = monthData.map({ "\($0.month!).\($0.year!)" })
            
            for (idx, _) in xValues.enumerate() {
                let yValue = Double(yValues[idx])
                entries.append(ChartDataEntry(value: yValue, xIndex: idx))
            }
            
            chartData = LineChartDataSet(yVals: entries, label: "Af days")
            
            fillColors = [
                UIColor ( red: 0.0, green: 0.8684, blue: 0.0222, alpha: 1.0 ).CGColor,
                UIColor ( red: 0.0, green: 0.999, blue: 0.1384, alpha: 0.43 ).CGColor
            ]

            
        case .Sun:
            let monthData = data.filter({$0.month == month})
            self.currentData = monthData
            let yValues  =  monthData.map({ $0.sunHours })
            xValues  = monthData.map({ "\($0.month!).\($0.year!)" })
            
            for (idx, _) in xValues.enumerate() {
                let yValue = Double(yValues[idx])
                entries.append(ChartDataEntry(value: yValue, xIndex: idx))
            }
            
            chartData = LineChartDataSet(yVals: entries, label: "Sun hours")
            
            fillColors = [
                UIColor ( red: 0.8684, green: 0.8105, blue: 0.0, alpha: 1.0 ).CGColor,
                UIColor ( red: 0.999, green: 0.9401, blue: 0.0, alpha: 0.43 ).CGColor
            ]


        default:
            break
        }
        
        if let gradient = CGGradientCreateWithColors(nil, fillColors, nil) {
            chartData.fillAlpha = 1.0
            chartData.fill = ChartFill(linearGradient: gradient, angle: 90.0)
            chartData.drawFilledEnabled = true
        }
        
        
        chartData.circleColors = [UIColor.blackColor()]
        chartData.colors = [UIColor(CGColor: fillColors.first!)]
        chartData.lineWidth = 1.0
        chartData.circleRadius = 3.0
        chartData.drawCircleHoleEnabled = false
        chartData.mode = .CubicBezier
        
        
        
        self.chart.data = LineChartData(xVals: xValues, dataSets: [chartData])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let map = segue.destinationViewController as? MapVC {
            map.location = WeatherCollection.sharedCollection.location
        }
    }
    
    //MARK: - TableView 
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = currentData {
            return data.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = Helper.nameForDataMode(self.dataMode)
        return title
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath)
        guard let entry = self.currentData?[indexPath.row]
            else{return cell}
        if let m = entry.month,
            let y = entry.year {
            let dateText = Helper.monthForNumber(m) + " - \(y)"
            cell.detailTextLabel?.text = dateText
        }
        if let value = self.chart.data?.dataSets.first?.yValForXIndex(indexPath.row) {
            let valueText = "\(Double(round(1000*value)/1000))"
            cell.textLabel?.text = valueText
        }
        
        return cell
    }
    
    
}

