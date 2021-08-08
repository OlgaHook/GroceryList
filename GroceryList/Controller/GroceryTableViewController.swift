//
//  GroceryTableViewController.swift
//  GroceryList
//
//  Created by olga.krjuckova on 06/08/2021.
//

import UIKit

/*After  Grocery(class) and Atributes were created in CoreData ->GroceryList.xcdatamodeld-> import
*/
import CoreData




class GroceryTableViewController: UITableViewController {
    
    /* After Entity Grocery were created -> var groceries = [String]() we dont need any mone, replace with var groceries = [Grocery]()
     
     */
    //var groceries = [String]()
      var groceries = [Grocery]()
    /* we need acess Manage object contect with type of NSManageObjectContext
     */
    var manageObjectContext: NSManagedObjectContext?
    
     
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* to load here var manageObjectContext: NSManagedObjectContext?
         we need to access AppDelegate
         */
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        manageObjectContext = appDelegate.persistentContainer.viewContext
        
        // Need to load data -> run created func
    }
    
    func loadData(){
        let request: NSFetchRequest<Grocery> = Grocery.fetchRequest()
        do{
    //'do' must always have 'try'
            let result = try manageObjectContext?.fetch(request)
    //inside here we put everything that we can fetch.Forced (!) result as it is optional
            groceries = result!
    // and we need to reload Data
            tableView.reloadData()
            
        }catch{
            //here we can print any error message examp (" ")
            fatalError("Error in retrieving Grocery items")
        }
        
    }
    //to save all in basket added shopping items -> func
    func saveData(){
        do{
            try manageObjectContext?.save()
        }catch{
            fatalError("Error in saving Grocery item")
        }
        //after saving data -> run func loadData
        loadData()
        
    }
    
    func deleteData(){
       let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Grocery")
        let request : NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do{
            try manageObjectContext?.execute(request)
            saveData()
        }catch let error {
            print(error.localizedDescription)
        }
        
    }
   
    @IBAction func deleteAllData(_ sender: Any) {
        
        let allertContrDelete = UIAlertController(title: "Delete All", message: "Do you want to delete All?", preferredStyle: .alert)
    
        let deleteConfirmButton = UIAlertAction(title:"Delete All", style: .destructive)
        allertContrDelete.addAction(deleteConfirmButton)
        
        let cancelDeleteAllButton = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        allertContrDelete.addAction(cancelDeleteAllButton)
        
        present(allertContrDelete, animated: true, completion: nil)
        
        deleteData()
        //run func deleteData
        
    }
    
    
    @IBAction func addNewShoppingItem(_ sender: Any) {
      //creating Allert Pop Up controller
        let allertController = UIAlertController(title: "Grocery Item", message: "What do you want to add?", preferredStyle: .alert)
        //to add a textField on a top of Allert controller
        allertController.addTextField{ textField in
            print (textField)
        }
        //add button for any action inside Allert PopUp message
        
        let addActionButton = UIAlertAction(title: "Add", style: .default) { alertAction in
            let textField = allertController.textFields?.first
            //to save in our Grocery class (entity) we need to access it
            let entity = NSEntityDescription.entity(forEntityName: "Grocery", in: self.manageObjectContext!)
            let grocery = NSManagedObject(entity: entity!, insertInto: self.manageObjectContext)
            grocery.setValue(textField?.text, forKey: "item")
           
            self.saveData()
            
            //to put all we gonna type in groceries (forced)
           /* Took off self.  after var groceries = [Grocery]()
             self.groceries.append(textField!.text!)
            self.tableView.reloadData()
 */
        }
        // addAction
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        allertController.addAction(addActionButton)
        allertController.addAction(cancelButton)
        
        //present what we have in Allert PopUp
        present(allertController, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groceries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCell", for: indexPath)

       // cell.textLabel?.text = groceries[indexPath.row]
        
        let grocery = groceries[indexPath.row]
        cell.textLabel?.text = grocery.value(forKey: "item") as? String
        // = grocery.completed ? ->means IF COMPLETED use .checkmark : -> IF NOT COMPLETED use .none
        cell.accessoryType = grocery.completed ? .checkmark : .none
         
        return cell
    }
    
    // MARK: - Table view DELEGATE
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            manageObjectContext?.delete(groceries[indexPath.row])
        }
        self.saveData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        groceries[indexPath.row].completed = !groceries[indexPath.row].completed
        self.saveData()
        
    }

}
