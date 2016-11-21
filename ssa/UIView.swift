//
//  UIView.swift
//  ssa
//
//  Created by Muhammad Jahangir on 11/13/16.
//  Copyright © 2016 Alexander Prokic. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    
    func fadeIn(duration: TimeInterval = 0.6, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
            UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.alpha = 1.0
            }, completion: completion)
        }
        
    func fadeOut(duration: TimeInterval = 0.6, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
            UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.alpha = 0.0
            }, completion: completion)
        }
    
}
