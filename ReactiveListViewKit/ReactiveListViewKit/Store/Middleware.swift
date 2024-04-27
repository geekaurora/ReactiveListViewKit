import Foundation

public protocol Middleware<StateType> {
  associatedtype StateType
  func process(action: Action,
               state: StateType)
}

