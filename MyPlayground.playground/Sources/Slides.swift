import UIKit

infix operator |> { associativity left precedence 90 }
func |> <A, B> (l: A, r: A -> B) -> B {
    return r(l)
}
infix operator <+> { associativity left precedence 110 }
func <+><A>(l: A->A, r: A->A) -> A->A {
    return { v in
        r(l(v))
    }
}

private let slideSize = CGSize(width: 1024, height: 768)

extension UIColor {
    convenience public init(_ hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}

let titleLabelStyle: UILabel -> UILabel = { l in
    l.textColor = UIColor(0x34A5DA)
    l.font = UIFont.boldSystemFontOfSize(150)
    l.adjustsFontSizeToFitWidth = true
    return l
}

let subtitleLabelStyle: UILabel -> UILabel = { l in
    l.textColor = UIColor(0xA6AAA9)
    l.font = UIFont.systemFontOfSize(45)
    l.adjustsFontSizeToFitWidth = true
    return l
}

let listTitleStyle: UILabel -> UILabel = { l in
    l.textColor = UIColor(0x34A5DA)
    l.font = UIFont.boldSystemFontOfSize(56)
    return l
}

let listContentStyle: UILabel -> UILabel = { l in
    l.textColor = UIColor(0x838787)
    l.font = UIFont.systemFontOfSize(34)
    return l
}

func useTitle(text: String) -> UILabel -> UILabel {
    return { l in
        l.text = text
        return l
    }
}

func useContentMode<T: UIView>(cm: UIViewContentMode) -> T -> T {
    return {
        $0.contentMode = cm
        return $0
    }
}

func useImage(image: UIImage) -> UIImageView -> UIImageView {
    return {
        $0.image = image
        return $0
    }
}

func useBackgroundColor(color: UIColor ) -> UIView -> UIView {
    return {
        $0.backgroundColor = color
        return $0
    }
}

func useLines(lines: Int) -> UILabel -> UILabel {
    return {
        $0.numberOfLines = lines
        return $0
    }
}

let useMultipleLines = useLines(0)

public struct Slides {
    public let render: () -> UIView
    
    public static func Title(text: String) -> Slides {
        return Slides {
            let view = master()
            view.addSubview(
                UILabel(frame: CGRect(x: 44, y: 250, width: 940, height: 150))
                    |> titleLabelStyle <+> useTitle(text)
            )
            return view
        }
    }
    public static func Title(text:String, subtitle: String) -> Slides {
        return Slides {
            let view = master()
            view.addSubview(
                UILabel(frame: CGRect(x: 40, y: 508, width: 940, height: 150))
                    |> titleLabelStyle <+> useTitle(text)
            )
            view.addSubview(
                UIView(frame: CGRect(x: 30, y: 480, width: 960, height: 3))
                    |> useBackgroundColor(UIColor(0xA6AAA9))
            )
            view.addSubview(
                UILabel(frame: CGRect(x: 40, y: 420, width: 940, height: 56))
                    |> subtitleLabelStyle <+> useTitle(subtitle)
            )
            return view
        }
    }
    public static func Image(image: UIImage) -> Slides {
        return Slides {
            let imageView = UIImageView()
                |> useContentMode(.ScaleAspectFit) <+> useImage(image)
            imageView.sizeToFit()
            return imageView
        }
    }
    public static func Image(image: String) -> Slides {
        return self.Image(UIImage(named: image)!)
    }
    public static func List(title: String, items: [String]) -> Slides {
        return Slides {
            let view = master()
            view.addSubview(
                UIView(frame: CGRect(x: 30, y: 78, width: 960, height: 3))
                    |> useBackgroundColor(UIColor(0xA6AAA9))
            )
            view.addSubview(
                UILabel(frame: CGRect(x: 30, y: 122, width: 960, height: 60))
                    |> useTitle(title) <+> listTitleStyle
            )
            let itemsText = items.map({"• \($0)"}).joinWithSeparator("\n\n")
            view.addSubview(
                UILabel(frame: CGRect(x: 30, y: 208, width: 960, height: 500))
                    |> useTitle(itemsText) <+> listContentStyle <+> useMultipleLines
            )
            return view
        }
    }
}

extension Slides {
    static func master() -> UIView {
        let container = UIView(frame: CGRect(origin: .zero, size: slideSize))
        container.backgroundColor = UIColor(0x222222)
        return container
    }
}

