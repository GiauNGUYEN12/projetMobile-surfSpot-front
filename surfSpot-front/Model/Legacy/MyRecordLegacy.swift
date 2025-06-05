//
//  MyRecordLegacy.swift
//  surfSpot-front
//
//  Created by Giau Nguyen on 13/05/2025.
//

import Foundation

struct MyRecordLegacy: Identifiable {
    let id: String
    var destination: String
    var address: String
    var country: String
    var surfBreak: [String]
    var difficultyLevel: Int
    let photoURLs: [URL]
//    let url: String
}

extension MyRecordLegacy {
    init(_ record: RecordDTO) {
        self.id = record.id
        self.destination = record.fields.destination
        self.address = record.fields.address
        self.country = record.fields.country
        self.surfBreak = record.fields.surfBreak
        self.difficultyLevel = record.fields.difficultyLevel
        self.photoURLs = record.fields.photos.compactMap { URL(string: $0.url) }
    }
}
