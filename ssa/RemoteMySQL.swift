//
//  RemoteMySQL.swift
//  ssa
//
//  Created by Nils Strand on 11/7/2016.
//  Copyright © 2016 Alexander Prokic. All rights reserved.
//

struct CountryInfo {
    var countries: Array<String?>
    var size: Int
}

struct StateInfo {
    var states: Array<String?>
    var size: Int
}

struct CityInfo {
    var cities: Array<String?>
    var size: Int
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
    var price: Double
}

struct TagCols {
    var type: String?
    var location: String?
    var description: String?
    var reserved: String?
}

struct LocationInfo {
    var locations: Array<LocationCols>
    var size: Int
}

struct DescriptionInfo {
    var descriptions: Array<DescriptionCols>
    var size: Int
}

struct TagInfo {
    var tags: Array<TagsCols>
    var size: Int
}

class RemoveMySQL {
    let SERVER = "http://35.2.246.206"

    func getCountries() -> CountryInfo {
        let URL_LIST_COUNTRIES = SERVER" + "/rfid/api/listcountries.php"
        let requestURL = NSURL(string: URL_LIST_COUNTRIES)
        let request = NSMutableURLRequests(URL: requestURL!)
        request.HTTPMethod = "GET"
        let getParameters = ""
        request.HTTPBody = getParameters.dataUsingEncoding(NSUTF8StringEncoding)

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in

            if error != nil {
                print("error is \(error)")
                return nil
            }

            do {
                //converting resonse to NSDictionary
                let myJSON =  try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                
                //parsing the json
                if let parseJSON = myJSON {
                    
                    var arr: CountryInfo
                    
                    //getting the json response
                    arr.size = parseJSON["size"] as! Int
                    for i in 0...<arr.size {
                        arr.countries.append(parseJSON[String(i)]["country"] as! String?);
                    }
                    
                    //returning the response
                    return arr
                    
                }
            } catch {
                print(error)
            }
        }
        //executing the task
        task.resume()
    }

    func getStates(country: String?) -> StateInfo {
        let URL_LIST_STATES = SERVER" + "/rfid/api/liststates.php"
        let requestURL = NSURL(string: URL_LIST_STATES)
        let request = NSMutableURLRequests(URL: requestURL!)
        request.HTTPMethod = "GET"
        let getParameters = "country=" + country!
        request.HTTPBody = getParameters.dataUsingEncoding(NSUTF8StringEncoding)

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in

            if error != nil {
                print("error is \(error)")
                return nil
            }

            do {
                //converting resonse to NSDictionary
                let myJSON =  try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                
                //parsing the json
                if let parseJSON = myJSON {
                    
                    var arr: StateInfo
                    
                    //getting the json response
                    arr.size = parseJSON["size"] as! Int
                    for i in 0...<arr.size {
                        arr.states.append(parseJSON[String(i)]["state_province_region"] as! String?);
                    }
                    
                    //returning the response
                    return arr
                    
                }
            } catch {
                print(error)
            }
        }
        //executing the task
        task.resume()
    }

    func getCities(country: String?, state: String?) -> CityInfo {
        let URL_LIST_CITIES = SERVER" + "/rfid/api/listcities.php"
        let requestURL = NSURL(string: URL_LIST_CITIES)
        let request = NSMutableURLRequests(URL: requestURL!)
        request.HTTPMethod = "GET"
        let getParameters = "country=" + country! + "&state=" + state!
        request.HTTPBody = getParameters.dataUsingEncoding(NSUTF8StringEncoding)

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in

            if error != nil {
                print("error is \(error)")
                return nil
            }

            do {
                //converting resonse to NSDictionary
                let myJSON =  try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                
                //parsing the json
                if let parseJSON = myJSON {
                    
                    var arr: CityInfo
                    
                    //getting the json response
                    arr.size = parseJSON["size"] as! Int
                    for i in 0...<arr.size {
                        arr.cities.append(parseJSON[String(i)]["city"] as! String?);
                    }
                    
                    //returning the response
                    return arr
                    
                }
            } catch {
                print(error)
            }
        }
        //executing the task
        task.resume()
    }

    func getLocations(country: String?, state: String?, city: String?) -> LocationInfo {
        let URL_QUERY_LOCATIONS = SERVER" + "/rfid/api/querylocations.php"
        let requestURL = NSURL(string: URL_QUERY_LOCATIONS)
        let request = NSMutableURLRequests(URL: requestURL!)
        request.HTTPMethod = "GET"
        let getParameters = "country=" + country! + "&state=" + state! + "&city=" + city!
        request.HTTPBody = getParameters.dataUsingEncoding(NSUTF8StringEncoding)

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in

            if error != nil {
                print("error is \(error)")
                return nil
            }

            do {
                //converting resonse to NSDictionary
                let myJSON =  try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                
                //parsing the json
                if let parseJSON = myJSON {
                                       
                    var arr: LocationInfo
                    
                    //getting the json response
                    arr.size = parseJSON["size"] as! Int
                    for i in 0...<arr.size {
                        var loc: LocationCols
                        loc.lid = parseJSON[String(i)]["lid"] as! String?
                        loc.street = parseJSON[String(i)]["street"] as! String?
                        loc.city = parseJSON[String(i)]["city"] as! String?
                        loc.state_province_region = parseJSON[String(i)]["state_province_region"] as! String?
                        loc.zip = parseJSON[String(i)]["zip"] as! String?
                        loc.country = parseJSON[String(i)]["country"] as! String?
                        arr.locations.append(loc);
                    }
                    
                    //returning the response
                    return arr
                    
                }
            } catch {
                print(error)
            }
        }
        //executing the task
        task.resume()
    }

    func getDescriptions(country: String?, state: String?, city: String?) -> DescriptionInfo {
        let URL_QUERY_DESCRIPTIONS = SERVER" + "/rfid/api/querydescriptions.php"
        let requestURL = NSURL(string: URL_QUERY_DESCRIPTIONS)
        let request = NSMutableURLRequests(URL: requestURL!)
        request.HTTPMethod = "GET"
        let getParameters = "country=" + country! + "&state=" + state! + "&city=" + city!
        request.HTTPBody = getParameters.dataUsingEncoding(NSUTF8StringEncoding)

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in

            if error != nil {
                print("error is \(error)")
                return nil
            }

            do {
                //converting resonse to NSDictionary
                let myJSON =  try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                
                //parsing the json
                if let parseJSON = myJSON {
                                                         
                    var arr: DesciptionInfo
                    
                    //getting the json response
                    arr.size = parseJSON["size"] as! Int
                    for i in 0...<arr.size {
                        var desc: DescriptionCols
                        desc.lid = parseJSON[String(i)]["lid"] as! String?
                        desc.did = parseJSON[String(i)]["did"] as! String?
                        desc.description = parseJSON[String(i)]["description"] as! String?
                        desc.price = parseJSON[String(i)]["price"] as! Double
                        arr.desciptions.append(desc);
                    }
                    
                    //returning the response
                    return arr
                    
                }
            } catch {
                print(error)
            }
        }
        //executing the task
        task.resume()
    }

    func getTags(country: String?, state: String?, city: String?) -> DescriptionInfo {
        let URL_QUERY_TAGS = SERVER" + "/rfid/api/querytags.php"
        let requestURL = NSURL(string: URL_QUERY_TAGS)
        let request = NSMutableURLRequests(URL: requestURL!)
        request.HTTPMethod = "GET"
        let getParameters = "country=" + country! + "&state=" + state! + "&city=" + city!
        request.HTTPBody = getParameters.dataUsingEncoding(NSUTF8StringEncoding)

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in

            if error != nil {
                print("error is \(error)")
                return nil
            }

            do {
                //converting resonse to NSDictionary
                let myJSON =  try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                
                //parsing the json
                if let parseJSON = myJSON {
                                        
                    var arr: TagInfo
                    
                    //getting the json response
                    arr.size = parseJSON["size"] as! Int
                    for i in 0...<arr.size {
                        var tag: TagCols
                        tag.type = parseJSON[String(i)]["type"] as! String?
                        tag.location = parseJSON[String(i)]["location"] as! String?
                        tag.description = parseJSON[String(i)]["description"] as! String?
                        tag.reserved = parseJSON[String(i)]["reserved"] as! String?
                        arr.tags.append(tag);
                    }
                    
                    //returning the response
                    return arr
                    
                }
            } catch {
                print(error)
            }
        }
        //executing the task
        task.resume()
    }
}