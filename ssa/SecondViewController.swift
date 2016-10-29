//
//  SecondViewController.swift
//  ssa
//
//  Created by Muhammad Jahangir on 10/27/16.
//  Copyright © 2016 Alexander Prokic. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UgiInventoryDelegate  {

    @IBOutlet weak var TagLabel: UILabel!

    // Variables
    let db = SQLiteDB.sharedInstance
    var scanPaused = false
    var scanStopped = true
    
    // Queue of descriptions to be read aloud
    let descriptionQueue = Queue<String>();
    
    // Update UI when a tag is found
    func inventoryTagFound(_ tag: UgiTag!,
                           withDetailedPerReadData detailedPerReadData: [UgiDetailedPerReadData]?) {
        //let rfid = inventory!.tags.first!.epc.toString()
        let rfid = tag.epc.toString()
        
        // declare index ranges for hex RFID string
        let endTypeRange = rfid!.index(rfid!.startIndex, offsetBy: 2)
        let endLocRange = rfid!.index(rfid!.startIndex, offsetBy: 11)
        let endDescRange = rfid!.index(rfid!.startIndex, offsetBy: 19)
        let locRange = endTypeRange..<endLocRange
        let descRange = endLocRange..<endDescRange
        
        // get necessary rfid subcomponents
        let lid = rfid!.substring(with: locRange)
        let did = rfid!.substring(with: descRange)
        
        // query database for description
        let data = db.query(sql: "SELECT description FROM descriptions WHERE lid=? AND did=?", parameters:[lid, did])
        
        // RFID Tag found in DB.
        if (!data.isEmpty){
            // Since we queried one tag at a time, the returned dictionary only has one entry.
            let row = data[0]
            if let description = row["description"]{
                // Change the label, and push it onto queue of descriptions.
                TagLabel.text = description as? String
                descriptionQueue.enqueue(value: description as! String);
            }
        }
    }
    
    // Take special actions on subsequent find
    func inventoryTagSubsequentFinds(_ tag: UgiTag!, numFinds num: Int32, withDetailedPerReadData detailedPerReadData: [UgiDetailedPerReadData]!) {
        
    }
    
    @IBAction func scanner(_ sender: UIButton) {
        let inventory: UgiInventory? = Ugi.singleton().activeInventory
        if scanStopped {
            Ugi.singleton().startInventory(
                self,
                with: UgiRfidConfiguration.config(withInventoryType: UgiInventoryTypes.UGI_INVENTORY_TYPE_LOCATE_DISTANCE))
            sender.setTitle("SCANNING", for: .normal)
            self.scanStopped = false
        }
        else if scanPaused {
            inventory!.resumeInventory()
            sender.setTitle("SCANNING", for: .normal)
            self.scanPaused = false
        }
        else {
            inventory!.pause()
            sender.setTitle("PAUSED", for: .normal)
            self.scanPaused = true
        }
    }
    
    @IBAction func swipeToHome(_ sender: AnyObject) {
        let inventory: UgiInventory? = Ugi.singleton().activeInventory
        if (inventory != nil){
            inventory!.stop {
                self.scanStopped = true
                self.scanPaused = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
