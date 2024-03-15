//
//  MeetingStatusEntity.swift
//  salesManager
//
//  Created by Роман Кокорев on 12.03.2024.
//

import Foundation
import CoreData

class MeetingStatusEntity: NSManagedObject {
    
    class func findOrCreate(_ meetingStatus: MeetingStatus, context: NSManagedObjectContext) throws -> MeetingStatusEntity {
        
        if let meetingStatusEntity = try? MeetingStatusEntity.find(uuid: meetingStatus.uuid, context: context) {
            return meetingStatusEntity
        } else {
            let meetingStatusEntity = MeetingStatusEntity(context: context)
            meetingStatusEntity.uuid = meetingStatus.uuid
            meetingStatusEntity.name = meetingStatus.name
            return meetingStatusEntity
        }
    }
    
    class func all(_ context: NSManagedObjectContext) throws -> [MeetingStatusEntity] {
        
        let request: NSFetchRequest<MeetingStatusEntity> = MeetingStatusEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            throw error
        }
    }
    
    class func find(uuid: String, context: NSManagedObjectContext) throws -> MeetingStatusEntity? {
        
        let request: NSFetchRequest<MeetingStatusEntity> = MeetingStatusEntity.fetchRequest()
        request.predicate = NSPredicate(format: "uuid like %@", uuid)
        
        do {
            let fetchResult = try context.fetch(request)
            if fetchResult.count > 0 {
                assert(fetchResult.count == 1, "Duplicate has been found in DB")
                return fetchResult[0]
            }
        } catch {
            throw error
        }
        
        return nil
    }
}
