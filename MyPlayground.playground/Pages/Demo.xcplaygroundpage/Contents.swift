// State, Action -> State

struct Todo {
    let id: Int
    let name: String
    let completed: Bool
}

enum Action {
    case AddTodo(String)
    case Toggle(Int)
}

let addTodo: ([Todo], Action) -> [Todo] = { todos, action in
    guard case .AddTodo(let name) = action else { return todos }
    let newTodo = Todo(id: todos.count, name: name, completed: false)
    return todos + [newTodo]
}

let toggleTodo: ([Todo], Action) -> [Todo] = { todos, action in
    guard case .Toggle(let index) = action else { return todos }
    return todos.map({
        guard $0.id == index else { return $0 }
        return Todo(id: $0.id, name: $0.name, completed: !$0.completed)
    })
}

func mergeReducer<S, A>(reducers: ((S, A)->S)... ) -> (S, A) -> S {
    return { s, a in
        reducers.reduce(s, combine: {$1($0, a)})
    }
}

let todoReducer = mergeReducer(addTodo, toggleTodo)

class Store<State, Action> {
    private(set) var state: State
    
    typealias Reducer = (State, Action) -> State
    private let reducer: Reducer
    
    init (state: State, reducer: Reducer) {
        self.state = state
        self.reducer = reducer
    }
    
    func dispatch(action: Action) {
        self.state = self.reducer(self.state, action)
        self.subscribers.forEach({$0?(self.state)})
    }
    
    typealias Subscriber = State -> Void
    typealias Disposable = () -> Void
    private var subscribers: [Subscriber?] = []
    func subscribe(subscriber: Subscriber) -> Disposable {
        let index = subscribers.count
        subscribers.append(subscriber)
        return { self.subscribers[index] = nil }
    }
}

let store = Store(state: [Todo](), reducer: todoReducer)
_ = store.subscribe({
    print($0)
})

store.dispatch(.AddTodo("Hello"))
store.dispatch(.AddTodo("World"))
store.dispatch(.Toggle(0))


