// MARK: Observer pattern
// Observer pattern is used for listenin events.
// Observable / Publisher
// Observer / Subscriber

// MARK: Classical approach

protocol Publication {
    var name: String { get }
    var subscribers: [Subscriber] { get }
    func addSubscriber(_ subscriber: Subscriber)
    func publish()
}

extension Publication {
    func publish() {
        for subscriber in subscribers {
            print("\(name) sent to \(subscriber.name).")
            subscriber.receive(publication: self)
        }
    }
}

class NatGeo: Publication {
    let name = "National Geoghrapic"

    var subscribers = [Subscriber]()

    func addSubscriber(_ subscriber: Subscriber) {
        print("\(name) has a new subscriber: \(subscriber.name).")
        subscribers.append(subscriber)
    }
}

class GQ: Publication {
    let name = "GQ"

    var subscribers = [Subscriber]()

    func addSubscriber(_ subscriber: Subscriber) {
        print("\(name) has a new subscriber: \(subscriber.name).")
        subscribers.append(subscriber)
    }
}

protocol Subscriber {
    var name: String { get }
    func subscribe(publication: Publication)
    func receive(publication: Publication)
}

class IndividualSubscriber: Subscriber {
    let name: String

    init(name: String) {
        self.name = name
    }

    func subscribe(publication: Publication) {
        print("\(name) subscribed to \(publication.name).")
        publication.addSubscriber(self)
    }

    func receive(publication: Publication) {
        print("\(name) received \(publication.name).")
    }
}

let natGeo = NatGeo()
let gq = GQ()

let ali = IndividualSubscriber(name: "Ali")
ali.subscribe(publication: natGeo)

let veli = IndividualSubscriber(name: "Veli")
veli.subscribe(publication: natGeo)
veli.subscribe(publication: gq)

natGeo.publish()
gq.publish()

// MARK: Modern approach
// Combine or RxSwift can be used for the modern declarative approach.
