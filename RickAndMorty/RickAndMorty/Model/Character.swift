import Foundation

class Character:  Decodable {
    
    enum LiveStatus {
        static let dead = "Dead"
        static let alive = "Alive"
    }
    
    var id: Int
    var name: String
    var status: String
    var species: String
    var type: String
    var gender: String
    var image: String
    var origin: Origin
    var location: Location
    var created: Date
}

class Origin: Decodable {
    var name: String
    var url: String
}

class Location: Decodable {
    var name: String
    var url: String
}
