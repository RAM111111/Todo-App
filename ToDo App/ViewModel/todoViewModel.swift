//
//  todoViewModel.swift
//  ToDo App
//
//  Created by R on 06/08/1443 AH.
//  Copyright © 1443 R. All rights reserved.
//
import RxSwift
import RxCocoa


extension BehaviorRelay {
    var val: Element {
        get { value }
        set { accept(newValue) }
    }
}

protocol toDoMenuItemViewPresentable {
    var title:String? { get set}
    var backColor:String? { get}
    var id:String? { get}
}

protocol toDoMenuItemViewDelegate{
    func onMenuItemSelected()->()
}

class ToDoMenuItemViewModel: toDoMenuItemViewPresentable ,toDoMenuItemViewDelegate{
    var id: String?
    var backColor: String?
    var title: String?
    weak var parent:todoItemViewDelegate?
    
    init(parentViewModel:todoItemViewDelegate) {
        self.parent = parentViewModel
    }
    init() {
    }
    
    func onMenuItemSelected() {
    }
    
}

class RemoveMenueItemViewModel:ToDoMenuItemViewModel{
    override func onMenuItemSelected() {
        print("RemoveMenueItemViewModel")
        parent?.onRemoveSelected()
    }
}

class DoneMenueItemViewModel:ToDoMenuItemViewModel{
    override func onMenuItemSelected() {
        print("DoneMenueItemViewModel")
        parent?.onDoneSelected()
    }
}


protocol todoPresentable{
    var id:String? { get}
    var textValue:String? {get}
    var isDone:Bool? {get set}
    var menuItem:[ToDoMenuItemViewModel]? {get}
    
}
protocol todoViewDelegate :class{
    func onTodoItemAded()->()
    func onTodoItemDeleted(todoID:String)->()
    func onTodoItemDone(todoID:String)->()
}
protocol todoItemViewDelegate:class {
    func onTodoItemSelected()->()
    func onDoneSelected()->()
    func onRemoveSelected()->()
    
    
}


class todoViewModel{
    
    var newTodoItem:String?
    var items:BehaviorRelay<[todoPresentable]> = BehaviorRelay(value: [])
    let database:TodoDB
    
    init(database:TodoDB = FirestoreDatabase.shared) {
        self.database = database
        setup(database: database)
    }
    
}
extension todoViewModel{
    func setup(database:TodoDB) -> Void {
        database.subscribe(completion: { (todoItem) in
            if let name = todoItem["name"] as? String,
                let id = todoItem["id"] as? String,
                let completed = todoItem["completed"] as? Bool{
                do{
                    if let index = self.items.val.firstIndex(where: {$0.id! == id}){
                        self.items.val[index] = todoItemViewModel(usingModel: try TodoItem(id: id, name: name, completed: completed),parentViewMode:self)
                    }else{
                        self.items.val.append(todoItemViewModel(usingModel: try TodoItem(id: id, name: name, completed: completed),parentViewMode:self))
                    }
                    self.items.val.sort(by: {!($0.isDone)! && $1.isDone!})
                    
                }catch{
                    print("error")
                }
            }
            
        }, deletion:{todoIt in
            print(todoIt)
            self.items.val.removeAll(where: {$0.id == todoIt["id"] as? String})
        })
    }
    
}


extension todoViewModel:todoViewDelegate{
    
    func onTodoItemDone(todoID: String) {
        print("onTodoItemDone\(todoID)")
        guard var vm = self.items.val.filter({$0.id! == todoID}).first else {
            print("Item Not Exist..!")
            return
        }
        print(vm)
        vm.isDone = !(vm.isDone ?? false)
        guard let id = vm.id,
            let name = vm.textValue,
            let completed = vm.isDone else{return}
        do{
            database.update(UsingTodoItem: try TodoItem(id: id, name: name, completed: completed))
        }catch{
            print("onTodoItemDone Err")
        }
        
    }
    
    func onTodoItemDeleted(todoID: String) {
        database.delete(UsingId: todoID)
    }
    
    func onTodoItemAded() {
        guard let newitem = newTodoItem else {
            print("onTodoItemAded / newitem : empty")
            return
        }
        do{
            let success = database.add(UsingTodoItem: try TodoItem(name: newitem))
            print("Added successfully \(success)")
        }catch {
            print("Added Failure..")
        }
        
        print(newitem)
        
    }
}

