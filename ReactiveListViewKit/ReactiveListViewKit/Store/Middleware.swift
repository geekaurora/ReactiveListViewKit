import Foundation

// MARK: - Middlewares

public protocol AnyMiddleware {
  func _process(action: Action,
                state: Any)
}

public protocol Middleware: AnyMiddleware {
  associatedtype StateType
  func process(action: Action,
               state: StateType)
}

extension Middleware {
  public func _process(action: Action,
                       state: Any) {
    if let state = state as? StateType {
      process(action: action, state: state)
    }
  }
}

public struct Middlewares<StateType: State> {
  private(set) var middleware: AnyMiddleware
}
