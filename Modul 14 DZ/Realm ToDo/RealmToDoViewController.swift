
import UIKit
import RealmSwift
//класс для создания моделей (реалм)
@objcMembers
class TasksList: Object{
    dynamic var title = ""
    dynamic var subtitle = ""
    dynamic var done = false
}

class RealmToDoViewController: UIViewController {
    
    private let realm = try! Realm()
    var items: Results<TasksList>!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //обращаемся к БД
        items = realm.objects(TasksList.self)
    }
    //добавить новую запись в toDo лист
    @IBAction func addButton(_ sender: Any) {
        addAlertForNewWrite()
    }
    
    func addAlertForNewWrite(){
        //создаем алерт
        let alert = UIAlertController(title: "Новая задача", message: "Пожалуйста, заполните поля", preferredStyle: .alert)
        
        //создаем текстовые поля для алерта
        var alertTextField: UITextField!
        alert.addTextField { (textField) in
            alertTextField = textField
            textField.placeholder = "Введите заголовок"
        }
        var alertTextField2: UITextField!
        alert.addTextField { (textField) in
            alertTextField2 = textField
            textField.placeholder = "Введите подзаголовок"
        }
        //создаем кнопки для алерта
        let actionSave = UIAlertAction(title: "Сохранить", style: .default) { (action) in
            guard let title = alertTextField.text, !title.isEmpty else { return }
            guard let subtitle = alertTextField2.text, !subtitle.isEmpty else { return }
            let task = TasksList()
            task.title = title
            task.subtitle = subtitle
            
            //Добавляем в БД значения
            try! self.realm.write{
                self.realm.add(task)
            }
            self.tableView.reloadData()
        }
        let actionCancel = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
        //добавляем кнопки
        alert.addAction(actionSave)
        alert.addAction(actionCancel)
        //презентуем алерт
        present(alert, animated: true, completion: nil)
    }
}

extension RealmToDoViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.isEmpty ? 0 : items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! RealmToDoTableViewCell
        cell.titleLabel.text = items[indexPath.row].title
        cell.subtitleLabel.text = items[indexPath.row].subtitle
        
        //если значение свойства done - true - ставим чекмарк, если нет - не ставим
        cell.accessoryType = items[indexPath.row].done == true ? .checkmark : .none
        return cell
    }
    
    //MARK: - delete cell
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            try! self.realm.write{
                self.realm.delete(items[indexPath.row])
            }
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    //MARK: - remove the cell selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //при нажатии на ячейку, значение св-ва done меняется на противоположное и сохраняется в БД
        try! realm.write{
            items[indexPath.row].done = !items[indexPath.row].done
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
