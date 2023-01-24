// MARK: State Pattern
// We use this pattern to manage an object with different states.
// Without this pattern, we would need to have lots if conditional
// statements when we would change behaviors of the object for its
// states.

class Account {
    var balance: Int
    var status: AccountStatus

    init(balance: Int, status: AccountStatus) {
        self.balance = balance
        self.status = status
    }

    func withdraw(amount: Int) {
        status.withdraw(amount: amount)

        /* We would need nasty conditional statements without State pattern:
        if isActive {
            ...
        } else if isClosed {
            ...
        } else if isFrozen {
            ...
        } */
    }

    func deposit(amount: Int) {
        status.deposit(amount: amount)
    }

    func transfer(amount: Int) {
        status.transfer(amount: amount)
    }

    func close() {
        status.close()
    }
}

protocol AccountStatus {
    var account: Account { get }
    init(account: some Account)
    func withdraw(amount: Int)
    func deposit(amount: Int)
    func transfer(amount: Int)
    func close()
}

final class ActiveAccountStatus: AccountStatus {
    var account: Account

    init(account: some Account) {
        self.account = account
    }

    func withdraw(amount: Int) {
        account.balance -= amount

        if account.balance < 0 {
            account.status = FrozenAccountStatus(account: account)
        }
    }

    func deposit(amount: Int) {
        account.balance += amount
    }

    func transfer(amount: Int) {
        // ...
    }

    func close() {
        // ...
    }
}

final class FrozenAccountStatus: AccountStatus {
    var account: Account

    init(account: some Account) {
        self.account = account
    }

    func withdraw(amount: Int) { /* ... */ }

    func deposit(amount: Int) { /* ... */ }

    func transfer(amount: Int) { /* ... */ }

    func close() { /* ... */ }
}
