import Foundation

typealias CompletionHandlerAPI = (_ data: Data?, _ error: Error?) -> Void

class APIManager {

    private let baseURL = "https://rickandmortyapi.com/api/"
    
    func fetch(path: String, completion: @escaping CompletionHandlerAPI
        ) {
        let urlString = baseURL + path
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
            }
            if let data = data {
                completion(data, nil)
            }
        }
        task.resume()
    }
}
