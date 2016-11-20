//
//  HomeViewController.swift
//  ssa
//
//  Created by Muhammad Jahangir on 10/28/16.
//  Copyright © 2016 Alexander Prokic. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,  UgiInventoryDelegate {
    
    @IBOutlet weak var start_scanning: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let inventory: UgiInventory? = Ugi.singleton().activeInventory
        if (inventory != nil){
            inventory!.stop {
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

}
