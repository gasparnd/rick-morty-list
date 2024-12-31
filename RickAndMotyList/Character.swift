//
//  Character.swift
//  RickAndMotyList
//
//  Created by Gaspar Dolcemascolo on 30-12-24.
//

import Foundation

// MARK: - ApiResponse
struct ApiResponse: Codable {
    let info: Info
    let results: [Character]
}

// MARK: - Info
struct Info: Codable {
    let count, pages: Int
    let next: FlexibleString?
    let prev: FlexibleString?
}


// MARK: - Character
struct Character: Codable {
    let id: Int
    let name: String
    let status: Status
    let species: String
    let type: String
    let gender: Gender
    let origin, location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
    case unknown = "unknown"
    case genderless = "Genderless"
}

// MARK: - Location
struct Location: Codable {
    let name: String
    let url: String
}


enum Status: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}

// MARK: - Encode/decode helpe

enum FlexibleString: Codable {
    case string(String)
    case null
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            self = .null
        }
    }
    
    func value() -> String? {
        switch self {
        case .string(let value): return value
        case .null: return nil
        }
    }
}
