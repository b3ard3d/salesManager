//
//  Partner.swift
//  salesManager
//
//  Created by Роман Кокорев on 26.12.2023.
//

import Foundation

struct Partner1: Codable {
    
    var id: String
    var name: String
    var accessGroup: String
    var typeOfRelationship: String
    var businessRegion: String?
    var address: String?
    var telephone: String?
    var email: String?
    
    
    init(id: String, name: String, accessGroup: String, typeOfRelationship: String, businessRegion: String? = nil, address: String? = nil, telephone: String? = nil, email: String? = nil) {
        self.id = id
        self.name = name
        self.accessGroup = accessGroup
        self.typeOfRelationship = typeOfRelationship
        self.businessRegion = businessRegion
        self.address = address
        self.telephone = telephone
        self.email = email
    }
    
    init(entity: PartnerEntity) {
        self.id = entity.id ?? ""
        self.name = entity.name ?? ""
        self.accessGroup = entity.accessGroup ?? ""
        self.typeOfRelationship = entity.typeOfRelationship ?? ""
        self.businessRegion = entity.businessRegion
        self.address = entity.address
        self.telephone = entity.telephone
        self.email = entity.email
    }
    
    
}
