
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = Persistence.share.name
        lastNameTextField.text = Persistence.share.lastName
    }

    @IBAction func saveAction(_ sender: Any) {
        Persistence.share.name = nameTextField.text
        Persistence.share.lastName = lastNameTextField.text
    }
}

