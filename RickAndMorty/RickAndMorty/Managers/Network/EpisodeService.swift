import Foundation

typealias CompletionHandlerEpisode = (_ episodes: [Episode], _ error: Error?) -> Void

final class EpisodeService: APIManager {
    func fetchEpisodes(completion: @escaping CompletionHandlerEpisode) {
        fetch(path: "episode") { (data, error) in
            guard let data = data else {
                completion([], error)
                return
            }            
            let jsonDecoder = JSONDecoder()
            do {
                let episodes = try jsonDecoder.decode(Episodes.self, from: data)
                completion(episodes.results, nil)
                
            } catch {
                completion([], error)
            }
        }
    }
}
