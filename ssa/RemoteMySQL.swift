//
//  RemoteMySQL.swift
//  ssa
//
//  Created by Nils Strand on 11/7/2016.
//  Copyright © 2016 Alexander Prokic. All rights reserved.
//

import AVFoundation

struct CountryInfo {
    var countries = [String]()
    var size = -1
}

struct StateInfo {
    var states = [String]()
    var size = -1
}

struct CityInfo {
    var cities = [String]()
    var size = -1
}

struct LocationCols {
    var lid: String?
    var street: String?
    var city: String?
    var state_province_region: String?
    var zip: String?
    var country: String?
}

struct DescriptionCols {
    var lid: String?
    var did: String?
    var description: String?
    var price: Double?
}

struct TagCols {
    var type: String?
    var location: String?
    var description: String?
    var reserved: String?
}

struct LocationInfo {
    var locations = [LocationCols]()
    var size = -1
}

struct DescriptionInfo {
    var descriptions = [DescriptionCols]()
    var size = -1
}

struct TagInfo {
    var tags = [TagCols]()
    var size = -1
}

struct ScanCity {
    var country: String?
    var state_province_region: String?
    var city: String?
    var size = -1
}

class RemoteMySQL {
    let SERVER = "http://35.1.239.55"
    
    func getCountries(callback: @escaping (CountryInfo) -> ()) {
        let URL_LIST_COUNTRIES = SERVER + "/rfid/api/listcountries.php"
        let requestURL = NSURL(string: URL_LIST_COUNTRIES)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "GET"
        let getParameters = ""
        request.httpBody = getParameters.data(using: String.Encoding.utf8)
        
        var resultArr: CountryInfo = CountryInfo()
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            if error != nil {
                print("error is \(error)")
                resultArr.size = -1;
                callback(resultArr);
                return;
            }
            
            do {
                //converting resonse to NSDictionary
                let myJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                //parsing the json
                if let parseJSON = myJSON {
                    
                    //getting the json response
                    resultArr.size = parseJSON["size"] as! Int
                    for i in 0..<resultArr.size {
                        if let subArray = parseJSON[String(i)] as? [String: AnyObject]
                        {
                            resultArr.countries.append(subArray["country"] as! String);
                        }
                    }
                    
                    //returning the response
                    callback(resultArr);
                    
                }
            } catch {
                print(error)
                resultArr.size = -1;
                callback(resultArr);
                return;
            }
        }
        //executing the task
        task.resume()
    }
    
    func getStates(country: String?, callback: @escaping (StateInfo) -> ()) {
        // percent encode the parameter string
        let parameterString = "?country=" + country!
        let tempURL = SERVER + "/rfid/api/liststates.php\(parameterString)"
        let encodedURL = tempURL.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let requestURL = NSURL(string: encodedURL!)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "GET"
        
        var resultArr: StateInfo = StateInfo()
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error is \(error)")
                resultArr.size = -1;
                callback(resultArr)
                return;
            }
            
            do {
                //converting resonse to NSDictionary
                let myJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                //parsing the json
                if let parseJSON = myJSON {
                    
                    //getting the json response
                    resultArr.size = parseJSON["size"] as! Int
                    for i in 0..<resultArr.size {
                        if let subArray = parseJSON[String(i)] as? [String: AnyObject]
                        {
                            let resultState = subArray["state_province_region"] as! String
                            if resultState.isEmpty {
                                resultArr.states.append("Not Applicable");
                            }
                            else {
                                resultArr.states.append(resultState);                          
                            }
                        }
                    }
                    
                    //returning the response
                    callback(resultArr)
                    
                }
            } catch {
                resultArr.size = -1;
                callback(resultArr)
                return;
            }
        }
        //executing the task
        task.resume();
    }
    
    func getCities(country: String?, state: String?, callback: @escaping (CityInfo) -> ()) {
        var parameterString: String?
        if state == "Not Applicable" {
            parameterString = "?country=" + country! + "&state="
        }
        else {
            parameterString = "?country=" + country! + "&state=" + state!
        }
        let tempURL = SERVER + "/rfid/api/listcities.php\(parameterString!)"
        let encodedURL = tempURL.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let requestURL = NSURL(string: encodedURL!)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "GET"
        
        var resultArr: CityInfo = CityInfo()
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error is \(error)")
                resultArr.size = -1;
                callback(resultArr)
                return;
            }
            
            do {
                //converting resonse to NSDictionary
                let myJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                //parsing the json
                if let parseJSON = myJSON {
                    
                    //getting the json response
                    resultArr.size = parseJSON["size"] as! Int
                    for i in 0..<resultArr.size {
                        if let subArray = parseJSON[String(i)] as? [String: AnyObject]
                        {
                            resultArr.cities.append(subArray["city"] as! String);
                        }
                    }
                    
                    //returning the response
                    callback(resultArr)
                    
                }
            } catch {
                print(error);
                resultArr.size = -1
                callback(resultArr)
                return;
            }
        }
        //executing the task
        task.resume()
    }
    
    func getLocations(country: String?, state: String?, city: String?,
                      callback: @escaping (LocationInfo) -> ()) {
        // percent encode the parameter string
        var parameterString: String?
        if state == "Not Applicable" {
            parameterString = "?country=" + country! + "&state=&city=" + city!
        }
        else {
            parameterString = "?country=" + country! + "&state=" + state! + "&city=" + city!
        }
        let tempURL = SERVER + "/rfid/api/querylocations.php\(parameterString!)"
        let encodedURL = tempURL.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let requestURL = NSURL(string: encodedURL!)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "GET"
        
        var resultArr: LocationInfo = LocationInfo()
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error is \(error)")
                resultArr.size = -1;
                callback(resultArr);
                return;
            }
            
            do {
                //converting resonse to NSDictionary
                let myJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                //parsing the json
                if let parseJSON = myJSON {
                    
                    //getting the json response
                    resultArr.size = parseJSON["size"] as! Int
                    for i in 0..<resultArr.size {
                        if let subArray = parseJSON[String(i)] as? [String: AnyObject]
                        {
                            var loc: LocationCols = LocationCols()
                            loc.lid = subArray["lid"] as! String
                            loc.street = subArray["street"] as! String
                            loc.city = subArray["city"] as! String
                            loc.state_province_region = subArray["state_province_region"] as! String
                            loc.zip = subArray["zip"] as! String
                            loc.country = subArray["country"] as! String
                            resultArr.locations.append(loc);
                        }
                    }
                    
                    //returning the response
                    callback(resultArr)
                    
                }
            } catch {
                print(error)
                resultArr.size = -1;
                callback(resultArr);
                return;
            }
        }
        //executing the task
        task.resume()
    }
    
    func getDescriptions(country: String?, state: String?, city: String?,
                         callback: @escaping (DescriptionInfo) -> ()) {
        
        var parameterString: String?
        if state == "Not Applicable" {
            parameterString = "?country=" + country! + "&state=&city=" + city!
        }
        else {
            parameterString = "?country=" + country! + "&state=" + state! + "&city=" + city!
        }
        let tempURL = SERVER + "/rfid/api/querydescriptions.php\(parameterString!)"
        let encodedURL = tempURL.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let requestURL = NSURL(string: encodedURL!)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "GET"
        
        var resultArr: DescriptionInfo = DescriptionInfo()
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error is \(error)")
                resultArr.size = -1;
                callback(resultArr);
                return;
            }
            
            do {
                //converting resonse to NSDictionary
                let myJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                //parsing the json
                if let parseJSON = myJSON {
                    
                    //getting the json response
                    resultArr.size = parseJSON["size"] as! Int
                    for i in 0..<resultArr.size {
                        if let subArray = parseJSON[String(i)] as? [String: AnyObject]
                        {
                            var desc: DescriptionCols = DescriptionCols()
                            desc.lid = subArray["lid"] as! String
                            desc.did = subArray["did"] as! String
                            desc.description = subArray["description"] as! String
                            desc.price = (subArray["price"] as? Double)
                            resultArr.descriptions.append(desc);
                        }
                    }
                    
                    callback(resultArr)
                }
            } catch {
                print(error)
                resultArr.size = -1;
                callback(resultArr);
                return;
            }
        }
        //executing the task
        task.resume()
    }
    
    func getTags(country: String?, state: String?, city: String?, callback: @escaping (TagInfo)->()) {
        
        var parameterString: String?
        if state == "Not Applicable" {
            parameterString = "?country=" + country! + "&state=&city=" + city!
        }
        else {
            parameterString = "?country=" + country! + "&state=" + state! + "&city=" + city!
        }
        let tempURL = SERVER + "/rfid/api/querytags.php\(parameterString!)"
        let encodedURL = tempURL.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let requestURL = NSURL(string: encodedURL!)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "GET"
        
        var resultArr: TagInfo = TagInfo()
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error is \(error)")
                resultArr.size = -1;
                callback(resultArr);
                return;
            }
            
            do {
                //converting resonse to NSDictionary
                let myJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                //parsing the json
                if let parseJSON = myJSON {
                    
                    //getting the json response
                    resultArr.size = parseJSON["size"] as! Int
                    for i in 0..<resultArr.size {
                        if let subArray = parseJSON[String(i)] as? [String: AnyObject]
                        {
                            var tag: TagCols = TagCols()
                            tag.type = subArray["type"] as! String
                            tag.location = subArray["location"] as! String
                            tag.description = subArray["description"] as! String
                            tag.reserved = subArray["reserved"] as! String
                            resultArr.tags.append(tag);
                        }
                    }
                    
                    //returning the response
                    callback(resultArr)
                }
            } catch {
                print(error)
                resultArr.size = -1;
                callback(resultArr);
                return;
            }
        }
        //executing the task
        task.resume()
    }

    func getScanCity(type: String?, location: String?, description: String?, reserved: String?, callback: @escaping (ScanCity)->()) {
        
        let parameterString = "?type=" + type! + "&location=" + location! + "&description=" + description! + "&reserved=" + reserved!
        let tempURL = SERVER + "/rfid/api/scantag.php\(parameterString)"
        let encodedURL = tempURL.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
        let requestURL = NSURL(string: encodedURL!)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "GET"
        
        var resultArr: ScanCity = ScanCity()
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error is \(error)")
                resultArr.size = -1;
                callback(resultArr);
                return;
            }
            
            do {
                //converting resonse to NSDictionary
                let myJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                //parsing the json
                if let parseJSON = myJSON {
                    
                    //getting the json response
                    resultArr.size = parseJSON["size"] as! Int
                    if resultArr.size == 1 {
                        if let subArray = parseJSON["0"] as? [String: AnyObject]
                        {
                            resultArr.country = subArray["country"] as! String
                            let resultState = subArray["state_province_region"] as! String
                            if resultState.isEmpty {
                                resultArr.state_province_region = "Not Applicable"
                            }
                            else {
                                resultArr.state_province_region = resultState                         
                            }
                            resultArr.city = subArray["city"] as! String
                        }
                    }
                    else {
                        resultArr.country = "Not Applicable"
                        resultArr.state_province_region = "Not Applicable"
                        resultArr.city = "Not Applicable"
                    }
                    
                    //returning the response
                    callback(resultArr)
                }
            } catch {
                print(error)
                resultArr.size = -1;
                callback(resultArr);
                return;
            }
        }
        //executing the task
        task.resume()
    }
}
