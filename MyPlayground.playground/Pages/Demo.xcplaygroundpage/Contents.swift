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

var state = [Todo]()
state = todoReducer(state, .AddTodo("Hello"))
print(state)
state = todoReducer(state, .Toggle(0))
print(state)
