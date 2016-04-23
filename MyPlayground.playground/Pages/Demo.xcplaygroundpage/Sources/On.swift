import UIKit
import ObjectiveC

public protocol Onable {
    
}

private class DummyTarget: NSObject {
    let action:UIControlEvents -> Void
    init(action:UIControlEvents -> Void) {
        self.action = action
    }
    @objc func execute(event:UIControlEvents) {
        self.action(event)
    }
}

private var callbackStoreKey:UInt8 = 0

private extension UIControl {
    var callbacks:[UInt: DummyTarget] {
        get {
            return objc_getAssociatedObject(self, &callbackStoreKey) as? [UInt: DummyTarget] ?? [:]
        }
        set {
            objc_setAssociatedObject(self, &callbackStoreKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UIControl : Onable {}

extension Onable where Self : UIControl {
    public func on(event:UIControlEvents, action:(Self, UIControlEvents) -> Void) {
        let dummyTarget = DummyTarget(action: {
            action(self, $0)
        })
        self.addTarget(dummyTarget, action: #selector(DummyTarget.execute(_:)), forControlEvents: event)
        self.callbacks[event.rawValue] = dummyTarget
    }
    public func off(event:UIControlEvents) {
        guard let dummyTarget = self.callbacks[event.rawValue] else { return }
        self.removeTarget(dummyTarget, action: #selector(DummyTarget.execute(_:)), forControlEvents: event)
        self.callbacks[event.rawValue] = nil
    }
}
