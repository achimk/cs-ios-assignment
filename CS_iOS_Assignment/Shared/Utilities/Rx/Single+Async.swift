//
//  Single+Async.swift
//  CS_iOS_Assignment
//
//  Created by Joachim Kret on 08/02/2021.
//  Copyright © 2021 Backbase. All rights reserved.
//

import RxSwift

public struct CallbackQueue {
    
    public static let concurrent = DispatchQueue(
        label: "com.backbase.cs.assignment.concurrentQueue",
        qos: .userInteractive,
        attributes: .concurrent)
    
    public static let serial = DispatchQueue(
        label: "com.backbase.cs.assignment.serialQueue")
    
    public static var main: DispatchQueue { return DispatchQueue.main }
}

extension Single {
    
    public static func asyncOrCurrent<T>(_ async: Bool, concurrent: Bool = false, action: @escaping () throws -> T) -> Single<T> {
        
        guard async else {
            return Single.deferred {
                do {
                    let value = try action()
                    return Single.just(value)
                } catch {
                    return Single.error(error)
                }
            }
        }
        
        let queue = concurrent ? CallbackQueue.concurrent : CallbackQueue.serial
        return Single.create { (observer) -> Disposable in
            queue.async {
                do {
                    let value = try action()
                    observer(.success(value))
                } catch {
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }
}
