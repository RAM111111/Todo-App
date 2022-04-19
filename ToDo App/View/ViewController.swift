//
//  ViewController.swift
//  ToDo App
//
//  Created by R on 06/08/1443 AH.
//  Copyright © 1443 R. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    var viewModel:todoViewModel?
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var textfeild: UITextField!
    let identifier = "TodoItemTableViewID"
    let  disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = todoViewModel()
        
        viewModel?.items.asObservable().bind(to: tableview.rx.items(cellIdentifier: identifier, cellType: TodoItemTableViewCell.self)){index,item,cell in
            cell.configure(withViewModel: item)
        }.disposed(by: disposeBag)

        
        let nib = UINib(nibName: "TodoItemTableViewCell", bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: identifier)
//        tableview.dataSource = self
        tableview.delegate = self

    }

    @IBAction func onAddItem(_ sender: UIButton) {
        guard let newTodoValue = textfeild.text,!newTodoValue.isEmpty else{
            print("newTodoValue Failure...")
            return
        }
        viewModel?.newTodoItem = newTodoValue
        
        
        DispatchQueue.global(qos: .background).async {
            self.viewModel?.onTodoItemAded()

        }
    }
    
}

extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemViewModel = viewModel?.items.value[indexPath.row] as! todoItemViewModel
        itemViewModel.onTodoItemSelected()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let itemViewModel = viewModel?.items.value[indexPath.row]
        var menuActions:[UIContextualAction] = []
        _ = itemViewModel?.menuItem?.map({ menuitem in
            
            let menuAction = UIContextualAction(style: .normal, title:menuitem.title) { (action, view, success) in
                      DispatchQueue.global(qos: .background).async {
                          menuitem.onMenuItemSelected()
                      }
                success(true)
            }
            menuAction.backgroundColor = UIColor(hex: menuitem.backColor!)
            menuActions.append(menuAction)

        })
        

        return UISwipeActionsConfiguration(actions: menuActions)
    }
}


