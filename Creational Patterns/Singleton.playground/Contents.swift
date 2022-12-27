import Foundation

// MARK: NON-THREAD-SAFE Singleton

class Singleton {
    private var count: Double
    private var numOfCreatedInstances: Int = 0

    // Static properties are lazy loaded by default.
    // The creation is thread-safe, unlike lazy properties.
    // Note that, only the creation of the shared object
    // is thread-safe. So there will be only one
    // created instance in multi-threaded environments.
    // But the instance itself is not thread-safe.
    static let shared = Singleton()

    private init() {
        count = 1
        numOfCreatedInstances += 1
    }

    // Not thread safe.
    func incrementCount(id: Int = 0) {
        count *= 1.1
        print("") // added to break the atmoicness in all cases
        count += 1
    }

    func getCount() -> Double {
        return count
    }

    func getNumOfCreatedInstances() -> Int {
        return numOfCreatedInstances
    }
    
    func reset() {
        count = 1
    }
}

// MARK: Printing in a single-threaded environment for NON-THREAD-SAFE singleton

for _ in 0 ..< 100 {
    Singleton.shared.incrementCount()
}

Singleton.shared.getCount()
Singleton.shared.getNumOfCreatedInstances()

// MARK: Printing in a multi-threaded environment for NON-THREAD-SAFE singleton

Singleton.shared.reset()

class MyThread: Thread {
    let id: Int
    
    init(id: Int) {
        self.id = id
        super.init()
    }

    override func main() {
        Singleton.shared.incrementCount(id: id)
    }
}

Task {
    for i in 0 ..< 100 {
        let thread = MyThread(id: i)
        thread.start()
    }

    try await Task.sleep(nanoseconds: 1_000_000_000)

    Singleton.shared.getCount() // OUTPUT IS VARIABLE, NOT THREAD SAFE.
    Singleton.shared.getNumOfCreatedInstances() // instance creating is thread safe, since it is static
}

// MARK: THREAD-SAFE Singleton with NSLock

class ThreadSafeSingletonWithNSLock {
    private let lock = NSLock()
    private var count: Double

    static let shared = ThreadSafeSingletonWithNSLock()

    private init() {
        count = 1
    }

    func incrementCount() {
        lock.lock()
        defer { lock.unlock() }
        count *= 1.1
        print("") // added to break the atmoicness in all cases
        count += 1
    }

    func getCount() -> Double {
        lock.lock()
        defer { lock.unlock() }
        return count
    }
}

class MyThread2: Thread {
    override func main() {
        ThreadSafeSingletonWithNSLock.shared.incrementCount()
    }
}

Task {
    for _ in 0 ..< 100 {
        let thread = MyThread2()
        thread.start()
    }

    try await Task.sleep(nanoseconds: 1_000_000_000)
    
    ThreadSafeSingletonWithNSLock.shared.getCount()
}

// MARK: THREAD-SAFE Singleton with Serial Queue

class ThreadSafeSingletonWithSerialQueue {
    private let serialQueue = DispatchQueue(label: "serialQueue")
    private var count: Double
    
    static let shared = ThreadSafeSingletonWithSerialQueue()

    private init() {
        count = 1
    }

    func incrementCount() {
        serialQueue.sync {
            count *= 1.1
            print("") // added to break the atmoicness in all cases
            count += 1
        }
    }
    
    func getCount() -> Double {
        var value: Double = 0

        serialQueue.sync {
            value = count
        }

        return value
    }
}

class MyThread3: Thread {
    override func main() {
        ThreadSafeSingletonWithSerialQueue.shared.incrementCount()
    }
}

Task {
    for _ in 0 ..< 100 {
        let thread = MyThread3()
        thread.start()
    }

    try await Task.sleep(nanoseconds: 1_000_000_000)

    ThreadSafeSingletonWithSerialQueue.shared.getCount()
}

// MARK: THREAD-SAFE Singleton with Concurrent Queue (more performant)

class ThreadSafeSingletonWithConcurrentQueue {
    private let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
    private var count: Double
    
    static let shared = ThreadSafeSingletonWithConcurrentQueue()

    private init() {
        count = 1
    }

    func incrementCount() {
        concurrentQueue.async(flags: .barrier) {
            self.count *= 1.1
            print("") // added to break the atmoicness in all cases
            self.count += 1
        }
    }
    
    func getCount() -> Double {
        var value: Double = 0

        concurrentQueue.sync {
            value = count
        }

        return value
    }
}

class MyThread4: Thread {
    override func main() {
        ThreadSafeSingletonWithConcurrentQueue.shared.incrementCount()
    }
}

Task {
    for _ in 0 ..< 100 {
        let thread = MyThread4()
        thread.start()
    }

    try await Task.sleep(nanoseconds: 1_000_000_000)

    ThreadSafeSingletonWithConcurrentQueue.shared.getCount()
}
