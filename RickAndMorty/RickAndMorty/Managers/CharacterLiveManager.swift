import Foundation

class CharacterManager {
    static let shared = CharacterManager()
    private(set) var killedCharacters: Set<Int> = Set([])
    
    func kill(_ character: Character) {
        killedCharacters.insert(character.id)
    }
    
    func status(of character: Character) -> String {
        return killedCharacters.contains(character.id) ? Character.LiveStatus.dead: character.status
    }
}
