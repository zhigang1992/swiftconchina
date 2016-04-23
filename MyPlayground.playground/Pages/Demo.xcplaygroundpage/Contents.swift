//: ### Data Structure
struct Todo {
    let id: Int
    let name: String
    let completed: Bool
}

enum Visibility: Int {
    case Active
    case Completed
    case All
}

struct TodoApp {
    let todos: [Todo]
    let visibility: Visibility
}

extension TodoApp {
    var displayTodos: [Todo] {
        switch self.visibility {
        case .All: return self.todos
        case .Active: return self.todos.filter({!$0.completed})
        case .Completed: return self.todos.filter({$0.completed})
        }
    }
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
    return TodoApp(
        todos: todoReducer(s.todos, a),
        visibility: visibilityReducer(s.visibility, a)
    )
}
//: ### Store
let initialState = TodoApp(todos: [], visibility: .Active)
let store = Store(state: initialState, reducer: appReducer)


//: ### View
extension Todo : TodoRenderable {}

let todoVC = TodoViewController<Todo>(
    selection: {
        store.dispatch(.Toggle($0.id))
    }, newTodo: {
        store.dispatch(.AddTodo($0))
    }, visibilityChanged: {
        if let v = Visibility(rawValue: $0) {
            store.dispatch(.SetVisibility(v))
        }
})

func render(state: TodoApp) {
    todoVC.items = state.displayTodos
    todoVC.visibility.selectedSegmentIndex = state.visibility.rawValue
}

store.subscribe(render)
render(store.state)

import UIKit
import XCPlayground
todoVC.view.frame = CGRect(x: 0, y: 0, width: 320, height: 500)
XCPlaygroundPage.currentPage.liveView = todoVC.view
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true




//: [Keynote](@previous)
