//
//  Request.swift
//  Translate
//
//  Created by Meeran Tariq on 11/06/2022.
//

import Foundation

func makeRequest(to endPoint: String, method: String,
                 params: [URLQueryItem]? = nil, completion: @escaping (Data) -> ()) {
    
    guard var urlComponents = URLComponents(string: endPoint) else {
        return
    }
    
    if let queryItems = params {
        urlComponents.queryItems = queryItems
    }
    
    guard let url = urlComponents.url else {
        return
    }
    
    let request = NSMutableURLRequest(url: url)
    request.httpMethod = method
    
    
    URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
        guard data != nil else {
            print("no data found: \(String(describing: error))")
            return
        }
        guard error == nil else {
            print(error ?? "Encountered an error!")
            return
        }
        
        DispatchQueue.main.async {
            completion(data!)
        }
    }.resume()
}
