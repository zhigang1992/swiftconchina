//: ### Data Structure
struct Todo {
    let id: Int
    let name: String
    let completed: Bool
}

enum Visibility {
    case Active
    case Completed
    case All
}

struct TodoApp {
    let todos: [Todo]
    let visibility: Visibility
}

enum Action {
    case AddTodo(String)
    case Toggle(Int)
    case SetVisibility(Visibility)
}

//: ### Reducers
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

let todoReducer = mergeReducer(addTodo, toggleTodo)

let visibilityReducer: (Visibility, Action) -> Visibility = { s, a in
    guard case .SetVisibility(let v) = a else { return s }
    return v
}

let appReducer: (TodoApp, Action) -> TodoApp = { s, a in
    // How to combine reducers?
    
}
//: ### Store
let store = Store(state: [Todo](), reducer: todoReducer)
_ = store.subscribe({
    print($0)
})

store.dispatch(.AddTodo("Hello"))
store.dispatch(.AddTodo("World"))
store.dispatch(.Toggle(0))


