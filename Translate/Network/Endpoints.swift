//
//  Endpoints.swift
//  Translate
//
//  Created by Meeran Tariq on 11/06/2022.
//

import Foundation

struct Endpoint {
    
    // MARK: - Initialisers
    // Disable instance creation for this struct
    private init() { }
    
    // MARK: - Base URL
    private static let baseURL: String = "https://libretranslate.de"
    
    // MARK: - Endpoints
    static let languages: String = baseURL + "/languages"
    static let detect: String = baseURL + "/detect"
    static let translate: String = baseURL + "/translate"
}
