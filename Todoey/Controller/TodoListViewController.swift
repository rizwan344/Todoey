//
//  ViewController.swift
//  Todoey
//
//  Created by CH M Rizwan on 3/5/18.
//  Copyright © 2018 Developer34. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var SelectedCategory : Category? {
        didSet{
            loadData()
        }
    }
    let defaults = UserDefaults()
    let ARRAY_LIST_KEY = "array_list_key"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        searchBar.delegate = self
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
        //loadData()//loading data from sqlite db to array using deafult parameter of function
        
        // Do any additional setup after loading the view, typically from a nib.
        tableView.separatorStyle = .singleLine
        
    }
    
    //MARK: - Tableview Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        cell.textLabel?.textColor = UIColor.darkGray
        
        // if done == true add acessory type to checkmark else nono
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
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
    
    //MARK: - Add new Todo in List
    @IBAction func AddnewTodoItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController.init(title: "Add New Todoey", message: "", preferredStyle: .alert)
        var textField = UITextField()
        
        let actionAdd = UIAlertAction.init(title: "Add Item", style: .default) { (action) in
            
            
            let tempItem = Item(context: self.context)
            tempItem.title = textField.text!
            tempItem.done = false
            tempItem.parentCategory = self.SelectedCategory
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
    //MARK: - Save Data Function
    func saveData()
    {
        do{
            try self.context.save()
        }
        catch
        {
            print("error encoding data\(error)")
        }
        self.tableView.reloadData()
    }
    
    //MARK: - Save Data Function
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest() ,with predicate : NSPredicate? = nil) {//parameter from external request if external request is not provided using default one
        
        let predicate2 = NSPredicate(format: "parentCategory.name MATCHES %@", (SelectedCategory?.name!)!)// query contains categor
        
        if let additionalpredicate = predicate
        {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalpredicate,predicate2])
            request.predicate = compoundPredicate
        }else
        {
            request.predicate = predicate2
        }
        
        
        do{try self.itemArray = context.fetch(request)
            self.tableView.reloadData()
        }
        catch
        {print("errror loading data \(error)")}
    }
}

//MARK: - Extension for search bar methods
extension TodoListViewController: UISearchBarDelegate
{
    
    //MARK: - Search Bar delegate Methods
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadData()//reloading default all data
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()// request object
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)// query contains title
        //request.predicate = predicate // adding query to request
        let sortDescriptor = [NSSortDescriptor(key: "title", ascending: true)]//sorting on results
        request.sortDescriptors = sortDescriptor // appy sort on result
        loadData(with: request,with: predicate)//finally get result from request
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

