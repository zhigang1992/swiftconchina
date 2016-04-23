import UIKit

public class Projector: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        self.addGestureRecognizer(tap)
    }
    
    func tapped(gesture: UIGestureRecognizer) {
        print(gesture)
        let location = gesture.locationInView(self)
        let newIndex = location.x < bounds.width / 2 ? self.index - 1 : self.index + 1
        self.index = min(max(0, newIndex), self.slides.count - 1)
    }
    
    var index: Int = 0 {
        didSet {
            self.render()
        }
    }
    
    public var slides: [Slides] = [] {
        didSet {
            index = 0
        }
    }
    
    var currentSlide: UIView?
    func render() {
        self.currentSlide?.removeFromSuperview()
        let newSlide = self.slides[index].render()
        self.addSubview(newSlide)
        newSlide.frame = self.bounds
        self.currentSlide = newSlide
    }
}