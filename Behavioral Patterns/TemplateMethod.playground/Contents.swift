// MARK: Template Method Pattern
// Template method abtrasts common steps of an algorithm,
// and delegates the remained steps to the subclasses.
// It looks like the strategy pattern. But strategy pattern
// is fully abstract where the template method hase some
// abstract methods and some concrete methods (template
// methods)

import UIKit

// MARK: BaseViewController example

class BaseViewController: UIViewController {
    // Template method (common behaivor)
    override final func viewDidLoad() {
        super.viewDidLoad()
        layout()
        configure()
    }

    // Hook method (specialized method, will be implemented in sublcasses)
    func layout() { }

    // Hook method (specialized method, will be implemented in sublcasses)
    func configure() { }
}

// MARK: TestCase example

class TestCase {
    // Template method
    final func test() {
        setup()
        action()
        tearDown()
    }

    // Hook method
    func setup() { }

    // Hook method
    func action() { }

    // Hook method
    func tearDown() { }
}
