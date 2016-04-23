public class Store<State, Action> {
    public private(set) var state: State
    
    public typealias Reducer = (State, Action) -> State
    private let reducer: Reducer
    
    public init (state: State, reducer: Reducer) {
        self.state = state
        self.reducer = reducer
    }
    
    public func dispatch(action: Action) {
        self.state = self.reducer(self.state, action)
        self.subscribers.forEach({$0?(self.state)})
    }
    
    public typealias Subscriber = State -> Void
    public typealias Disposable = () -> Void
    private var subscribers: [Subscriber?] = []
    public func subscribe(subscriber: Subscriber) -> Disposable {
        let index = subscribers.count
        subscribers.append(subscriber)
        return { self.subscribers[index] = nil }
    }
}

public func mergeReducer<S, A>(reducers: ((S, A)->S)... ) -> (S, A) -> S {
    return { s, a in
        reducers.reduce(s, combine: {$1($0, a)})
    }
}
