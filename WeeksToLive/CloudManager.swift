//
//  CloudManager.swift
//  WeeksToLive
//
//  Created by Joey on 1/9/17.
//  Copyright © 2017 NelsonJE. All rights reserved.
//

import Foundation
import CloudKit


struct CloudManager {
    
    let privateDB = CKContainer.default().privateCloudDatabase

    
    
//    func fetchResolutions(completion: @escaping ([Resolution]) -> Void) {
//        
//        let pred = NSPredicate(value: true)
//        let query = CKQuery(recordType: "Resolution", predicate: pred)
//        privateDB.perform(query, inZoneWith: nil, completionHandler: { records, error in
//            if let _ = error {
//                print(error!)
//                return
//            }
//            
//            guard let resRecords = records else {
//                completion([])
//                return
//            }
//            
//            var resolutions = [Resolution]()
//            for record in resRecords {
//                let fetchedRes = Resolution(id: record["ID"] as! String,
//                                            name: record["Name"] as! String,
//                                            recurrence: record["Recurrence"] as! String,
//                                            frequency: record["Frequency"] as! Int64,
//                                            notes: record["Notes"] as! String,
//                                            current: record["Current"] as! Int64)
//                resolutions.append(fetchedRes)
//            }
//            
//            completion(resolutions)
//        })
//    }
//    
//    func modifyResolution(res: Resolution, completion: @escaping () -> Void) {
//        privateDB.fetch(withRecordID: CKRecordID(recordName: res.id), completionHandler: { record, error in
//            if let _ = error {
//                print(error!)
//                return
//            }
//            
//            if let resRecord = record {
//                resRecord["Name"] = res.name as CKRecordValue
//                resRecord["ID"] = res.id as CKRecordValue
//                resRecord["Recurrence"] = res.recurrence as CKRecordValue
//                resRecord["Frequency"] = res.frequency as CKRecordValue
//                resRecord["Current"] = res.current as CKRecordValue
//                resRecord["Notes"] = res.notes as CKRecordValue
//                
//                self.privateDB.save(resRecord, completionHandler: { savedRecord, error in
//                    if let _ = error {
//                        print(error!)
//                        return
//                    }
//                    print("successfully saved resolution")
//                    
//                    completion()
//                })
//            }
//            
//            completion()
//            
//        })
//    }
//    
//    func saveResolution(res: Resolution, completion: @escaping () -> Void) {
//        
//        var id = ""
//        
//        if res.id == "" {
//            id = randomAlphaNumericString(length: idLength)
//        } else {
//            id = res.id
//        }
//        
//        let resRecordID = CKRecordID(recordName: id)
//        let resRecord = CKRecord(recordType: "Resolution", recordID: resRecordID)
//        
//        resRecord["Name"] = res.name as CKRecordValue
//        resRecord["ID"] = id as CKRecordValue
//        resRecord["Recurrence"] = res.recurrence as CKRecordValue
//        resRecord["Frequency"] = res.frequency as CKRecordValue
//        resRecord["Current"] = res.current as CKRecordValue
//        resRecord["Notes"] = res.notes as CKRecordValue
//        
//        
//        privateDB.save(resRecord, completionHandler: { savedRecord, error in
//            if let _ = error {
//                print(error!)
//                return
//            }
//            print("successfully saved resolution")
//            
//            completion()
//        })
//    }
//    
//    func deleteResolution(res: Resolution, completion: @escaping () -> Void) {
//        //use res.id to find CKRecord to delete
//        
//        privateDB.fetch(withRecordID: CKRecordID(recordName: res.id), completionHandler: { record, error in
//            if let _ = error {
//                print(error!)
//                return
//            }
//            
//            if let resRecord = record {
//                let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [resRecord.recordID])
//                
//                operation.savePolicy = .allKeys
//                operation.modifyRecordsCompletionBlock = { added, deleted, error in
//                    if error != nil {
//                        print(error!)
//                    } else {
//                        completion()
//                        print("successfully deleted record")
//                    }
//                }
//                self.privateDB.add(operation)
//            }
//        })
//    }
}
