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

    var locations = ["Kroger", "Meijer", "Walmart", "CVS", "UGOS"]
    
    @IBOutlet weak var locationField: UITextField!
    var locationPicker = UIPickerView()
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationPicker.delegate = self
        locationPicker.dataSource = self
        self.locationField.inputView = locationPicker;
        locationPicker.backgroundColor = UIColor(white: 1, alpha: 1)
        
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return locations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locations[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        locationField.text = locations[row]
        self.view.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = locations[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.blue])
        return myTitle
   }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
