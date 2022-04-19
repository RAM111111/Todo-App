//
//  toDoDB.swift
//  ToDo App
//
//  Created by R on 14/08/1443 AH.
//  Copyright © 1443 R. All rights reserved.
//

protocol TodoDB {
    func add(UsingTodoItem todoItem:TodoItem) ->(Bool)
    func update(UsingTodoItem todoItem:TodoItem) ->(Void)
    func delete(UsingId id:String) ->(Void)
    func subscribe(completion:@escaping([String : Any]) -> Void,deletion:@escaping([String : Any]) -> Void) ->Void
}
