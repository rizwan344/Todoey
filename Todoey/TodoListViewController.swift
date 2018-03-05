//
//  ViewController.swift
//  Todoey
//
//  Created by CH M Rizwan on 3/5/18.
//  Copyright © 2018 Developer34. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let defaults = UserDefaults()
    let ARRAY_LIST_KEY = "array_list_key"
    
    var itemArray = ["Find Milk","Buy Eggs","Use Pay Load"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.separatorStyle = .none
        if let items = defaults.array(forKey: ARRAY_LIST_KEY) as? [String]
        {
            itemArray = items
        }
    }
    
    //MARK - Tableview Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        tableView.deselectRow(at: indexPath, animated: true)
        //setting row selected
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
        }
        else
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
        }
    }
    
     //MARK - Add new Todo in List
    
    @IBAction func AddnewTodoItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController.init(title: "Add New Todoey", message: "", preferredStyle: .alert)
        var textField = UITextField()
        
        let actionAdd = UIAlertAction.init(title: "Add Item", style: .default) { (action) in
            self.itemArray.append(textField.text!)
            self.tableView.reloadData()
            self.defaults.set(self.itemArray, forKey: self.ARRAY_LIST_KEY)
        }
        let actionCanel = UIAlertAction.init(title: "Cancel", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addTextField { (alertTexField) in
            textField = alertTexField
            alertTexField.placeholder = "Enter new item here"
        }
        
        alert.addAction(actionAdd)
        alert.addAction(actionCanel)
        
        present(alert, animated: true, completion: nil)
        
        
    }
}

