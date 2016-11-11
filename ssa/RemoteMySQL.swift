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
    var lid: String = ""
    var did: String = ""
    var description: String = ""
    var price: Double = 0.0
}

struct TagCols {
    var type: String = ""
    var location: String = ""
    var description: String = ""
    var reserved: String = ""
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

class RemoveMySQL {
    let SERVER = "http://35.2.212.110"

    func getCountries() -> CountryInfo {
        let URL_LIST_COUNTRIES = SERVER + "/rfid/api/listcountries.php"
        let requestURL = NSURL(string: URL_LIST_COUNTRIES)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "GET"
        let getParameters = ""
        request.httpBody = getParameters.data(using: String.Encoding.utf8)
        
        var resultArr: CountryInfo = CountryInfo()
        var failed = false

        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in

            if error != nil {
                print("error is \(error)")
                failed = true
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
                        if let subArray = parseJSON[String(i)] as? [[String: AnyObject]]
                        {
                            for item in subArray
                            {
                                resultArr.countries.append(item["country"] as! String);
                            }
                        }
//                        resultArr.countries.append(parseJSON[String(i)]["country"] as! String?);
                    }
                    
                    //returning the response
                    failed = false
                    return;
                    
                }
            } catch {
                failed = true
                print(error)
            }
        }
        //executing the task
        task.resume()
        if (failed) {
            resultArr.size = -1
        }
        
        return resultArr;
    }

    func getStates(country: String?) -> StateInfo {
        let URL_LIST_STATES = SERVER + "/rfid/api/liststates.php"
        let requestURL = NSURL(string: URL_LIST_STATES)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "GET"
        let getParameters = "country=" + country!
        request.httpBody = getParameters.data(using: String.Encoding.utf8)
        
        var resultArr: StateInfo = StateInfo()
        var failed = false
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error is \(error)")
                failed = true
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
//                            for item in subArray
//                            {
                                resultArr.states.append(subArray["state_province_region"] as! String);
//                            }
                        }
                        //arr.states.append(parseJSON[String(i)]["state_province_region"] as! String?);
                    }
                    
                    //returning the response
                    failed = false
                    return;
                    
                }
            } catch {
                failed = true
                print(error)
            }
        }
        //executing the task
        task.resume()
        if (failed) {
            resultArr.size = -1
        }
        
        return resultArr;
        
    }

    func getCities(country: String?, state: String?) -> CityInfo {
        let URL_LIST_CITIES = SERVER + "/rfid/api/listcities.php"
        let requestURL = NSURL(string: URL_LIST_CITIES)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "GET"
        let getParameters = "country=" + country! + "&state=" + state!
        request.httpBody = getParameters.data(using: String.Encoding.utf8)
        
        var resultArr: CityInfo = CityInfo()
        var failed = false
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error is \(error)")
                failed = true
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
//                            for item in subArray
//                            {
                                resultArr.cities.append(subArray["city"] as! String);
//                            }
                        }
                        //arr.cities.append(parseJSON[String(i)]["city"] as! String?);
                    }
                    
                    //returning the response
                    failed = false
                    return;
                    
                }
            } catch {
                failed = true
                print(error)
            }
        }
        //executing the task
        task.resume()
        if (failed) {
            resultArr.size = -1
        }
        
        return resultArr;
    }

    func getLocations(country: String?, state: String?, city: String?) -> LocationInfo {
        let URL_QUERY_LOCATIONS = SERVER + "/rfid/api/querylocations.php"
        let requestURL = NSURL(string: URL_QUERY_LOCATIONS)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "GET"
        let getParameters = "country=" + country! + "&state=" + state! + "&city=" + city!
        request.httpBody = getParameters.data(using: String.Encoding.utf8)
        
        var resultArr: LocationInfo = LocationInfo()
        var failed = false
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error is \(error)")
                failed = true
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
//                            for item in subArray
//                            {
                                var loc: LocationCols = LocationCols()
                                loc.lid = subArray["lid"] as! String
                                loc.street = subArray["street"] as! String
                                loc.city = subArray["city"] as! String
                                loc.state_province_region = subArray["state_province_region"] as! String
                                loc.zip = subArray["zip"] as! String
                                loc.country = subArray["country"] as! String
                                resultArr.locations.append(loc);
//                            }
                        }
                        //arr.cities.append(parseJSON[String(i)]["city"] as! String?);
                    }
                    
                    //returning the response
                    failed = false
                    return;
                    
                }
            } catch {
                failed = true
                print(error)
            }
        }
        //executing the task
        task.resume()
        if (failed) {
            resultArr.size = -1
        }
        
        return resultArr;

    }

    func getDescriptions(country: String?, state: String?, city: String?) -> DescriptionInfo {
        let URL_QUERY_DESCRIPTIONS = SERVER + "/rfid/api/querydescriptions.php"
        let requestURL = NSURL(string: URL_QUERY_DESCRIPTIONS)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "GET"
        let getParameters = "country=" + country! + "&state=" + state! + "&city=" + city!
        request.httpBody = getParameters.data(using: String.Encoding.utf8)
        
        var resultArr: DescriptionInfo = DescriptionInfo()
        var failed = false
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error is \(error)")
                failed = true
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
//                            for item in subArray
//                            {
                                var desc: DescriptionCols = DescriptionCols()
                                desc.lid = subArray["lid"] as! String
                                desc.did = subArray["did"] as! String
                                desc.description = subArray["description"] as! String
                                desc.price = subArray["price"] as! Double
                                resultArr.descriptions.append(desc);
//                            }
                        }
                        //arr.cities.append(parseJSON[String(i)]["city"] as! String?);
                    }
                    
                    //returning the response
                    failed = false
                    return;
                    
                }
            } catch {
                failed = true
                print(error)
            }
        }
        //executing the task
        task.resume()
        if (failed) {
            resultArr.size = -1
        }
        
        return resultArr;
    }

    func getTags(country: String?, state: String?, city: String?) -> TagInfo {
        let URL_QUERY_TAGS = SERVER + "/rfid/api/querytags.php"
        let requestURL = NSURL(string: URL_QUERY_TAGS)
        let request = NSMutableURLRequest(url: requestURL! as URL)
        request.httpMethod = "GET"
        let getParameters = "country=" + country! + "&state=" + state! + "&city=" + city!
        request.httpBody = getParameters.data(using: String.Encoding.utf8)
        
        var resultArr: TagInfo = TagInfo()
        var failed = false
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error is \(error)")
                failed = true
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
//                            for item in subArray
//                            {
                                var tag: TagCols = TagCols()
                                tag.type = subArray["type"] as! String
                                tag.location = subArray["location"] as! String
                                tag.description = subArray["description"] as! String
                                tag.reserved = subArray["reserved"] as! String
                                resultArr.tags.append(tag);
//                            }
                        }
                        //arr.cities.append(parseJSON[String(i)]["city"] as! String?);
                    }
                    
                    //returning the response
                    failed = false
                    return;
                    
                }
            } catch {
                failed = true
                print(error)
            }
        }
        //executing the task
        task.resume()
        if (failed) {
            resultArr.size = -1
        }
        
        return resultArr;
    }
}
