import Foundation

// MARK: - Subscribers

public protocol AnySubscriber: class {
  func _update(with state: Any,
               prevState: Any?)
}

public protocol Subscriber: AnySubscriber {
  associatedtype StateType
  func update(with state: StateType,
              prevState: StateType?)
}

extension Subscriber {
  public func _update(with state: Any,
                      prevState: Any?) {
    if let state = state as? StateType {
      update(with: state, prevState: prevState as? StateType)
    }
  }
}

public struct Subscription<StateType: State> {
  private(set) weak var subscriber: AnySubscriber? = nil
  let selector: ((StateType) -> Any)?
  
  func notify(with state: StateType,
              prevState: StateType?) {
    if let selector = self.selector {
      self.subscriber?._update(with: selector(state), prevState: prevState)
    } else {
      self.subscriber?._update(with: state, prevState: prevState)
    }
  }  
}
