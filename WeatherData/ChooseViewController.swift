//
//  ChooseViewController.swift
//  WeatherData
//
//  Created by Alexander Heinrich on 18/08/16.
//  Copyright © 2016 Sn0wfreeze Development UG. All rights reserved.
//

import UIKit

class ChooseViewController: UITableViewController, PickerCellDelegate  {
    
    var showTypePicker = false
    var showMonthPicker = false
    var selectedType :  ViewController.DataMode?
    var selectedMonth : Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = NSLocalizedString("Choose Data", comment: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Data Source 
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            //Choose Data Type section
            if indexPath.row == 0 {
                let cell =  tableView.dequeueReusableCellWithIdentifier("BasicCell", forIndexPath: indexPath)
                cell.textLabel?.text = NSLocalizedString("Choose the data type to compare", comment: "")
                cell.accessoryType = .DisclosureIndicator
                
                if let type = self.selectedType {
                    cell.detailTextLabel?.text = Helper.nameForDataMode(type)
                }else {
                    cell.detailTextLabel?.text = ""
                }
                
                return cell
            }else if let cell = tableView.dequeueReusableCellWithIdentifier("PickerCell", forIndexPath: indexPath) as? PickerCell
                where indexPath.row == 1 {
                cell.pickerMode = .Type
                cell.selectionStyle = .None
                cell.picker.dataSource = cell
                cell.picker.delegate = cell
                
                cell.delegate = self
                
                return cell
            }
            
        }
        //Choose Month to compare section
        if indexPath.row == 0 {
            let cell =  tableView.dequeueReusableCellWithIdentifier("BasicCell", forIndexPath: indexPath)
            cell.textLabel?.text = NSLocalizedString("Choose a month to compare", comment: "")
            cell.accessoryType = .DisclosureIndicator
            
            if let month = self.selectedMonth {
                cell.detailTextLabel?.text = Helper.monthForNumber(month - 1)
            }else {
                cell.detailTextLabel?.text = ""
            }
            
            return cell
        }else if let cell = tableView.dequeueReusableCellWithIdentifier("PickerCell", forIndexPath: indexPath) as? PickerCell
            where indexPath.row == 1 {
            cell.pickerMode = .Month
            cell.selectionStyle = .None
            cell.picker.dataSource = cell
            cell.picker.delegate = cell
            cell.delegate = self
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 1 {
            if indexPath.section == 0 {
                if showTypePicker {
                    return 216.0
                }else {
                    return 0.0
                }
                
            }else if indexPath.section == 1{
                if showMonthPicker {
                    return 216.0
                }else {
                    return 0
                }
            }
        }
        
        return 44.0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Type"
        }else if section == 1 {
            return "Month"
        }
        
        return nil
    }
    
    //MARK: - Delegate 
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            if indexPath.section == 0 {
                self.showTypePicker = !self.showTypePicker
                tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
            }else if indexPath.section == 1 {
                self.showMonthPicker = !self.showMonthPicker
                tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Automatic)
            }
        }
    }
    
    func didSelectEntry(atRow: Int, withMode mode: PickerCell.PickerMode, inCell cell: PickerCell) {
        if mode == .Month {
            self.showMonthPicker = false
            self.selectedMonth = atRow + 1
            tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Automatic)
        }else if mode == .Type {
            self.showTypePicker = false
            
            switch atRow {
            case 0:
                self.selectedType = .MaxTemperature
            case 1:
                self.selectedType = .MinTemperature
            case 2:
                self.selectedType = .Rain
            case 3:
                self.selectedType = .Af
            case 4:
                self.selectedType = .Sun
            default:
                break
            }
            
            tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
        }
        
        if self.selectedMonth != nil && self.selectedType != nil {
            let nextBtn = UIBarButtonItem(title: NSLocalizedString("Next", comment: ""), style: .Plain, target: self, action: #selector(showData))
            self.navigationItem.rightBarButtonItem = nextBtn
        }
        
    }
    
    
    func showData() {
        self.performSegueWithIdentifier("showDataView", sender: nil)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let vc = segue.destinationViewController as? ViewController {
            vc.month = self.selectedMonth
            if let type  = self.selectedType {
                vc.dataMode = type
            }
            
        }
        
    }
    
    
 

}

protocol PickerCellDelegate {
    func didSelectEntry(atRow: Int, withMode mode: PickerCell.PickerMode, inCell cell: PickerCell)
}

class PickerCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    enum PickerMode {
        case Type
        case Month
    }
    
    @IBOutlet weak var picker: UIPickerView!
    var delegate : PickerCellDelegate?
    
    var pickerMode : PickerMode = .Type
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.pickerMode == .Type {
            return 5
        }
        return 12
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.pickerMode == .Type {
            switch row {
            case 0:
                return NSLocalizedString("Maximum Temperature", comment: "")
            case 1:
                return NSLocalizedString("Minimum Temperature", comment: "")
            case 2:
                return NSLocalizedString("Rain in mm", comment: "")
            case 3:
                return NSLocalizedString("Air frost in days", comment: "")
            case 4:
                return NSLocalizedString("Sun hours", comment: "")
            default:
                break
            }
        }else if self.pickerMode == .Month {
            return Helper.monthForNumber(row)
        }
               return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.delegate?.didSelectEntry(row, withMode: self.pickerMode, inCell: self)
    }
    
    
}