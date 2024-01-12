//
//  NetworkService.swift
//  salesManager
//
//  Created by Роман Кокорев on 12.12.2023.
//

import Foundation

class NetworkService {
    
    func request(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                completion(.success(data))
            }
        }.resume()
    }
}
