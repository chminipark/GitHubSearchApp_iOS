//
//  Property.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/19.
//

import Foundation
import RxCocoa

@propertyWrapper
struct Property<Value> {
  let lock = NSLock()
  var relay: BehaviorRelay<Value>
  
  init(wrappedValue: Value) {
    self.relay = BehaviorRelay<Value>(value: wrappedValue)
  }
  
  var wrappedValue: Value {
    get { load() }
    set { store(newValue) }
  }
  
  var projectedValue: BehaviorRelay<Value> {
    return self.relay
  }
  
  func load() -> Value {
    lock.lock()
    defer { lock.unlock() }
    return self.relay.value
  }
  
  func store(_ value: Value) {
    lock.lock()
    defer { lock.unlock() }
    self.relay.accept(value)
  }
}
