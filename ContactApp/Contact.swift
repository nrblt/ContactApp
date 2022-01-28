import CoreData

@objc(Contact)
class Contact:NSManagedObject{
    @NSManaged var id: NSNumber!
    @NSManaged var name: String!
    @NSManaged var phoneNumber: String!
    @NSManaged var deletedDate: Date!
    @NSManaged var gender: String!

}
