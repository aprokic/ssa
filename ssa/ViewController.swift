//
//  ViewController.swift
//  ssa
//
//  Created by Alexander Prokic on 10/9/16.
//  Copyright © 2016 Alexander Prokic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UgiInventoryDelegate {

    //Variables
    @IBOutlet weak var displayTagLabel: UILabel!
    let db = SQLiteDB.sharedInstance
    var scanPaused = false
    var scanStopped = true
    // Queue of descriptions to be read aloud
    let descriptionQueue = Queue<String>();
    
    // Update UI when a tag is found
    func inventoryTagFound(_ tag: UgiTag!,
                           withDetailedPerReadData detailedPerReadData: [UgiDetailedPerReadData]?) {
        //let inventory: UgiInventory? = Ugi.singleton().activeInventory
        //let rfid = inventory!.tags.first!.epc.toString()
        let rfid = tag.epc.toString()
        let data = db.query(sql: "SELECT description FROM tags WHERE rfid=?", parameters:[rfid])
        
        // RFID Tag found in DB.
        if (!data.isEmpty){
            // Since we queried one tag at a time, the returned dictionary only has one entry.
            let row = data[0]
            if let description = row["description"]{
                // Change the label, and push it onto queue of descriptions.
                displayTagLabel.text = description as? String
                descriptionQueue.enqueue(value: description as! String);
            }
        }
    }
    
    // Control for Stop Button
    @IBAction func STOP(_ sender: UIButton) {
        let inventory: UgiInventory? = Ugi.singleton().activeInventory
        if (inventory != nil){
            inventory!.stop {
                self.displayTagLabel.text = "Stopped"
                self.scanStopped = true
                self.scanPaused = false
                let scanButton = self.view.viewWithTag(1) as! UIButton
                scanButton.setTitle("SCAN", for: .normal)
            }
        }
    }

    // Control for Read Button
    @IBAction func readButton(_ sender: UIButton) {
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
    
    /**/
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

