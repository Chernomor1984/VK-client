//
//  DownloadOperation.swift
//  VK
//
//  Created by Eugene Khizhnyak on 23.11.17.
//  Copyright © 2017 RCNTEC. All rights reserved.
//

import Foundation
import UIKit

class AsyncNetworkOperation: Operation {
    
    private var urlRequest: URLRequest?
    private var dataTask: URLSessionDataTask!
    var data: Data?
    
    // MARK: - Init
    
    init(with request: URLRequest) {
        self.urlRequest = request
    }
    
    // MARK: - Private
    
    private enum State: String {
        case ready, executing, finished
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    private var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
}

extension AsyncNetworkOperation {
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override func cancel() {
        dataTask.cancel()
        super.cancel()
        state = .finished
    }
    
    override func start() {
        if isCancelled {
            state = .finished
            return
        }
        
        guard let urlRequest = urlRequest else {
            state = .finished
            return
        }
        
        let completionHandler = { [weak self] (data: Data?, urlResponse: URLResponse?, error: Error?) in
            if let error = error {
                print("AsyncDownloadOperation finished with error:\(error.localizedDescription)")
                self?.state = .finished
                return
            }
            
            guard let data = data else {
                print("AsyncDownloadOperation finished with no data")
                self?.state = .finished
                return
            }
            self?.data = data
            self?.state = .finished
        }
        dataTask = HTTPSessionManager.sharedInstance.dataTask(urlRequest: urlRequest, completionHandler: completionHandler)
        dataTask.resume()
        state = .executing
    }
}
