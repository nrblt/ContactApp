import UIKit
import CoreData

var contactList = [Contact]()

class ContactTableView:UITableViewController{
    
    var firstLoad=true
    
    func nonDeleteContacts()->[Contact]{
        var noDeleteContactList=[Contact]()
        for contact in contactList{
            if(contact.deletedDate==nil){
                noDeleteContactList.append(contact)
            }
        }
        return noDeleteContactList
    }
    
    override func viewDidLoad() {
        if(firstLoad==true){
            firstLoad=false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let contact = result as! Contact
                    contactList.append(contact)
                }
            } catch  {
                print("Fetch failed")
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contactCell = tableView.dequeueReusableCell(withIdentifier: "contactCellId", for: indexPath) as! ContactCell
        
        
        let thisContact: Contact!
        thisContact = nonDeleteContacts()[indexPath.row]
        
        
        contactCell.nameLabel.text = thisContact.name
        contactCell.phoneLabel.text = thisContact.phoneNumber
        contactCell.genderLabel.text=thisContact.gender
        
        return contactCell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nonDeleteContacts().count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editContact", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="editContact"){
            let indexPath = tableView.indexPathForSelectedRow!
            
            let contactDetail = segue.destination as? ContactDetailVC
            
            let selectedContact : Contact!
            selectedContact=nonDeleteContacts()[indexPath.row]
            contactDetail!.selectedContact = selectedContact
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
