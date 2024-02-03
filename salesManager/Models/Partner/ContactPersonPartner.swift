//
//  ContactPersonPartner.swift
//  salesManager
//
//  Created by Роман Кокорев on 28.12.2023.
//

import Foundation

struct ContactPersonPartner: Codable {
    
    let uuid: String
    var name: String
    var position: String?
    var dateOfBirth: Date?
    var telephone: String?
    var email: String?
    var owner_uuid: String
    
    init(uuid: String, name: String, position: String? = nil, dateOfBirth: Date? = nil, telephone: String? = nil, email: String? = nil, owner_uuid: String) {
        self.uuid = uuid
        self.name = name
        self.position = position
        self.dateOfBirth = dateOfBirth
        self.telephone = telephone
        self.email = email
        self.owner_uuid = owner_uuid
    }
    
    init(entity: ContactPersonPartnerEntity) {
        self.uuid = entity.uuid ?? ""
        self.name = entity.name ?? ""
        self.position = entity.position
        self.dateOfBirth = entity.dateOfBirth
        self.telephone = entity.telephone
        self.email = entity.email
        self.owner_uuid = entity.owner_uuid ?? ""
    }
}
