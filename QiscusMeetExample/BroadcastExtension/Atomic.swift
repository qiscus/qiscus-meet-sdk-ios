//
//  Atomic.swift
//  QiscusMeetExample
//
//  Created by Gustu on 19/07/21.
//  Copyright © 2021 qiscus. All rights reserved.
//

import Foundation
//import Qiscus_Meet
@propertyWrapper
struct Atomic<Value> {

    private var value: Value
    private let lock = NSLock()

    init(wrappedValue value: Value) {
        self.value = value
    }

    var wrappedValue: Value {
      get { return load() }
      set { store(newValue: newValue) }
    }

    func load() -> Value {
        lock.lock()
        defer { lock.unlock() }
        return value
    }

    mutating func store(newValue: Value) {
        lock.lock()
        defer { lock.unlock() }
        value = newValue
    }
}
