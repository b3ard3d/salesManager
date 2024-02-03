//
//  ContactPersonColdClient.swift
//  salesManager
//
//  Created by Роман Кокорев on 11.01.2024.
//

import Foundation

struct ContactPersonColdClient: Codable {
    
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
    
    init(entity: ContactPersonColdClientEntity) {
        self.uuid = entity.uuid ?? ""
        self.name = entity.name ?? ""
        self.position = entity.position
        self.dateOfBirth = entity.dateOfBirth
        self.telephone = entity.telephone
        self.email = entity.email
        self.owner_uuid = entity.owner_uuid ?? ""
    }
    
}
