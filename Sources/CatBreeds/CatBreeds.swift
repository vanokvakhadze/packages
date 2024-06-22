// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation



public class NetworkService {

    public enum NetworkError: Error {
        case decodeError
        case wrongResponse
        case wrongStatusCode(code: Int)
    }
    public init () { }
    
    
   public func getData<T: Decodable>(urlString: String, comletion: @escaping (Result<T,Error>) ->(Void)) {

        let url = URL(string: urlString)!

        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in

            if let error {
                print(error.localizedDescription)
            }

            guard let response = response as? HTTPURLResponse else {
                return
            }

            guard (200...299).contains(response.statusCode) else {
                print("wrong response")
                return
            }

            guard let data else { return }

            do {
                let decoder = JSONDecoder()
                let object = try decoder.decode(T.self, from: data)

                DispatchQueue.main.async {
                    comletion(.success(object))
                }
            } catch {
                comletion(.failure(NetworkError.decodeError))
            }
        }.resume()
    }
}
