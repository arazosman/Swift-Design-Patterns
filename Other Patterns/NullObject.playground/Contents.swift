// MARK: Null Object Pattern
// We can use this pattern to provide an empty object instead
// of a nullable objects.

protocol Object {
    func request()
}

class RealObject: Object {
    func request() {
        print("Requesting data from server...")
    }
}

class NullObject: Object {
    func request() { }
}

let realObj = RealObject()
let nullObj = NullObject()

realObj.request()
nullObj.request()
