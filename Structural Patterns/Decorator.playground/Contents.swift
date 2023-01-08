// MARK: Classes

class BadToast {
    // ...
}

class BadCheeseToast: BadToast {
    // ...
}

class BadSausageToast: BadToast {
    // ...
}

class BadTomatoToast: BadToast {
    // ...
}

class BadCheeseAndSausageToast: BadToast {
    // ...
}

class BadCheeseAndSausageAndTomatoToast: BadToast {
    // ...
}

// MARK: Decorator Pattern
// It's useful when we want to add new responsibilities to classes
// without affecting other classes and without using inheritance.
// Example: InputStream in Java.
// Without using Decorator pattern, we would need N! subclasses for
// N features. With Decorator pattern, we need only N subclasses.

protocol Toastable {
    var price: Int { get }
    var totalPrice: Int { get }
    var toppings: [Topping] { get }
}

extension Toastable {
    func printInfo() {
        print("Total price: $\(totalPrice)")

        for topping in toppings {
            print("- \(topping.name) $\(topping.price)")
        }
    }
}

protocol Topping: Toastable {
    var toastable: Toastable { get }
    var name: String { get }
    init(toastable: Toastable, price: Int)
}

extension Topping {
    var totalPrice: Int {
        price + toastable.totalPrice
    }

    var toppings: [Topping] {
        [self] + toastable.toppings
    }
}

class ToastBread: Toastable {
    let price: Int
    var toppings = [Topping]()

    var totalPrice: Int {
        price
    }

    init(price: Int) {
        self.price = price
    }
}

final class CheeseTopping: Topping {
    let toastable: Toastable
    let price: Int
    let name = "Cheese"

    init(toastable: Toastable, price: Int) {
        self.toastable = toastable
        self.price = price
    }
}

final class SausageTopping: Topping {
    let toastable: Toastable
    let price: Int
    let name = "Sausage"

    init(toastable: Toastable, price: Int) {
        self.toastable = toastable
        self.price = price
    }
}

final class TomatoTopping: Topping {
    let toastable: Toastable
    let price: Int
    let name = "Tomato"

    init(toastable: Toastable, price: Int) {
        self.toastable = toastable
        self.price = price
    }
}

var toastWithCheeseAndSausage: Toastable = ToastBread(price: 5)
toastWithCheeseAndSausage = CheeseTopping(toastable: toastWithCheeseAndSausage, price: 2)
toastWithCheeseAndSausage = SausageTopping(toastable: toastWithCheeseAndSausage, price: 3)
toastWithCheeseAndSausage.printInfo()

var toastWithTomatoAndSausage: Toastable = ToastBread(price: 5)
toastWithTomatoAndSausage = TomatoTopping(toastable: toastWithTomatoAndSausage, price: 1)
toastWithTomatoAndSausage = SausageTopping(toastable: toastWithTomatoAndSausage, price: 3)
toastWithTomatoAndSausage.printInfo()

var toastWithTomatoAndSausageAndCheese: Toastable = ToastBread(price: 5)
toastWithTomatoAndSausageAndCheese = TomatoTopping(toastable: toastWithTomatoAndSausageAndCheese, price: 1)
toastWithTomatoAndSausageAndCheese = SausageTopping(toastable: toastWithTomatoAndSausageAndCheese, price: 3)
toastWithTomatoAndSausageAndCheese = CheeseTopping(toastable: toastWithTomatoAndSausageAndCheese, price: 2)
toastWithTomatoAndSausageAndCheese.printInfo()
