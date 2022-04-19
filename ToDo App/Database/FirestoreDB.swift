//
//  FirestoreDB.swift
//  ToDo App
//
//  Created by R on 14/08/1443 AH.
//  Copyright © 1443 R. All rights reserved.
//

import FirebaseCore
import FirebaseFirestore
class FirestoreDatabase{
    
    private let FirebaseDB = Firestore.firestore()
    static let shared:FirestoreDatabase = FirestoreDatabase()
    private let todoCollection = "todos"
    
    private init(){}
}

extension FirestoreDatabase:TodoDB{

    

    
    func subscribe(completion: @escaping ([String : Any]) -> Void,deletion: @escaping ([String : Any]) -> Void) {
        FirebaseDB.collection(todoCollection).addSnapshotListener { (snapshoot, err) in
            guard let collection = snapshoot else {return}
            collection.documentChanges.forEach { (change) in
                    if change.type == .added{
                        let item = change.document.data()
                        completion(item)
                    }
                if change.type == .modified{
                    let item = change.document.data()
                    completion(item)
                }
                if change.type == .removed{
                    let item = change.document.data()
                    deletion(item)
                }

            }
            
        }
    }
    
    func add(UsingTodoItem todoItem: TodoItem) -> (Bool) {
        var returnValue :Bool = true
        let value = ["id":todoItem.id,"name":todoItem.name,"completed":todoItem.completed] as [String : Any]
        
        FirebaseDB.collection(todoCollection).addDocument(data: value) { (err) in
            if err != nil{
                print("added Item failure \(String(describing: err))")
                returnValue = false
            }
            print("added Item successfully...!")
            returnValue = true
        }
        return returnValue
    }
    
    func update(UsingTodoItem todoItem: TodoItem) {
        FirebaseDB.collection(todoCollection).whereField("id", isEqualTo: todoItem.id).getDocuments { (snapShoot, err) in
            let value = ["id":todoItem.id,"name":todoItem.name,"completed":todoItem.completed] as [String : Any]
            if err != nil{
                print(" Item Not found :\(String(describing: err))")
            }
            if let document = snapShoot?.documents.first{
                document.reference.setData(value) { (err) in
                    if err != nil{
                        print("Updated Item failure \(String(describing: err))")
                    }
                    print("Updated Item successfully...!")
                }
            }
        }
    }
    
    func delete(UsingId id: String) {
        FirebaseDB.collection(todoCollection).whereField("id", isEqualTo: id).getDocuments { (snapShoot, err) in
            
            if err != nil{
                print(" Item Not found :\(String(describing: err))")
            }
            if let document = snapShoot?.documents.first{
                document.reference.delete { (err) in
                    if err != nil{
                        print("deleted Item failure \(String(describing: err))")
                    }
                    print("deleted Item successfully...!")
                }
            }
        }
    }
    
    
}
