//
//  TodoItemTableViewCell.swift
//  ToDo App
//
//  Created by R on 06/08/1443 AH.
//  Copyright © 1443 R. All rights reserved.
//

import UIKit

class TodoItemTableViewCell: UITableViewCell {

    @IBOutlet weak var toDoText: UILabel!
    @IBOutlet weak var toDoIndex: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(withViewModel viewModel:todoPresentable){
        toDoIndex.text = viewModel.id
        let attributeString = NSMutableAttributedString(string: viewModel.textValue!)
        let range = NSRange(location: 0, length: attributeString.length)
        if viewModel.isDone!{
            attributeString.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.lightGray, range: range)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: range)
            attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range: range)

        }
        toDoText.attributedText =  attributeString
        

        
    }
    
}
