//
//  NetworkService.swift
//  NewsApp
//
//  Created by danil.tsirkunov  on 18.07.2023.
//

import Foundation

final class NetworkService {
    func request(completion: @escaping (Data?, Error?) -> Void) {
        let urlString = Constants.baseURL + Config.apiKey
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "com.urlConvert.app",
                                code: 0,
                                userInfo: [NSLocalizedDescriptionKey: "Error converting text to URL"])
            completion(nil, error)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func createDataTask( from reqest: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        URLSession.shared.dataTask(with: reqest) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                if let response = response as? HTTPURLResponse {
                    let statusCode = response.statusCode
                    switch statusCode {
                    case 200:
                        completion(data, nil)
                    default:
                        let error = NSError(domain: "com.httpErrorResponse.app",
                                            code: 0,
                                            userInfo: [NSLocalizedDescriptionKey: "Error response"])
                        completion(nil, error)
                    }
                } else {
                    let error = NSError(domain: "com.network.app",
                                        code: 0,
                                        userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP Response"])
                    completion(nil, error)
                }
            }
        }
    }
}

fileprivate extension Constants {
    static let baseURL = "https://newsdata.io/api/1/news?country=us&apikey="
}
