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
    
    var itemArray = [Item]()
    let filePath  = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TodoItems.plist")

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        print(filePath!)
        
        loadData()
        
        // Do any additional setup after loading the view, typically from a nib.
        tableView.separatorStyle = .none
        
    }
    
    //MARK - Tableview Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        // if done == true add acessory type to checkmark else nono
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    //MARK - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        tableView.deselectRow(at: indexPath, animated: true)
        //setting row selected
        //change done property opposite to it on click
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveData()
    }
    
     //MARK - Add new Todo in List
    
    @IBAction func AddnewTodoItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController.init(title: "Add New Todoey", message: "", preferredStyle: .alert)
        var textField = UITextField()
        
        let actionAdd = UIAlertAction.init(title: "Add Item", style: .default) { (action) in
            
            let tempItem = Item()
            tempItem.title = textField.text!
            self.itemArray.append(tempItem)
            self.saveData()
           
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
       //MARK - Save Data Function
    func saveData()
    {
        do{
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.filePath!)
        }
        catch
        {
            print("error encoding data",error)
        }
         self.tableView.reloadData()
    }
    
    //MARK - Save Data Function
    func loadData() {
        if let data = try? Data(contentsOf: filePath!)
        {
            let decoder = PropertyListDecoder()
            do{
            itemArray = try decoder.decode([Item].self, from: data)
            }
            catch
            {
                print("Error in decoding in item array",error)
            }
        }
    }
}

