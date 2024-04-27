import Foundation

public protocol StoreObserver<StateType> {
  associatedtype StateType
  func storeDidUpdate(state: StateType,
                      previousState: StateType?)
}
