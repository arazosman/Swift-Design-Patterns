// MARK: Iterator Pattern
// Iterator is a behavioral design pattern that allows sequential
// traversal through a complex data structure without exposing its
// internal details.

struct Employee {
    let name: String
    let surname: String
    
    func printInfo() {
        print("\(name) \(surname)")
    }
}

class Staff: Sequence {
    private(set) var items = [Employee]()

    var count: Int {
        items.count
    }

    func append(_ item: Employee) {
        items.append(item)
    }

    func makeIterator() -> some IteratorProtocol {
        return StaffIterator(collection: self)
    }

//    func makeIterator() -> AnyIterator<Employee> {
//        var index = 0
//
//        return AnyIterator { [unowned self] in
//            guard index < items.count else {
//                return nil
//            }
//            defer { index += 1 }
//            return items[index]
//        }
//    }
}

class StaffIterator: IteratorProtocol {
    private let collection: Staff
    private var index = 0

    init(collection: Staff) {
        self.collection = collection
    }

    func next() -> Employee? {
        guard index < collection.items.count else {
            return nil
        }
        defer { index += 1 }
        return collection.items[index]
    }
}

let staff = Staff()

let ali = Employee(name: "Ali", surname: "Gün")
let veli = Employee(name: "Veli", surname: "Sabah")
let mehmet = Employee(name: "Mehmet", surname: "Gece")

staff.append(ali)
staff.append(veli)
staff.append(mehmet)

for employee in staff {
    print(employee)
}
