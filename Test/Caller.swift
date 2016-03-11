//
//  Caller.swift
//  Test
//
//  Created by Tayal, Rishabh on 3/10/16.
//  Copyright © 2016 Tayal, Rishabh. All rights reserved.
//

import UIKit
import TRVSURLSessionOperation

class Caller: NSObject {
    
    typealias CompletionBlock = NSString? -> Void
    let queue = NSOperationQueue()
    
    var refreshTokenOperation: TRVSURLSessionOperation!
    
    func requestWithDefaultUrl(number: Int, completion: CompletionBlock) {
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let request = NSURLRequest(URL: NSURL(string: "http://www.mocky.io/v2/56e1e0d4260000f80ceaa2ab")!)
        let operation = TRVSURLSessionOperation(session: session, request: request) { (d: NSData!, r: NSURLResponse!, e: NSError!) -> Void in
            if let d = d {
                print(number)
                completion(NSString(data: d, encoding: NSUTF8StringEncoding))
            }
        }
        
        if number >= 20 {
            if number == 20 {
                queue.suspended = true
                //                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                //                    sleep(5)
                //                })
            }
            //Refresh the Token
            //            let request = NSURLRequest(URL: NSURL(string: "http://www.mocky.io/v2/56e1e0d4260000f80ceaa2ab")!)
            refreshTokenOperation = TRVSURLSessionOperation(session: session, request: request, completionHandler: { (d: NSData!, r: NSURLResponse!, e: NSError!) -> Void in
                if let d = d {
                    print(number)
                    self.queue.suspended = false
                    completion(NSString(data: d, encoding: NSUTF8StringEncoding))
                }
            })
            operation.addDependency(refreshTokenOperation)
            queue.addOperation(refreshTokenOperation)
            
            //            queue.suspended = false
        }
        
        queue.addOperation(operation)
    }
}

//class Operation: NSOperation {
//    
//    let task: NSURLSessionTask
//    let number: Int
//    
//    init(task: NSURLSessionTask, number: Int) {
//        self.task = task
//        self.number = number
//        super.init()
//    }
//    
//    override func start() {
//        
//        if number != 20 {
//            //            sleep(5)
//            task.resume()
//        } else {
//            //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
//            //            task.resume()
//            //            })
//            
//        }
//        print(number)
//    }
//}