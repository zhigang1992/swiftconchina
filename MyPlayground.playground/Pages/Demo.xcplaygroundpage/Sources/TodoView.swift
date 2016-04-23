import UIKit

public protocol TodoRenderable {
    var completed: Bool { get }
    var name: String { get }
}

public class TodoViewController<T: TodoRenderable> : UITableViewController {
    
    let selection: T -> Void
    let newTodo: String -> Void
    let visibilityChanged: Int -> Void
    
    public let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
    
    public let visibility = UISegmentedControl(items: ["Active", "Completed", "All"])
    
    public init(selection: T -> Void, newTodo: String -> Void, visibilityChanged: Int -> Void) {
        self.selection = selection
        self.newTodo = newTodo
        self.visibilityChanged = visibilityChanged
        
        super.init(style: .Plain)
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        textField.on(.EditingDidEndOnExit, action: { t, _ in
            self.newTodo(t.text ?? "")
            t.text = ""
        })
        textField.borderStyle = .RoundedRect
        textField.placeholder = "Add new todo here..."
        self.tableView.tableHeaderView = textField
        
        visibility.on(.ValueChanged, action: { s, _ in
            self.visibilityChanged(s.selectedSegmentIndex)
        })
        self.tableView.tableFooterView = visibility
    }
    
    public var items: [T] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let todo = self.items[indexPath.row]
        cell.textLabel?.textColor = todo.completed ? UIColor.lightGrayColor() : UIColor.blackColor()
        cell.textLabel?.text = todo.name
        return cell
    }
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selection(self.items[indexPath.row])
    }
}

