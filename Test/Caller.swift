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
    static let queue = NSOperationQueue()
    
    static var refreshTokenOperation: TRVSURLSessionOperation!
    
    class func requestWithDefaultUrl(number: Int, completion: CompletionBlock) {
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let request = NSURLRequest(URL: NSURL(string: "http://www.mocky.io/v2/56e1e0d4260000f80ceaa2ab")!)
        let operation = TRVSURLSessionOperation(session: session, request: request) { (d: NSData!, r: NSURLResponse!, e: NSError!) -> Void in
            if let d = d {
                print(number)
                completion(NSString(data: d, encoding: NSUTF8StringEncoding))
            }
        }
        
        if number >= 20 {
            if number ==  20 {
                let refreshRequest = NSURLRequest(URL: NSURL(string: "http://www.mocky.io/v2/56e2ef972600001d0776f506")!)
                Caller.refreshTokenOperation = TRVSURLSessionOperation(session: session, request: refreshRequest, completionHandler: { (d: NSData!, r: NSURLResponse!, e: NSError!) -> Void in
                    if let d = d {
                        print("\n")
                        print(number)
                        //                    print(number)
                        //                    self.queue.suspended = false
                        completion(NSString(data: d, encoding: NSUTF8StringEncoding))
                    }
                })
                queue.addOperation(Caller.refreshTokenOperation)
                
                queue.suspended = true
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                    sleep(10)
                    queue.suspended = false
                })
            }
            
            
            operation.addDependency(Caller.refreshTokenOperation)
            
            
            //            Caller.refreshTokenOperation.task.suspend()
            
            //            if number == 20 {
            //            refreshTokenOperation.task.suspend()
            //            }
        }
        
        queue.addOperation(operation)
    }
}