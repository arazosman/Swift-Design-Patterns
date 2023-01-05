// MARK: Classes

struct Person {
    let name: String
    let age: Int

    func talkTo(primeMinister: PrimeMinister) {
        primeMinister.talkTo(with: self)
    }
}

let ali = Person(name: "Ali", age: 24)
let veli = Person(name: "Veli", age: 55)
let ayse = Person(name: "Ayşe", age: 30)

protocol PrimeMinister {
    func talkTo(with person: Person)
}

class RealPrimeMinister: PrimeMinister {
    func talkTo(with person: Person) {
        print("(REAL PM) I am listening to you, \(person.name)...")
    }
}

protocol Secretary {
    func getPrimeMinister() -> PrimeMinister
}

class BadSecretary {
    private let primeMinister = RealPrimeMinister()

    func getPrimeMinister() -> PrimeMinister {
        return primeMinister
    }
}

let badSecretary = BadSecretary()

ali.talkTo(primeMinister: badSecretary.getPrimeMinister())
veli.talkTo(primeMinister: badSecretary.getPrimeMinister())
ayse.talkTo(primeMinister: badSecretary.getPrimeMinister())

// MARK: Using the Proxy object to protect the real object

class PrimeMinisterProxy: PrimeMinister {
    let primeMinister: PrimeMinister
    let index: Int

    init(primeMinister: PrimeMinister, index: Int) {
        self.primeMinister = primeMinister
        self.index = index
    }

    func talkTo(with person: Person) {
        print("(PROXY PM #\(index) I am listening to you, \(person.name)...")
        directToRealPrimeMinisterIfNeeded(person: person)
    }

    private func directToRealPrimeMinisterIfNeeded(person: Person) {
        if person.age > 50 {
            primeMinister.talkTo(with: person)
        }
    }
}

class GoodSecretary: Secretary {
    private let primeMinister = RealPrimeMinister()

    private lazy var primeMinisterProxies = [
        PrimeMinisterProxy(primeMinister: primeMinister, index: 0),
        PrimeMinisterProxy(primeMinister: primeMinister, index: 1),
        PrimeMinisterProxy(primeMinister: primeMinister, index: 2),
        PrimeMinisterProxy(primeMinister: primeMinister, index: 3),
        PrimeMinisterProxy(primeMinister: primeMinister, index: 4)
    ]

    func getPrimeMinister() -> PrimeMinister {
        let randomIndex = Int.random(in: 0 ..< primeMinisterProxies.count)
        return primeMinisterProxies[randomIndex]
    }
}

let goodSecretary = GoodSecretary()

ali.talkTo(primeMinister: goodSecretary.getPrimeMinister())
veli.talkTo(primeMinister: goodSecretary.getPrimeMinister())
ayse.talkTo(primeMinister: goodSecretary.getPrimeMinister())

print("---------")

// MARK: Network example:

protocol Network {
    func https(url: String)
    func email(address: String, message: String)
}

/// Real object
class Gateway: Network {
    func https(url: String) {
        print("Connecting to \(url)...")
    }

    func email(address: String, message: String) {
        print("Sending e-mail to \(address)...")
    }
}

/// Proxy object
class Proxy: Network {
    private let gateway: Network

    init(gateway: Network) {
        self.gateway = gateway
    }

    func https(url: String) {
        guard isGatweayAvailable() else {
            print("Network is not available...")
            return
        }
        guard isSecure(url: url) else {
            print("Connection is not secure for \(url)")
            return
        }
        gateway.https(url: url)
    }

    func email(address: String, message: String) {
        guard isGatweayAvailable() else {
            print("Network is not available...")
            return
        }
        guard !hasSwears(message: message) else {
            print("Message could not be send due to swears in it.")
            return
        }
        gateway.email(address: address, message: message)
    }

    func isGatweayAvailable() -> Bool {
        return Int.random(in: 0 ..< 5) > 0
    }

    func isSecure(url: String) -> Bool {
        return url.starts(with: "https")
    }

    func hasSwears(message: String) -> Bool {
        return message.contains("fck")
    }
}

class NetworkServer {
    private let gateway = Gateway()
    private lazy var proxy = Proxy(gateway: gateway)

    func getNetwork() -> Network {
        return proxy
    }
}

class Client {
    func https(url: String, network: Network) {
        network.https(url: url)
    }

    func email(address: String, message: String, network: Network) {
        network.email(address: address, message: message)
    }
}

let server = NetworkServer()
let client = Client()

client.https(url: "https://google.com", network: server.getNetwork())
client.https(url: "http://crazysite.net", network: server.getNetwork())

client.email(address: "ali@hotmail.com", message: "How are you?", network: server.getNetwork())
client.email(address: "veli@gmail.com", message: "Man, fck you!", network: server.getNetwork())

print("---------")

// MARK: Proxy pattern also can be used for lazy loading heavy objects.
// Known as Virtual Proxy

protocol Image {
    func draw()
}

class RealImage: Image {
    func draw() {
        print("Image is being printed...")
    }
}

/// Virtual Proxy
class ProxyImage: Image {
    lazy var realImage = RealImage()

    func draw() {
        realImage.draw()
    }
}

class Document {
    var text: String?
    var image: Image?
}

let document = Document()
document.text = "Ali"
document.image = ProxyImage()

// After a while...
document.image?.draw()
