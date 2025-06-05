//
//  MyRecord.swift
//  surfSpot-front
//
//  Created by Giau Nguyen on 21/05/2025.
//


struct MyRecord: Identifiable, Codable {
    var id: Int
    var destination: String
    var description: String
    var address: String
    var country: String
    var difficultyLevel: Int
    var surfBreak: String
    var addedByUserId: Int
    var photo_url: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case destination
        case description
        case address
        case country
        case difficultyLevel = "difficulty_level"
        case surfBreak = "surf_breaks"
        case addedByUserId = "added_by_user_id"
        case photo_url
    }
}
