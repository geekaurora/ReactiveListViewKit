import Foundation

// MARK: - State

public protocol State {
    mutating func reduce(action: Action)
}

public protocol CopyableState: State, NSCopying {}

// MARK: - Actions

public protocol Action {}

// MARK: - Commands

public protocol Command {
    associatedtype StateType: CopyableState
    func execute(state: StateType, store: Store<StateType>)
}

// MARK: - Middlewares

public protocol AnyMiddleware {
    func _process(action: Action, state: Any)
}

public protocol Middleware: AnyMiddleware {
    associatedtype StateType
    func process(action: Action, state: StateType)
}

extension Middleware {
    public func _process(action: Action, state: Any) {
        if let state = state as? StateType {
            process(action: action, state: state)
        }
    }
}

public struct Middlewares<StateType: State> {
    private(set) var middleware: AnyMiddleware
}


// MARK: - Subscribers

public protocol AnySubscriber: class {
    func _update(with state: Any, prevState: Any?)
}

public protocol Subscriber: AnySubscriber {
    associatedtype StateType
    func update(with state: StateType, prevState: StateType?)
}

extension Subscriber {
    public func _update(with state: Any, prevState: Any?) {
        if let state = state as? StateType {
            update(with: state, prevState: prevState as? StateType)
        }
    }
}

public struct Subscription<StateType: State> {
    private(set) weak var subscriber: AnySubscriber? = nil
    let selector: ((StateType) -> Any)?
    let notifyQueue: DispatchQueue

    fileprivate func notify(with state: StateType, prevState: StateType?) {
        internalDispatch(.async, queue: notifyQueue) {
            if let selector = self.selector {
                self.subscriber?._update(with: selector(state), prevState: prevState)
            } else {
                self.subscriber?._update(with: state, prevState: prevState)
            }
        }
    }
}

// MARK: - Store

public class Store<StateType: CopyableState> {
    public private (set) var prevState: StateType?
    /// Main State
    public private (set) var state: StateType {
        didSet {
            subscriptions = subscriptions.filter { $0.subscriber != nil }
            for subscription in subscriptions {
                subscription.notify(with: state, prevState: prevState)
            }
            prevState = state.copy() as? StateType
            
        }
    }

    private let jobQueue:DispatchQueue = DispatchQueue(label: "reactor.store.queue", qos: .userInitiated, attributes: [])
    private let subscriptionsSyncQueue = DispatchQueue(label: "reactor.store.subscription.sync")
    private var _subscriptions = [Subscription<StateType>]()
    private var subscriptions: [Subscription<StateType>] {
        get {
            return internalDispatch(.sync, queue: jobQueue) {
                return self._subscriptions
            }!
        }
        set {
            internalDispatch(.sync, queue: jobQueue) {
                self._subscriptions = newValue
            }
        }
    }
    private let middlewares: [Middlewares<StateType>]
    
    public init(state: StateType, middlewares: [AnyMiddleware] = []) {
        self.state = state
        self.middlewares = middlewares.map(Middlewares.init)
    }
    
    // MARK: - Subscriptions
    
    public func subscribe(_ subscriber: AnySubscriber, notifyOnQueue queue: DispatchQueue? = DispatchQueue.main, selector: ((StateType) -> Any)? = nil) {
        internalDispatch(.async, queue: jobQueue) {
            guard !self.subscriptions.contains(where: {$0.subscriber === subscriber}) else { return }
            let subscription = Subscription(subscriber: subscriber, selector: selector, notifyQueue: queue ?? self.jobQueue)
            self.subscriptions.append(subscription)
            subscription.notify(with: self.state, prevState: self.prevState)
        }
    }
    
    public func remove(subscriber: AnySubscriber) {
        subscriptions = subscriptions.filter { $0.subscriber !== subscriber }
    }
    
    // MARK: - Actions
    
    public func dispatch(action: Action) {
        let actionString = String(describing: action).components(separatedBy: "\n").first
        dbgPrint("Reactor - Fired action: \(actionString!)")
        internalDispatch(.async, queue: jobQueue) {
            self.state.reduce(action: action)
            let state = self.state
            self.middlewares.forEach { $0.middleware._process(action: action, state: state) }
        }
    }
    
    public func fire<C: Command>(command: C) where C.StateType == StateType {
        internalDispatch(.async, queue: jobQueue) {
            command.execute(state: self.state, store: self)
        }
    }
}

// MARK: - Internal Adapative Dispatch

private enum DispatchType {
    case sync, async
}
private func internalDispatch<T>(_ type: DispatchType, queue: DispatchQueue, closure: @escaping ()->T) -> T? {
    if ReactiveListViewKit.useGCD {
        switch type {
        case .sync:
            return queue.sync(execute: closure)
        case .async:
            queue.async(execute: { let _ = closure() })
            return nil
        }
    } else {
        return closure()
    }
}


