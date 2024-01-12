//
//  NetworkManager.swift
//  salesManager
//
//  Created by Роман Кокорев on 26.12.2023.
//

import Foundation

class NetworkManager {
    
    //let defaults = UserDefaults.standard
    
    private let baseURL = UserDefaults.standard.string(forKey: "serverAdress") ?? ""
    private let userLogin = UserDefaults.standard.string(forKey: "userLogin") ?? ""
    private let userPassword = UserDefaults.standard.string(forKey: "userPassword") ?? ""
    
    //let networkService = NetworkService()
        
    enum HTTPMethod: String {
        case POST
        case PUT
        case GET
        case DELETE
    }
    
    enum APIs: String {
        case partners
        case coldClients
        case contactPersonPartner
        case search
    }
    
    enum Headers: String {
        case ContentLengh = "Content-Lengdh"
        case ContentType = "Content-Type"
        case Path = "application/json"
    }
    
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
        
    func getAllPartners(_ complitionHandler: @escaping ([Partner]) -> Void) {
        if let url = URL(string: baseURL + APIs.partners.rawValue) {
            
            request(url: url) { (result) in
                switch result {
                case .success(let data):
                    do {
                        let partners = try JSONDecoder().decode([Partner].self, from: data)
                        complitionHandler(partners)
                    } catch let jsonError {
                        print("Failed to decode JSON", jsonError)
                        complitionHandler([])
                    }
                case .failure(let error):
                    print("Error received requesting data: \(error.localizedDescription)")
                    complitionHandler([])
                }
            }
            
    /*        URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("error in request")
                } else {
                    if let resp = response as? HTTPURLResponse, resp.statusCode == 200, let responseData = data {
                        let partners = try? JSONDecoder().decode([Partner].self, from: responseData)
                        
                        complitionHandler(partners ?? [])
                    }
                }
                
            }.resume()  */
        }
    }
    
    func postCreatePartner(_ partner: Partner, complitionHandler: @escaping (Partner) -> Void) {
        
        let sendData = try? JSONEncoder().encode(partner)
        
        guard let url = URL(string: baseURL + APIs.partners.rawValue), let data = sendData else { return }
        
        let requestURL = MutableURLRequest(url: url)
        requestURL.httpMethod = HTTPMethod.POST.rawValue
        requestURL.httpBody = data
        requestURL.setValue("\(data.count)", forHTTPHeaderField: "Content-Lengh")
        requestURL.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: requestURL as URLRequest) { (data, response, error) in
            
            if error != nil {
                print("error")
            } else if let resp = response as? HTTPURLResponse, resp.statusCode == 201, let responseData = data {
                
                if let responsePartner = try? JSONDecoder().decode(Partner.self, from: responseData) {
                    complitionHandler(responsePartner)
                }
            }
        }.resume()
    }
    
    func getContactPersonBy(partner: Partner, complitionHandler: @escaping ([ContactPersonPartner]) -> Void) {
        guard let url = URL(string: baseURL + APIs.contactPersonPartner.rawValue) else { return }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "partner", value: "\(partner)")]
        
        guard let queryURL = components?.url else { return }
        
        request(url: queryURL) { (result) in
            switch result {
            case .success(let data):
                do {
                    let contactPerson = try JSONDecoder().decode([ContactPersonPartner].self, from: data)
                    complitionHandler(contactPerson)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    complitionHandler([])
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                complitionHandler([])
            }
        }
        
  /*      URLSession.shared.dataTask(with: queryURL) { data, response, error in
            if error != nil {
                print("error getContactPersonBy")
            } else if let resp = response as? HTTPURLResponse, resp.statusCode == 200, let reciveData = data {
                let contactPerson = try? JSONDecoder().decode([ContactPersonPartner].self, from: reciveData)
                
                complitionHandler(contactPerson ?? [])
            }
        }.resume()  */
    }
    
    func getTrack(_ complitionHander: @escaping (SearchResponse?) -> Void) {
        if let url = URL(string: baseURL + APIs.search.rawValue) {
            
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = [URLQueryItem(name: "term", value: "50 cent"), URLQueryItem(name: "limit", value: "5")]
            
            guard let queryURL = components?.url else { return }
                        
            request(url: queryURL) { (result) in
                switch result {
                case .success(let data):
                    do {
                        let tracks = try JSONDecoder().decode(SearchResponse.self, from: data)
                        complitionHander(tracks)
                    } catch let jsonError {
                        print("Failed to decode JSON", jsonError)
                        complitionHander(nil)
                    }
                case .failure(let error):
                    print("Error received requesting data: \(error.localizedDescription)")
                    complitionHander(nil)
                }
            }
        }
    }
    
}

