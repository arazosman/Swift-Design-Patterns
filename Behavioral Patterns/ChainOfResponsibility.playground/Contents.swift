// MARK: Chain of Resposibility Pattern
// We use this pattern when we don't know who will be serving
// the request. The pattern would decide dynamically the server
// according to the type of the client.
// Example: Exception systems use this pattern via call chains.

protocol Customer {
    var name: String { get }
    var calltaker: CallTaker { get }
    init(name: String, calltaker: some CallTaker)
    func call()
    func askQuestion()
    func receiveAnswer()
}

extension Customer {
    func call() {
        calltaker.callFrom(customer: self)
    }

    func askQuestion() {
        print("\(name) asks a question.")
    }

    func receiveAnswer() {
        print("\(name) receives an asnwer.")
    }
}

final class StandardCustomer: Customer {
    let name: String
    let calltaker: CallTaker

    init(name: String, calltaker: some CallTaker) {
        self.name = name
        self.calltaker = calltaker
    }
}

final class GoldCustomer: Customer {
    let name: String
    let calltaker: CallTaker

    init(name: String, calltaker: some CallTaker) {
        self.name = name
        self.calltaker = calltaker
    }
}

final class VIPCustomer: Customer {
    let name: String
    let calltaker: CallTaker

    init(name: String, calltaker: some CallTaker) {
        self.name = name
        self.calltaker = calltaker
    }
}

protocol CallTaker {
    var next: CallTaker? { get }
    func callFrom(customer: some Customer)
}

class StandardCallTaker: CallTaker {
    let next: CallTaker?

    init(next: CallTaker?) {
        self.next = next
    }

    func callFrom(customer: some Customer) {
        if customer is StandardCustomer {
            customer.askQuestion()
            print("\(customer.name), thanks for calling the STANDARD customer services...")
            customer.receiveAnswer()
        } else {
            next?.callFrom(customer: customer)
        }
    }
}

class GoldCallTaker: CallTaker {
    let next: CallTaker?

    init(next: CallTaker?) {
        self.next = next
    }

    func callFrom(customer: some Customer) {
        if customer is GoldCustomer {
            customer.askQuestion()
            print("\(customer.name), thanks for calling the GOLD customer services...")
            customer.receiveAnswer()
        } else {
            next?.callFrom(customer: customer)
        }
    }
}

class VIPCallTaker: CallTaker {
    let next: CallTaker?

    init(next: CallTaker?) {
        self.next = next
    }

    func callFrom(customer: some Customer) {
        if customer is VIPCustomer {
            customer.askQuestion()
            print("\(customer.name), thanks for calling the VIP customer services...")
            customer.receiveAnswer()
        } else {
            next?.callFrom(customer: customer)
        }
    }
}

let vipCT = VIPCallTaker(next: nil)
let goldCT = GoldCallTaker(next: vipCT)
let standardCT = StandardCallTaker(next: goldCT)

let standardCustomer = StandardCustomer(name: "Ali", calltaker: standardCT)
let goldCustomer = GoldCustomer(name: "Kemal", calltaker: standardCT)
let vipCustomer = VIPCustomer(name: "Haldun", calltaker: standardCT)

standardCustomer.call()
goldCustomer.call()
vipCustomer.call()
