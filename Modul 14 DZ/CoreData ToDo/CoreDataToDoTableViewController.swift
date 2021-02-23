//
//  CoreDataToDoTableViewController.swift
//  Modul 14 DZ
//
//  Created by Vladimir Karsakov on 10.01.2021.
//

import UIKit
import CoreData

class CoreDataToDoTableViewController: UITableViewController {
    
    var tasks = [Tasks]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //добираемся до файла AppDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //получаем context
        let context = appDelegate.persistentContainer.viewContext
        //запрос по таск сущности, который обращается к БД и просит вернуть все сущности Tasks
        let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        //выполняем этот запрос
        do{
            //сохраняем все полученные результаты в массив tasks
            tasks = try context.fetch(fetchRequest)
        } catch{
            print(error.localizedDescription)
        }
    }
    
    @IBAction func addNewTaskButton(_ sender: Any) {
        alertNewTask()
    }
    
    func alertNewTask(){
        //создаем алерт
        let alert = UIAlertController(title: "Новая задача", message: "Пожалуйста, заполните поля", preferredStyle: .alert)
        
        var alertTextField1: UITextField!
        alert.addTextField { (textField) in
            alertTextField1 = textField
            textField.placeholder = "Введите заголовок"
        }
        var alertTextField2: UITextField!
        alert.addTextField { (textField2) in
            alertTextField2 = textField2
            textField2.placeholder = "Введите подзаголовок"
        }
        
        let alertSaveButton = UIAlertAction(title: "Сохранить", style: .default) { (SaveButton) in
            guard let title = alertTextField1.text, !title.isEmpty else { return }
            guard let subtitle = alertTextField2.text, !subtitle.isEmpty else { return }
            
            self.saveTask(title: title, subtitle: subtitle)
            self.tableView.reloadData()
        }
        
        let alertCancelButton = UIAlertAction(title: "Отменить", style: .destructive, handler: nil)
        
        alert.addAction(alertSaveButton)
        alert.addAction(alertCancelButton)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveTask(title: String, subtitle: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //создаем контекст
        let context = appDelegate.persistentContainer.viewContext
        //создаем сущность
        let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: context)
        //создаем объект
        let taskObject = NSManagedObject(entity: entity!, insertInto: context) as! Tasks
        taskObject.title = title
        taskObject.subtitle = subtitle
        //сохраняем объект в контексте
        do{
            //сохраняем объект
            try context.save()
            //добавляем элементы в массив
            tasks.append(taskObject)
            print("Saved")
        } catch{
            print(error.localizedDescription)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellCoreData", for: indexPath) as! CoreDataToDoTableViewCell
        cell.titleLabel.text = tasks[indexPath.row].title
        cell.subtitleLabel.text = tasks[indexPath.row].subtitle
        
        cell.accessoryType = tasks[indexPath.row].done == true ? .checkmark : .none
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            let item = tasks[indexPath.row]
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(item)
            
            do{
                try context.save()
                tasks.remove(at: indexPath.row)
                print("Delete")
            } catch{
                print(error.localizedDescription)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        tasks[indexPath.row].done = !tasks[indexPath.row].done
        do{
            try context.save()
            
        } catch{
            print(error.localizedDescription)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
