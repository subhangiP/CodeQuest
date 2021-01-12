//
//  SearchModal.swift
//  CodeQuest
//
//  Created by Subhangi Pawar on 10/01/21.
//

import Foundation

struct SearchModal : Codable {
    
    let page : Int?
    var results : [Result]?
    let totalPages : Int?
    let totalResults : Int?
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try values.decodeIfPresent(Int.self, forKey: .page)
        results = try values.decodeIfPresent([Result].self, forKey: .results)
        totalPages = try values.decodeIfPresent(Int.self, forKey: .totalPages)
        totalResults = try values.decodeIfPresent(Int.self, forKey: .totalResults)
    }
}
