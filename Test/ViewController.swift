//
//  ViewController.swift
//  Test
//
//  Created by Tayal, Rishabh on 3/10/16.
//  Copyright © 2016 Tayal, Rishabh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        var arr = [3,5,6,1,4,2]
        for var i = 0; i < 50; i++ {
            
            Caller.requestWithDefaultUrl(i, completion: { (s: NSString?) -> Void in
                //                print(i)
            })
            
        }
    }
}

