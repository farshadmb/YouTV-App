//
//  DispatchQueue+Additional.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 4/26/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

// MARK: private functionality

extension DispatchQueue {

    /// <#Description#>
    private struct QueueReference { weak var queue: DispatchQueue? }

    /// <#Description#>
    private static let key: DispatchSpecificKey<QueueReference> = {
        let key = DispatchSpecificKey<QueueReference>()
        setupSystemQueuesDetection(key: key)
        return key
    }()

    /// Register and set specific the given `DispatchQueue`s object by its `DispatchSpecificKey<QueueReference>` value.
    /// - Parameters:
    ///   - queues: The `DispatchQueue`s want to register
    ///   - key: The key value is used in `DispatchQueue.setSpecific` method.
    private static func _registerDetection(of queues: [DispatchQueue], key: DispatchSpecificKey<QueueReference>) {
        queues.forEach { $0.setSpecific(key: key, value: QueueReference(queue: $0)) }
    }

    /// Setup and Register the System `DispatchQueue` for detections
    /// - Parameter key: the `DispatchSpecificKey<QueueReference>` value.
    private static func setupSystemQueuesDetection(key: DispatchSpecificKey<QueueReference>) {
        let queues: [DispatchQueue] = [
                                        .main,
                                        .global(qos: .background),
                                        .global(qos: .default),
                                        .global(qos: .unspecified),
                                        .global(qos: .userInitiated),
                                        .global(qos: .userInteractive),
                                        .global(qos: .utility)
                                    ]
        _registerDetection(of: queues, key: key)
    }
}

// MARK: public functionality

extension DispatchQueue {

    /// Register and set specific the given `DispatchQueue` value.
    /// - Parameters:
    ///   - queue: The `DispatchQueue` that we want to register
    static func registerDetection(of queue: DispatchQueue) {
        _registerDetection(of: [queue], key: key)
    }

    /// The Current Queue Label value
    static var currentQueueLabel: String? { current?.label }

    /// The current queue that the code block perform on.
    static var current: DispatchQueue? { getSpecific(key: key)?.queue }
}

extension DispatchQueue {

    /// Perform safe the given block code on the current queue
    ///
    /// - Parameter block: The program code block that you want to perform on current thread safely.
    func performSafe(_ block: @escaping () -> Void) {
        guard DispatchQueue.current != self else {
            block()
            return
        }

        async(execute: block)
    }

}
