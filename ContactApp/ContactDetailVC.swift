import UIKit
import CoreData

class ContactDetailVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return  genders[row]
    }


    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    
    var selectedContact: Contact? = nil
    
    let genders=["male","female"]
    
    var pickerView=UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pickerView.delegate = self
        pickerView.dataSource = self
        
        genderTF.inputView = pickerView
        genderTF.textAlignment = .center
        if(selectedContact != nil){
            nameTF.text=selectedContact!.name
            phoneTF.text=selectedContact!.phoneNumber
            genderTF.text=selectedContact!.gender
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTF.text = genders[row]
        genderTF.resignFirstResponder()
    }
    
    
    
    @IBAction func saveAction(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        if(nameTF.text != ""||phoneTF.text != ""||genderTF.text != ""){
            if(selectedContact==nil){
                let entity = NSEntityDescription.entity(forEntityName: "Contact", in: context)
                let newContact = Contact(entity: entity!, insertInto: context )
                
                newContact.id = contactList.count as NSNumber
                newContact.name=nameTF.text
                newContact.phoneNumber=phoneTF.text
                newContact.gender=genderTF.text
                do{
                    try context.save()
                    contactList.append(newContact)
                    navigationController?.popViewController(animated: true)
                }
                catch{
                    print("something is wrong with context")
                }
            }
            else{
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
                do {
                    let results:NSArray = try context.fetch(request) as NSArray
                    for result in results {
                        let contact = result as! Contact
    //                    contactList.append(contact)
                        if(contact==selectedContact){
                            contact.name=nameTF.text
                            contact.gender=genderTF.text
                            contact.phoneNumber=phoneTF.text
                            try context.save()
                            navigationController?.popViewController(animated: true)
                        }
                    }
                } catch  {
                    print("Fetch failed")
                }
            }
        }
    }


    @IBAction func deleteContact(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        do {
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results {
                let contact = result as! Contact
//                    contactList.append(contact)
                if(contact==selectedContact){
                    contact.deletedDate=Date()
                    try context.save()
                    navigationController?.popViewController(animated: true)
                }
            }
        } catch  {
            print("Fetch failed")
        }
    }
}

