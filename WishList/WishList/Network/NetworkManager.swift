//
//  NetworkManager.swift
//  WishList
//
//  Created by Layla Cisneros on 13/02/2023.
//

import Foundation

struct NetworkManager {
    
    func createRequest(resource: String, method: String, parameters: [String:String]? = nil) -> URLRequest {
        guard let url = URL(string: "\(Configuration.baseUrl)\(resource)") else {
            return URLRequest(url: URL(string:"")!)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        if let parameters = parameters {
            request.httpBody = try? JSONEncoder().encode(parameters)
        }
        return request
    }
    
    func executeRequest(request: URLRequest, completionHandler: @escaping (Data?, String?) -> Void){
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler(nil, Configuration.genericErrorMessage)
                return
            }
            if httpResponse.statusCode == 200 {
                guard let data = data else {
                    completionHandler(nil, Configuration.genericErrorMessage)
                    return
                }
                completionHandler(data, nil)
            } else {
                guard let data = data,
                      let errorDictionary = try? JSONDecoder().decode([String:String].self, from: data) else {
                    completionHandler(nil, Configuration.genericErrorMessage)
                    return
                }
                completionHandler(nil, errorDictionary["error"] ?? Configuration.genericErrorMessage)
            }
        }.resume()
    }
    
}
