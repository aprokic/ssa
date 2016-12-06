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
    
    var locations: [String] = []
    var states: [String] = []
    var cities: [String] = []
    
    // these variables hold GPS location data
    var curCity: String?
    var curStateProvinceRegion: String?
    var curCountry: String?
    var curLocationFound = false // true only if GPS successfully returns location
    let manager = CLLocationManager()

    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    
    @IBOutlet weak var download_button: UIButton!
    
    @IBOutlet weak var alert_message: UILabel!
    
    @IBAction func download(_ sender: Any) {
        if locationField.text == "" || stateField.text == "" || cityField.text == "" {
            return;
        } else {
            // force-quit GPS location update if here
            manager.stopUpdatingLocation()
            
            self.alert_message.text = "Downloading..."
            self.alert_message.textColor = UIColor.blue
            let db = SQLiteDB.sharedInstance;
            
            var locInfo = LocationInfo()
            var descInfo = DescriptionInfo()
            var tagInfo = TagInfo()
            
            // Remove existing entries in local DB
            db.query(sql: "DELETE FROM tags")
            db.query(sql: "DELETE FROM descriptions")
            db.query(sql: "DELETE FROM locations")
            
            // Query database for info
            var mySQLDB = RemoteMySQL()
            // Query for Locations and Insert into local DB
            mySQLDB.getLocations(country: locationField.text, state: stateField.text, city: cityField.text,
                               callback: { locResultStruct in
                locInfo = locResultStruct
                
                // Populate locations
                var locSQLStr = "INSERT INTO locations (lid, street, city, state_province_region, zip, country) VALUES "
                var firstLocCol = locInfo.locations[0]
                locSQLStr.append("('" + firstLocCol.lid! + "'")
                locSQLStr.append(", '\(firstLocCol.street!)'")
                locSQLStr.append(", '\(firstLocCol.city!)'")
                locSQLStr.append(", '\(firstLocCol.state_province_region!)'")
                locSQLStr.append(", '\(firstLocCol.zip!)'")
                locSQLStr.append(", '\(firstLocCol.country!)')")
    
                for i in 1 ..< locInfo.locations.count {
                    locSQLStr.append(",('" + locInfo.locations[i].lid! + "'")
                    locSQLStr.append(",'" + locInfo.locations[i].street! + "'")
                    locSQLStr.append(",'" + locInfo.locations[i].city! + "'")
                    locSQLStr.append(",'" + locInfo.locations[i].state_province_region! + "'")
                    locSQLStr.append(",'" + locInfo.locations[i].zip! + "'")
                    locSQLStr.append(",'" + locInfo.locations[i].country! + "')")
                }
                
                db.query(sql: locSQLStr)
                
                // Query for Descriptions and insert into local DB
                mySQLDB.getDescriptions(country: self.locationField.text, state: self.stateField.text, city: self.cityField.text,
                                        callback: { descResultStruct in
                    descInfo = descResultStruct

                    // Populate Descriptions
                    var descSQLStr = "INSERT INTO descriptions (lid, did, description, price) VALUES "
                    if(descInfo.size == -1) {
                        DispatchQueue.main.async(execute: {
                            self.alert_message.text = "Failed!"
                            self.alert_message.textColor = UIColor.red
                        })
                        return
                    }
                    else if (descInfo.size == 0){
                        DispatchQueue.main.async(execute: {
                            self.alert_message.text = "Nothing Found."
                            self.alert_message.textColor = UIColor.red
                        })
                        return
                    }
                    
                    var firstDescCol = descInfo.descriptions[0]
                    descSQLStr.append("('" + firstDescCol.lid! + "'")
                    descSQLStr.append(", '\(firstDescCol.did!)'")
                    descSQLStr.append(", '\(firstDescCol.description!)'")
                    if (firstDescCol.price == nil) {
                        descSQLStr.append(",NULL)")
                    } else {
                        descSQLStr.append(",'\(firstDescCol.price!)')")
                    }
                    
                    for i in 1 ..< descInfo.descriptions.count {
                        descSQLStr.append(",('" + descInfo.descriptions[i].lid! + "'")
                        descSQLStr.append(",'" + descInfo.descriptions[i].did! + "'")
                        descSQLStr.append(",'" + descInfo.descriptions[i].description! + "'")
                        if (descInfo.descriptions[i].price == nil) {
                            descSQLStr.append(",NULL)")
                        } else {
                            descSQLStr.append(",'\(descInfo.descriptions[i].price!)')")
                        }
                    }
                    
                    db.query(sql: descSQLStr)
                    
                    // Query for tags and insert into local DB
                    mySQLDB.getTags(country: self.locationField.text, state: self.stateField.text, city: self.cityField.text,
                                    callback: { tagResultStruct in
                        tagInfo = tagResultStruct
                    
                        // Populate tags
                        var tagSQLStr = "INSERT INTO tags (type, location, description, reserved) VALUES "
                        if(tagInfo.size == -1) {
                            DispatchQueue.main.async(execute: {
                                self.alert_message.text = "Failed!"
                                self.alert_message.textColor = UIColor.red
                            })
                            return
                        }
                        else if (tagInfo.size == 0){
                            DispatchQueue.main.async(execute: {
                                self.alert_message.text = "Nothing Found."
                                self.alert_message.textColor = UIColor.red
                            })
                            return
                        }
                        
                        var firstTagCol = tagInfo.tags[0]
                        tagSQLStr.append("('" + firstTagCol.type! + "'")
                        tagSQLStr.append(", '\(firstTagCol.location!)'")
                        tagSQLStr.append(", '\(firstTagCol.description!)'")
                        tagSQLStr.append(", '\(firstTagCol.reserved!)')")
                        
                        for i in 1 ..< tagInfo.tags.count {
                            tagSQLStr.append(",('" + tagInfo.tags[i].type! + "'")
                            tagSQLStr.append(",'" + tagInfo.tags[i].location! + "'")
                            tagSQLStr.append(",'" + tagInfo.tags[i].description! + "'")
                            tagSQLStr.append(",'" + tagInfo.tags[i].reserved! + "')")
                        }
                        
                        db.query(sql: tagSQLStr)
                        
                        DispatchQueue.main.async(execute: {
                            self.alert_message.text = "Success!"
                            self.alert_message.textColor = UIColor.green
                        })
                        
                    }) // tags
                }) // descriptions
            }) // locations
            
        }
        
    }
    
    var locationPicker = UIPickerView()
    let locationManager = CLLocationManager()
    
    var selectedRow_location = 0;
    var selectedRow_state = -1;
    var selectedRow_city = -1;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        download_button.isHidden = true
        
        // setup GPS location manager
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
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
        
        // query for all valid countries
        let mySQLDB = RemoteMySQL()
        mySQLDB.getCountries(callback: { resultStruct in
            if (resultStruct.size == -1) {
                print("error found")
            } else {
                self.locationField.fadeIn()
                self.locations = resultStruct.countries
            }
        })
    }
    
    // handle updates to user's location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = (placemarks?[0])! as CLPlacemark
                self.displayLocationInfo(placemark: pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    // display location info
    func displayLocationInfo(placemark: CLPlacemark?) {
        if (placemark != nil) {
            //stop updating location to save battery life
            manager.stopUpdatingLocation()
            self.curCity = placemark?.locality
            self.curStateProvinceRegion = placemark?.administrativeArea
            self.curCountry = placemark?.country
            self.curLocationFound = true
        }
    }
    
    // handle errors in user's location retrieval
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
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
            var mySQLDB = RemoteMySQL()
            var fade_city = false
            mySQLDB.getStates(country: locationField.text, callback: { resultStruct in
                self.states = resultStruct.states
            })
            self.stateField.fadeIn()
        }
        else if(cityField.text == "" && stateField.text != ""){
            var mySQLDB = RemoteMySQL()
            mySQLDB.getCities(country: locationField.text, state: stateField.text, callback: { resultStruct in
                self.cities = resultStruct.cities
            })
            self.cityField.fadeIn()
        }
        
        self.locationPicker.selectRow(0, inComponent: 0, animated: false)
        
        if(locationField.text != "" && stateField.text != "" && cityField.text != ""){
            download_button.isHidden = false
        }
        else {
            download_button.isHidden = true
        }
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
