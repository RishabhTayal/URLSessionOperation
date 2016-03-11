//
//  Caller.swift
//  Test
//
//  Created by Tayal, Rishabh on 3/10/16.
//  Copyright © 2016 Tayal, Rishabh. All rights reserved.
//

import UIKit

//#define TRVSKVOBlock(KEYPATH, BLOCK) \
//[self willChangeValueForKey:KEYPATH]; \
//BLOCK(); \
//[self didChangeValueForKey:KEYPATH];

class Caller: NSObject {
    
    typealias CompletionBlock = NSString? -> Void
    static let queue = NSOperationQueue()
    
    static var refreshTokenOperation: Operation!
    
    class func requestWithDefaultUrl(number: Int, completion: CompletionBlock) {
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let request = NSURLRequest(URL: NSURL(string: "http://www.mocky.io/v2/56e1e0d4260000f80ceaa2ab")!)
        let operation = Operation(session: session, request: request, completion: { (d, r, e) -> Void in
            if let d = d {
                //                print(number)
                completion(NSString(data: d, encoding: NSUTF8StringEncoding))
            }
            }, number: number)
        
        if number >= 20 {
            if number ==  20 {
                let refreshRequest = NSURLRequest(URL: NSURL(string: "http://www.mocky.io/v2/56e2ef972600001d0776f506")!)
                Caller.refreshTokenOperation = Operation(session: session, request: refreshRequest, completion: { (d, r, e) -> Void in
                    if let d = d {
                        print("\n")
                        //                        print(number)
                        completion(NSString(data: d, encoding: NSUTF8StringEncoding))
                    }
                    }, number: number)
                queue.addOperation(Caller.refreshTokenOperation)
                
                queue.suspended = true
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                    sleep(20)
                    queue.suspended = false
                })
            }
            
            operation.addDependency(Caller.refreshTokenOperation)
        }
        
        queue.addOperation(operation)
    }
    
}

class Operation: NSOperation {
    
    var task: NSURLSessionTask?
    
    private var _executing: Bool = false
    override var executing: Bool {
        get { return _executing }
        set {
            if _executing != newValue {
                willChangeValueForKey("isExecuting")
                _executing = newValue
                didChangeValueForKey("isExecuting")
            }
        }
    }
    
    private var _finished: Bool = false;
    override var finished: Bool {
        get {
            return _finished
        }
        set {
            if _finished != newValue {
                willChangeValueForKey("isFinished")
                _finished = newValue
                didChangeValueForKey("isFinished")
            }
        }
    }
    
    var number: Int?
    
    init(session: NSURLSession, request: NSURLRequest, completion: ((d: NSData?, r: NSURLResponse?, e: NSError?) -> Void), number: Int) {
        super.init()
        self.task = session.dataTaskWithRequest(request, completionHandler: { (d: NSData?, r: NSURLResponse?, e: NSError?) -> Void in
            completion(d: d, r: r, e: e)
            self.executing = false
            self.finished = true
        })
        self.number = number
    }
    
    override func start() {
        print(number)
        task!.resume()
    }
    
    override func cancel() {
        super.cancel()
        task!.cancel()
    }
}