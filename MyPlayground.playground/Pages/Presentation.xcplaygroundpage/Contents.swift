Slides.Title("Redux in Swift".uppercaseString, subtitle: "iOS Architech").render()
//Quiz No.1: "大中枢派发" 是啥？


























Slides.Image("MVC").render()
// Distribution: Bad
// Testable: Bad
// Easy to use: Good































Slides.Image("MVP").render()
// Distribution: Okay
// Testable: Good
// Easy to use: Okay





















Slides.Image("MVVM").render()
// Distribution: Okay
// Testable: Good
// Easy to use: Okay
























Slides.Image("VIPER").render()
// Distribution: Great
// Testable: Good
// Easy to use: Not a all



























Slides.Image("Redux").render()





































Slides.Title("Application data", subtitle: "State").render()
// Immutable



































Slides.Title("Predefined behaviour", subtitle: "Action").render()

// Finite actions
// Predictable behaviour






























Slides.Title("State, Action -> State", subtitle: "Reducer").render()
// Pure Function
// Quiz 2: Why is it call reducer?
// Water break



















Slides.Title("Reducer and State Container",subtitle: "Store").render()




































//: [Show Me the Code](@next)
































Slides.Image("Redux").render()
// Distribution: Okay
// Testable: Great
// Easy to use: Good




































Slides.List("Pros and Cons", items: [
    "Statically Typed swift",
    "Need to Provide Initial State",
    "One Unified Store",
    "Relatively new in iOS"
]).render()








































Slides.List("Kens", items: [
    "Animations & Routing",
    "Sometimes Fighting Against the Frameworks",
    "Lack of Virtual DOM from React",
    "..."
]).render()



















































//: ![TimeTravel](timetravel.mp4)
// State Time Travel
// Free offline mode
// Free state recovery






















谢谢











