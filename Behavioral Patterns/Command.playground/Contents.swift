// MARK: Command Pattern
// Command pattern is a generalized version of Strategy pattern.
// It abstracts a job in a class instead of just in a method.
// Command pattern is an object oriented replacements for callbacks.
// While strategy patetrn abstracts an algorithm, command pattern
// abstracts a request. Thus, it is generic by nature.

class Account {
    private(set) var amount: Int
    private var transactions = [Transaction]()

    enum Error: Swift.Error {
        case notEnoughBalance
    }

    init(amount: Int) {
        self.amount = amount
    }

    func deposit(amount: Int) {
        self.amount += amount
    }

    func withdraw(amount: Int) throws {
        guard self.amount >= amount else {
            throw Error.notEnoughBalance
        }

        self.amount -= amount
    }

    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
    }
}

protocol Transaction {
    var account: Account { get }
    var amount: Int { get }
    func execute(amount: Int)
    func undo()
    init(account: Account)
}

final class Deposit: Transaction {
    let account: Account
    var amount: Int = 0

    init(account: Account) {
        self.account = account
    }

    func execute(amount: Int) {
        self.amount = amount
        account.deposit(amount: amount)
        account.addTransaction(self)
    }

    func undo() {
        do {
            try account.withdraw(amount: amount)
            account.addTransaction(self)
        } catch {
            print("Not enough balance...")
        }
    }
}

final class Withdraw: Transaction {
    let account: Account
    var amount: Int = 0

    init(account: Account) {
        self.account = account
    }

    func execute(amount: Int) {
        self.amount = amount

        do {
            try account.withdraw(amount: amount)
            account.addTransaction(self)
        } catch {
            print("Not enough balance...")
        }
    }

    func undo() {
        account.deposit(amount: amount)
        account.addTransaction(self)
    }
}

let account = Account(amount: 1000)

let withdrawTransaction = Withdraw(account: account)
print(account.amount)
withdrawTransaction.execute(amount: 100)
print(account.amount)
withdrawTransaction.undo()
print(account.amount)

let depositTransaction = Deposit(account: account)
print(account.amount)
depositTransaction.execute(amount: 100)
print(account.amount)
depositTransaction.undo()
print(account.amount)
