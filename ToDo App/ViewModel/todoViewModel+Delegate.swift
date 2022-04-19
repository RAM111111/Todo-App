//
//  todoViewModel+Delegate.swift
//  ToDo App
//
//  Created by R on 15/08/1443 AH.
//  Copyright © 1443 R. All rights reserved.
//

import Foundation
class todoItemViewModel:todoPresentable{
    var id: String? = "0"
    var textValue: String?
    var isDone: Bool?  = false
    var menuItem: [ToDoMenuItemViewModel]? = []
    weak var parent:todoViewDelegate?
    
    init(id:String,textValue:String
        ,parentViewMode:todoViewDelegate
    ) {
        self.id = id
        self.textValue = textValue
        self.parent = parentViewMode
        createMenu(usingItemId:id)
        
    }
    init(usingModel model:TodoItem,parentViewMode:todoViewDelegate) {
        self.id = model.id
        self.isDone = model.completed
        self.textValue = model.name
        self.parent = parentViewMode
        createMenu(usingItemId:id!)
        
    }
    func createMenu(usingItemId:String) {
        
        let removeItem = RemoveMenueItemViewModel(parentViewModel: self)
        removeItem.id = usingItemId
        removeItem.title = "Remove"
        removeItem.backColor = "ff0000"
        
        let doneItem = DoneMenueItemViewModel(parentViewModel: self)
        doneItem.title = isDone! ? "Undone" : "Done"
        doneItem.backColor = "58a758"
        
        menuItem?.append(contentsOf: [removeItem,doneItem])
    }
    
}

extension todoItemViewModel:todoItemViewDelegate{
    func onDoneSelected() {
        parent?.onTodoItemDone(todoID: id!)
    }
    
    func onRemoveSelected() {
        parent?.onTodoItemDeleted(todoID: id!)
    }
    
    func onTodoItemSelected() {
        print(id!," Selected!")
    }
    
    
}
