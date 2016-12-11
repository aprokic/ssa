//
//  HomeViewController.swift
//  ssa
//
//  Created by Muhammad Jahangir on 10/28/16.
//  Copyright © 2016 Alexander Prokic. All rights reserved.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController,  UgiInventoryDelegate {
    
  
    @IBAction func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        let utterance = AVSpeechUtterance(string: "swipe right to download r f i d tags or swipe left to start scanning")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.volume = 2
        
        try! AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
            try! AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.none)
        })
    }
    
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
