//
//  MovieCastModal.swift
//  CodeQuest
//
//  Created by Subhangi Pawar on 11/01/21.
//

import Foundation

struct MovieCastModal : Codable {
    
    let cast : [Cast]?
    let crew : [Crew]?
    let id : Int?
    
    enum CodingKeys: String, CodingKey {
        case cast = "cast"
        case crew = "crew"
        case id = "id"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cast = try values.decodeIfPresent([Cast].self, forKey: .cast)
        crew = try values.decodeIfPresent([Crew].self, forKey: .crew)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
    }
    
}

struct Crew : Codable {
    
    let adult : Bool?
    let creditId : String?
    let department : String?
    let gender : Int?
    let id : Int?
    let job : String?
    let knownForDepartment : String?
    let name : String?
    let originalName : String?
    let popularity : Float?
    let profilePath : String?
    
    enum CodingKeys: String, CodingKey {
        case adult = "adult"
        case creditId = "credit_id"
        case department = "department"
        case gender = "gender"
        case id = "id"
        case job = "job"
        case knownForDepartment = "known_for_department"
        case name = "name"
        case originalName = "original_name"
        case popularity = "popularity"
        case profilePath = "profile_path"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        adult = try values.decodeIfPresent(Bool.self, forKey: .adult)
        creditId = try values.decodeIfPresent(String.self, forKey: .creditId)
        department = try values.decodeIfPresent(String.self, forKey: .department)
        gender = try values.decodeIfPresent(Int.self, forKey: .gender)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        job = try values.decodeIfPresent(String.self, forKey: .job)
        knownForDepartment = try values.decodeIfPresent(String.self, forKey: .knownForDepartment)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        originalName = try values.decodeIfPresent(String.self, forKey: .originalName)
        popularity = try values.decodeIfPresent(Float.self, forKey: .popularity)
        profilePath = try values.decodeIfPresent(String.self, forKey: .profilePath)
    }
}

struct Cast : Codable {
    
    let adult : Bool?
    let castId : Int?
    let character : String?
    let creditId : String?
    let gender : Int?
    let id : Int?
    let knownForDepartment : String?
    let name : String?
    let order : Int?
    let originalName : String?
    let popularity : Float?
    let profilePath : String?
    
    enum CodingKeys: String, CodingKey {
        case adult = "adult"
        case castId = "cast_id"
        case character = "character"
        case creditId = "credit_id"
        case gender = "gender"
        case id = "id"
        case knownForDepartment = "known_for_department"
        case name = "name"
        case order = "order"
        case originalName = "original_name"
        case popularity = "popularity"
        case profilePath = "profile_path"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        adult = try values.decodeIfPresent(Bool.self, forKey: .adult)
        castId = try values.decodeIfPresent(Int.self, forKey: .castId)
        character = try values.decodeIfPresent(String.self, forKey: .character)
        creditId = try values.decodeIfPresent(String.self, forKey: .creditId)
        gender = try values.decodeIfPresent(Int.self, forKey: .gender)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        knownForDepartment = try values.decodeIfPresent(String.self, forKey: .knownForDepartment)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        order = try values.decodeIfPresent(Int.self, forKey: .order)
        originalName = try values.decodeIfPresent(String.self, forKey: .originalName)
        popularity = try values.decodeIfPresent(Float.self, forKey: .popularity)
        profilePath = try values.decodeIfPresent(String.self, forKey: .profilePath)
    }
}
