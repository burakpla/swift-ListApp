//
//  ViewController.swift
//  Listeleme
//
//  Created by Burak Pala on 27.01.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var data = [NSManagedObject]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedObject = appDelegate?.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Liste")
        data =  try! (managedObject?.fetch(request) as? [NSManagedObject])!
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let listItem = data[indexPath.row]
        cell.textLabel?.text = listItem.value(forKey: "title") as? String
        return cell
        
    }
    
    
    @IBAction func trashButton(_ sender: UIBarButtonItem) {
        
        data.removeAll()
        tableView.reloadData()
        
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        presentAddAlert()
}
    func presentAddAlert(){
        
        let alertController = UIAlertController(title: "Yeni Eleman Ekle", message: nil, preferredStyle: .alert)
        
        let alertButton = UIAlertAction(title: "Ekle", style: .default){ _ in
            let text = alertController.textFields?.first?.text
            if text != ""{
                //self.data.append((text)!)
                
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                
                let managedObject = appDelegate?.persistentContainer.viewContext
                
                let entity = NSEntityDescription.entity(forEntityName: "Liste", in: managedObject!)
                let Liste = NSManagedObject(entity: entity!, insertInto: managedObject)
                
                Liste.setValue(text, forKey: "title")
                try? managedObject?.save()
                self.tableView.reloadData()
            }else{
                self.presentWarnAlert()
            }
            
    }
        let cancelAlert = UIAlertAction(title: "Vazgeç", style: .cancel)
        
    present(alertController, animated: true)
        alertController.addTextField()
    alertController.addAction(alertButton)
    alertController.addAction(cancelAlert)

    }
    func presentWarnAlert(){
       presentAlert(title: "Uyarı!", message: "Listeye boş eleman eklenemez", cancelAlertTitle: "TAMAM")
    }
    func presentAlert(title: String?, message: String?, preferredStyle: UIAlertController.Style = .alert, cancelAlertTitle: String?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let cancel = UIAlertAction(title: cancelAlertTitle, style: .cancel)

        
        let cancelAlert = UIAlertAction(title: "TAMAM", style: .cancel)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "Sil") { _, _, _ in
            self.data.remove(at: indexPath.row)
            tableView.reloadData()
        }
        deleteAction.backgroundColor = .systemRed
        
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
    }
}
