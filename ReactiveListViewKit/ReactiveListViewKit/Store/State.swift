import Foundation

public protocol State {
  mutating func reduce(action: Action)
}

public protocol CopyableState: State, NSCopying {}
