//
//  Model.swift
//  ToDo App
//
//  Created by R on 14/08/1443 AH.
//  Copyright © 1443 R. All rights reserved.
//

import Foundation

struct TodoItem: Codable{
    let id:String
    let name:String
    let completed:Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case completed
    }
    
    init(id:String = UUID().uuidString,name:String,completed:Bool = false) throws {
        self.id = id
        self.name = name
        self.completed = completed
    }
}
