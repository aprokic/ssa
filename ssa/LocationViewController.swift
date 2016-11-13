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
    var states: [String] = []
    var cities: [String] = []
    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    
    var locationPicker = UIPickerView()
    let locationManager = CLLocationManager()
    
    var selectedRow_location = 0;
    var selectedRow_state = -1;
    var selectedRow_city = -1;
    
    
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
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LocationViewController.cancelPicker(_:)))
        view.addGestureRecognizer(tap)
        
        self.locationField.inputView = locationPicker
        self.locationField.inputAccessoryView = toolBar
        
        self.stateField.inputView = locationPicker
        self.stateField.inputAccessoryView = toolBar
        self.stateField.fadeOut()
        
        self.cityField.inputView = locationPicker
        self.cityField.inputAccessoryView = toolBar
        self.cityField.fadeOut()
        
        locationPicker.backgroundColor = UIColor(white: 1, alpha: 1)
        
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        if locationField.isFirstResponder{
            selectedRow_location = 0
            return locations.count
        }
        else if stateField.isFirstResponder {
            selectedRow_state = 0
            return states.count
        }
        else if cityField.isFirstResponder {
            selectedRow_city = 0
            return cities.count
        }
        return 0
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
        
        if(selectedRow_location < locations.count) {
            let opt = locations[selectedRow_location]
            if(self.locationField.text != "" && opt != self.locationField.text){
                optionChanged(textfield: 1)
                selectedRow_state = -1
            }
            self.locationField.text = opt
        }
        if(selectedRow_state >= 0 && selectedRow_state < states.count){
            let opt = states[selectedRow_state]
            if(self.stateField.text != "" && opt != self.stateField.text){
                optionChanged(textfield: 2)
                selectedRow_city = -1
            }
            self.stateField.text = opt
        }
        if(selectedRow_city >= 0 && selectedRow_city < cities.count){
            self.cityField.text = cities[selectedRow_city]
        }
        
        
        if(stateField.text == "" && locationField.text != ""){
            states.append("Michigan")
            states.append("Ottawa")
            self.stateField.fadeIn()
        }
        else if(cityField.text == "" && stateField.text != ""){
            cities.append("Detroit")
            self.cityField.fadeIn()
        }
        
        self.locationPicker.selectRow(0, inComponent: 0, animated: false)
    }
    
    func optionChanged(textfield: Int){
        if(textfield == 1){
            self.cityField.text = ""
            cities.removeAll()
            self.cityField.fadeOut()
            
            self.stateField.text = ""
            states.removeAll()
        }
        else if(textfield == 2){
            self.cityField.text = ""
            cities.removeAll()
        }
        
    }
    
    func cancelPicker(_ sender: UIBarButtonItem){
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
