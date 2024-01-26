//
//  Partner.swift
//  salesManager
//
//  Created by Роман Кокорев on 26.01.2024.
//

import Foundation

struct Partner: Codable {
    
    var uuid: String
    var description: String
    
    init(uuid: String, description: String) {
        self.uuid = uuid
        self.description = description
    }
    
 /*   init(entity: PartnerEntity) {
        self.id = entity.id ?? ""
        self.name = entity.name ?? ""
        self.accessGroup = entity.accessGroup ?? ""
        self.typeOfRelationship = entity.typeOfRelationship ?? ""
        self.businessRegion = entity.businessRegion
        self.address = entity.address
        self.telephone = entity.telephone
        self.email = entity.email
    }   */
    
    
}
