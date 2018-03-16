//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by CH M Rizwan on 3/15/18.
//  Copyright © 2018 Developer34. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    
    var catArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        loadData()//loading categoies
        tableView.separatorStyle = .singleLine
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    }

    //MARK: - adding new category 
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let actionAdd = UIAlertAction(title: "Add", style: .default) { (action) in
            let catItem = Category(context: self.context)
            catItem.name = textField.text!
            self.catArray.append(catItem)
            self.savecategories()
        }
        alert.addTextField { (alerttextField) in
            textField = alerttextField
            alerttextField.placeholder = "Enter catergory name"
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(actionAdd)
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - saving data into database
    func savecategories()
    {
        do{
            try context.save()
            tableView.reloadData()
        }
        catch{
            print("saving categories Error \(error)")
        }
    }
    //MARK: - Loading data into aray from database
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest())
    {
        do{
            try catArray = context.fetch(request)
            tableView.reloadData()
        }
        catch
        {
               print("Error loading data \(error)")
        }
    
    }
}
extension CategoryTableViewController:UITabBarDelegate
{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = catArray[indexPath.row].name
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        cell.textLabel?.textColor = UIColor.orange
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catArray.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "GoToItems", sender: self)
        
        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "GoToItems") as! TodoListViewController
        //vc.category = catArray[indexPath.row]
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToItems"
        {
            let destinationVC = segue.destination as! TodoListViewController
            let indexPath = tableView.indexPathForSelectedRow
            destinationVC.SelectedCategory = catArray[(indexPath?.row)!]
        }
    }
    
}
