//
//  SearchResponseUsers.swift
//  salesManager
//
//  Created by Роман Кокорев on 12.12.2023.
//

import Foundation

struct SearchResponse: Decodable {
    var resultCount: Int
    var results: [Track]
}

struct Track: Decodable {
    var trackName: String
    var collectionName: String?
    var artistName: String
    var artworkUrl60: String?
}

