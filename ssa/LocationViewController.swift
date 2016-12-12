//
//  LocationViewController.swift
//  ssa
//
//  Created by Muhammad Jahangir on 10/29/16.
//  Copyright © 2016 Alexander Prokic. All rights reserved.
//

import UIKit
import CoreLocation
import Darwin
import AVFoundation

class LocationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CLLocationManagerDelegate {
    
    var countries: [String] = []
    var states: [String] = []
    var cities: [String] = []
    
    let synthesizer = AVSpeechSynthesizer()
    
    func speak(text: String){
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.volume = 2
        utterance.rate = 0.55
        
        try! AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        
        
        var session = AVAudioSession.sharedInstance()
        
        // Output Audio and Override Route
        try! session.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        synthesizer.speak(utterance)
        //allow time for phrase to finish asynchronously
        DispatchQueue.global().async {
            while (self.synthesizer.isSpeaking) {
                // do nothing while speaking
            }
            try! session.overrideOutputAudioPort(AVAudioSessionPortOverride.none)
        }
    }
    
    var statesDictionary = [ "AK" : "Alaska",
                              "AL" : "Alabama",
                              "AR" : "Arkansas",
                              "AS" : "American Samoa",
                              "AZ" : "Arizona",
                              "CA" : "California",
                              "CO" : "Colorado",
                              "CT" : "Connecticut",
                              "DC" : "District of Columbia",
                              "DE" : "Delaware",
                              "FL" : "Florida",
                              "GA" : "Georgia",
                              "GU" : "Guam",
                              "HI" : "Hawaii",
                              "IA" : "Iowa",
                              "ID" : "Idaho",
                              "IL" : "Illinois",
                              "IN" : "Indiana",
                              "KS" : "Kansas",
                              "KY" : "Kentucky",
                              "LA" : "Louisiana",
                              "MA" : "Massachusetts",
                              "MD" : "Maryland",
                              "ME" : "Maine",
                              "MI" : "Michigan",
                              "MN" : "Minnesota",
                              "MO" : "Missouri",
                              "MS" : "Mississippi",
                              "MT" : "Montana",
                              "NC" : "North Carolina",
                              "ND" : "North Dakota",
                              "NE" : "Nebraska",
                              "NH" : "New Hampshire",
                              "NJ" : "New Jersey",
                              "NM" : "New Mexico",
                              "NV" : "Nevada",
                              "NY" : "New York",
                              "OH" : "Ohio",
                              "OK" : "Oklahoma",
                              "OR" : "Oregon",
                              "PA" : "Pennsylvania",
                              "PR" : "Puerto Rico",
                              "RI" : "Rhode Island",
                              "SC" : "South Carolina",
                              "SD" : "South Dakota",
                              "TN" : "Tennessee",
                              "TX" : "Texas",
                              "UT" : "Utah",
                              "VA" : "Virginia",
                              "VI" : "Virgin Islands",
                              "VT" : "Vermont",
                              "WA" : "Washington",
                              "WI" : "Wisconsin",
                              "WV" : "West Virginia",
                              "WY" : "Wyoming"]
    
    // these variables hold GPS location data
    var curCity: String?
    var curStateProvinceRegion: String?
    var curCountry: String?
    var curLocationFound = false // true only if GPS successfully returns location
    let manager = CLLocationManager()

    
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    
    @IBOutlet weak var download_button: UIButton!
    
    @IBOutlet weak var alert_message: UILabel!
    
    @IBAction func download(_ sender: Any) {
        if countryField.text == "" || stateField.text == "" || cityField.text == "" {
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
            
            // Remove tags from local DB for city to be updated
            db.query(sql:
            "DELETE " +
            "FROM tags t " +
            "WHERE t.location in " +
                "(SELECT t1.location " +
                "FROM tags t1 " +
                "JOIN locations l1 ON t1.location = l1.lid " +
                "WHERE l1.city = ? " +
                    "AND l1.state_province_region = ? " +
                    "AND l1.country = ?)", parameters:[cityField.text, stateField.text, countryField.text])
            
            // Remove descriptions from local DB for city to be updated
            db.query(sql:
            "DELETE " +
            "FROM descriptions d " +
            "WHERE d.lid in " +
                "(SELECT d1.lid " +
                "FROM descriptions d1 " +
                "JOIN locations l1 ON d1.lid = l1.lid " +
                "WHERE l1.city = ? " +
                    "AND l1.state_province_region = ? " +
                    "AND l1.country = ?)", parameters:[cityField.text, stateField.text, countryField.text])
            
            // Remove locations from local DB for city to be updated
            db.query(sql:
            "DELETE " +
            "FROM locations l " +
            "WHERE l.city = ?" +
                "AND l.state_province_region = ? " +
                "AND l.country = ?", parameters:[cityField.text, stateField.text, countryField.text])
            
            // Query database for info
            var mySQLDB = RemoteMySQL()
            // Query for Locations and Insert into local DB
            mySQLDB.getLocations(country: countryField.text, state: stateField.text, city: cityField.text,
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
                mySQLDB.getDescriptions(country: self.countryField.text, state: self.stateField.text, city: self.cityField.text,
                                        callback: { descResultStruct in
                    descInfo = descResultStruct

                    // Populate Descriptions
                    var descSQLStr = "INSERT INTO descriptions (lid, did, description, price) VALUES "
                    if(descInfo.size == -1) {
                        DispatchQueue.main.async(execute: {
                            self.alert_message.text = "Failed!"
                            self.speak(text: "failed")
                            self.alert_message.textColor = UIColor.red
                        })
                        return
                    }
                    else if (descInfo.size == 0){
                        DispatchQueue.main.async(execute: {
                            self.alert_message.text = "Nothing Found."
                            self.speak(text: "nothing found")
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
                    mySQLDB.getTags(country: self.countryField.text, state: self.stateField.text, city: self.cityField.text,
                                    callback: { tagResultStruct in
                        tagInfo = tagResultStruct
                    
                        // Populate tags
                        var tagSQLStr = "INSERT INTO tags (type, location, description, reserved) VALUES "
                        if(tagInfo.size == -1) {
                            DispatchQueue.main.async(execute: {
                                self.alert_message.text = "Failed!"
                                self.speak(text: "download failed")
                                self.alert_message.textColor = UIColor.red
                            })
                            return
                        }
                        else if (tagInfo.size == 0){
                            DispatchQueue.main.async(execute: {
                                self.alert_message.text = "Nothing Found."
                                self.speak(text: "nothing found")
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
                            self.speak(text: "download success")
                            self.alert_message.textColor = UIColor.green
                        })
                        
                    }) // tags
                }) // descriptions
            }) // locations
            
        }
        
    }
    
    var countryPicker = UIPickerView()
    var statePicker = UIPickerView()
    var cityPicker = UIPickerView()
    
    let locationManager = CLLocationManager()
    
    var country_is_selected = 0;
    var state_is_selected = -1;
    var city_is_selected = -1;
    
    var already_called = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        speak(text: "download screen")
        
        already_called = false
        download_button.isHidden = true
        
        // setup GPS location manager
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        countryPicker.delegate = self
        countryPicker.dataSource = self
        countryPicker.showsSelectionIndicator = true
        countryPicker.tag = 0
        
        statePicker.delegate = self
        statePicker.dataSource = self
        statePicker.showsSelectionIndicator = true
        statePicker.tag = 1
        
        cityPicker.delegate = self
        cityPicker.dataSource = self
        cityPicker.showsSelectionIndicator = true
        cityPicker.tag = 2
        
        let toolBar1 = UIToolbar()
        toolBar1.barStyle = UIBarStyle.default
        toolBar1.isTranslucent = true
        toolBar1.tintColor = UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1)
        toolBar1.sizeToFit()
        
        let toolBar2 = UIToolbar()
        toolBar2.barStyle = UIBarStyle.default
        toolBar2.isTranslucent = true
        toolBar2.tintColor = UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1)
        toolBar2.sizeToFit()
        
        let toolBar3 = UIToolbar()
        toolBar3.barStyle = UIBarStyle.default
        toolBar3.isTranslucent = true
        toolBar3.tintColor = UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1)
        toolBar3.sizeToFit()
        
        let doneButton_country = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(LocationViewController.donePicker_country(_:)))
        let doneButton_state = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(LocationViewController.donePicker_state(_:)))
        let doneButton_city = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(LocationViewController.donePicker_city(_:)))
        
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let cancelButton_country = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(LocationViewController.cancelPicker(_:)))
        let cancelButton_state = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(LocationViewController.cancelPicker(_:)))
        let cancelButton_city = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(LocationViewController.cancelPicker(_:)))
        
        toolBar1.isUserInteractionEnabled = true
        toolBar2.isUserInteractionEnabled = true
        toolBar3.isUserInteractionEnabled = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LocationViewController.cancelPicker(_:)))
        view.addGestureRecognizer(tap)
        
        self.countryField.inputView = countryPicker
        toolBar1.setItems([cancelButton_country, spaceButton, doneButton_country], animated: true)
        self.countryField.inputAccessoryView = toolBar1
        
        self.stateField.inputView = statePicker
        toolBar2.setItems([cancelButton_state, spaceButton, doneButton_state], animated: true)
        self.stateField.inputAccessoryView = toolBar2
        self.stateField.fadeOut()
        
        self.cityField.inputView = cityPicker
        toolBar3.setItems([cancelButton_city, spaceButton, doneButton_city], animated: true)
        self.cityField.inputAccessoryView = toolBar3
        self.cityField.fadeOut()
        
        countryPicker.backgroundColor = UIColor(white: 1, alpha: 1)
        statePicker.backgroundColor = UIColor(white: 1, alpha: 1)
        cityPicker.backgroundColor = UIColor(white: 1, alpha: 1)
        
        // query for all valid countries
        let mySQLDB = RemoteMySQL()
        mySQLDB.getCountries(callback: { resultStruct in
            if (resultStruct.size == -1) {
                print("error found")
            } else {
                self.countryField.fadeIn()
                self.countries = resultStruct.countries
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
                manager.stopUpdatingLocation()
                //if (!self.already_called) {
                self.displayLocationInfo(placemark: pm)
                //}
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    // display location info
    func displayLocationInfo(placemark: CLPlacemark?) {
        
        
        if (placemark != nil) {
            //stop updating location to save battery life
            //manager.stopUpdatingLocation()
            self.curCity = placemark?.locality
            self.curStateProvinceRegion = placemark?.administrativeArea
            self.curCountry = placemark?.country
            
            if curLocationFound && !self.already_called {
                
                self.already_called = true
                
                let mySQLDB = RemoteMySQL()
                mySQLDB.getCountries(callback: { resultStruct in
                    if (resultStruct.size == -1) {
                        print("error found")
                    } else {
                        self.countryField.fadeIn()
                        self.countries = resultStruct.countries
                    }
                })
                
                if countries.contains(self.curCountry!) {
                    
                    self.country_is_selected = countries.index(of: self.curCountry!)!
                    donePicker_country(nil)
                    
                    usleep(useconds_t(700000))
                    self.countryPicker.selectRow(country_is_selected, inComponent: 0, animated: false)
                    
                    if (statesDictionary[self.curStateProvinceRegion!] != nil){
                        self.curStateProvinceRegion = statesDictionary[self.curStateProvinceRegion!]
                    }
                    
                    if states.contains(self.curStateProvinceRegion!) {
                        self.state_is_selected = states.index(of: self.curStateProvinceRegion!)!
                        donePicker_state(nil)
                        
                        usleep(useconds_t(500000))
                        self.statePicker.selectRow(state_is_selected, inComponent: 0, animated: false)
                        
                        if cities.contains(self.curCity!) {
                            self.city_is_selected = cities.index(of: self.curCity!)!
                            donePicker_city(nil)
                            self.cityPicker.selectRow(city_is_selected, inComponent: 0, animated: false)
                        }
            
                    }
                }
                
            }
            
            // set flag to true only if all necessary info is found
            if (placemark?.locality != nil && placemark?.administrativeArea != nil && placemark?.country != nil) {
                self.curLocationFound = true
            }
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
        
        self.alert_message.text = ""
        
        if pickerView.tag == 0 {
            return countries.count
        }
        else if pickerView.tag == 1 {
            return states.count
        }
        else if pickerView.tag == 2 {
            return cities.count
        }
        return 0
    }
    
    
    // places the data into the picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 0 {
             speak(text: "Country Wheel -- " +  countries[country_is_selected])
            return countries[row]
        }
        else if pickerView.tag == 1 {
            speak(text: "State Wheel -- " + states[state_is_selected])
            return states[row]
        }
        else if pickerView.tag == 2 {
            speak(text: "City Wheel -- " + cities[city_is_selected])
            return cities[row]
        }
        else {
            return ""
        }
    }
    
    // displays it in the label
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 0 {
            speak(text: countries[row])
            country_is_selected = row
        }
        else if pickerView.tag == 1 {
            speak(text: states[row])
            state_is_selected = row
            
        }
        else if pickerView.tag == 2 {
            speak(text: cities[row])
            city_is_selected = row
        }
    }

    
    func donePicker_country(_ sender: AnyObject? ){
        self.view.endEditing(true)
        
        if country_is_selected >= 0 && countries.count > 0 {
            self.countryField.text = countries[country_is_selected]
            speak(text: countries[country_is_selected] + " is selected")
            
            var mySQLDB = RemoteMySQL()
            mySQLDB.getStates(country: countryField.text, callback: { resultStruct in
                self.states = resultStruct.states
            })
            
            state_is_selected = 0
            city_is_selected = -1
            
            cityField.fadeOut()
            download_button.isHidden = true
            
            self.statePicker.reloadAllComponents()
            self.stateField.text = ""
            self.cityPicker.reloadAllComponents()
            self.cityField.text = ""
            
            self.stateField.fadeIn()
        }
        
        
    }
    
    func donePicker_state(_ sender: AnyObject? ){
        self.view.endEditing(true)
        
        if state_is_selected >= 0 && states.count > 0 {
            self.stateField.text = states[state_is_selected]
            speak(text: states[state_is_selected] + " is selected")
            
            var mySQLDB = RemoteMySQL()
            mySQLDB.getCities(country: countryField.text, state: stateField.text, callback: { resultStruct in
                self.cities = resultStruct.cities
            })
            
            city_is_selected = 0
            
            download_button.isHidden = true
            
            self.cityPicker.reloadAllComponents()
            self.cityField.text = ""
            
            self.cityField.fadeIn()
        }
    }
    
    func donePicker_city(_ sender: AnyObject? ){
        self.view.endEditing(true)
        
        if city_is_selected >= 0 && cities.count > 0 {
            self.cityField.text = cities[city_is_selected]
            speak(text: cities[city_is_selected] + " is selected -- " + "press the download button at the bottom")
        }
        
        if(self.countryField.text != "" && self.stateField.text != "" && self.cityField.text != ""){
            download_button.isHidden = false
        }
        else {
            download_button.isHidden = true
        }
    }
   
    func cancelPicker(_ sender: UIBarButtonItem){
        speak(text: "cancelled")
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
