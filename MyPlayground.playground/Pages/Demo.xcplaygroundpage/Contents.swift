// State, Action -> State

struct Todo {
    let id: Int
    let name: String
    let completed: Bool
}

enum Action {
    case AddTodo(String)
}