import Foundation

typealias CompletionHandlerCharacter = (_ character: Character?, _ error: Error?) -> Void

final class CharacterService: APIManager {
    func fetchCharacters(id: String, completion: @escaping CompletionHandlerCharacter) {
        let path = "character/" + id
        fetch(path: path) { (data, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601)
            do {
                let character = try jsonDecoder.decode(Character.self, from: data)
                completion(character, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
}

