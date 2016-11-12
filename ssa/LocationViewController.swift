//
//  LocationViewController.swift
//  ssa
//
//  Created by Muhammad Jahangir on 10/29/16.
//  Copyright © 2016 Alexander Prokic. All rights reserved.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CLLocationManagerDelegate {

    var locations: [String] = ["U.S.A", "Canada", "Mexico", "Brazil", "Argentina"]
    var states: [String] = ["Michigan", "Illinois", "Washington"]
    var cities: [String] = ["Detroit", "Ann Arbor", "Seattle"]
    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    
    
    var locationPicker = UIPickerView()
    let locationManager = CLLocationManager()
    
    var selectedRow_location = 0;
    var selectedRow_state = 0;
    var selectedRow_city = 0;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationPicker.delegate = self
        locationPicker.dataSource = self
        locationPicker.showsSelectionIndicator = true
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(LocationViewController.donePicker(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(LocationViewController.cancelPicker(_:)))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LocationViewController.donePicker(_:)))
        view.addGestureRecognizer(tap)
        
        self.locationField.inputView = locationPicker
        self.locationField.inputAccessoryView = toolBar
        
        self.stateField.inputView = locationPicker
        self.stateField.inputAccessoryView = toolBar
        
        self.cityField.inputView = locationPicker
        self.cityField.inputAccessoryView = toolBar
        
        locationPicker.backgroundColor = UIColor(white: 1, alpha: 1)
        
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if locationField.isFirstResponder{
            return locations.count
        }
        else if stateField.isFirstResponder {
            return states.count
        }
        else if cityField.isFirstResponder {
            return cities.count
        }
        else {
         return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if locationField.isFirstResponder{
            return locations[row]
        }
        else if stateField.isFirstResponder {
            return states[row]
        }
        else if cityField.isFirstResponder {
            return cities[row]
        }
        else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if locationField.isFirstResponder{
            selectedRow_location = row
        }
        else if stateField.isFirstResponder {
            selectedRow_state = row
        }
        else if cityField.isFirstResponder {
            selectedRow_city = row
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var titleData = ""
        
        if locationField.isFirstResponder{
            titleData = locations[row]
        }
        else if stateField.isFirstResponder {
            titleData = states[row]
        }
        else if cityField.isFirstResponder {
            titleData = cities[row]
        }
        
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.blue])
        return myTitle
   }
   
    func donePicker(_ sender: UIBarButtonItem){
        self.view.endEditing(true)
        
        locationField.text = locations[selectedRow_location]
        stateField.text = states[selectedRow_state]
        cityField.text = cities[selectedRow_city]
    }
    
    func cancelPicker(_ sender: UIBarButtonItem){
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
