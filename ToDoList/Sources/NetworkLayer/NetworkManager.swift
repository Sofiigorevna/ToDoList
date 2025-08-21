//
//  NetworkManager.swift
//  ToDoList
//
//  Created by sofiigorevna on 21.08.2025.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    func getTodosList(completion: @escaping(Result<TodosResponse, Error>) -> ()) {
        networkService(endpoint: .todos, completion: completion)
    }
    
    private init() {}
}

private extension NetworkManager {
    func networkService<T: Codable>(endpoint: Endpoints, completion: @escaping(Result<T, Error>) -> ()) {
        requestData(request: endpoint, completion: completion)
    }
    
    func requestData<T: Codable>(request: NetworkRequest, completion: @escaping(Result<T, Error>) -> ()) {
        let url = request.baseURL.appendingPathComponent(request.path)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.add(parameters: request.parameters)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(error ?? NSError(domain: "", code: -1, userInfo: nil)))
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

extension URLRequest {
    mutating func add(parameters: Parameters) {
        switch parameters {
            case .none: break
            case .url(let dictionary):
                guard let url = url, var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { break }
                components = components.setParameters(dictionary)
                self.url = components.url
            case .json(let dictionary):
                httpBody = try? JSONSerialization.data(withJSONObject: dictionary)
            case .formData(let dictionary):
                httpBody = URLComponents().setParameters(dictionary).query?.data(using: .utf8)
            case .data(let data, _):
                httpBody = data
        }
    }
}

extension URLComponents {
    func setParameters(_ parameters: [String: Any]) -> URLComponents {
        var urlComponents = self
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) }
        return urlComponents
    }
}
