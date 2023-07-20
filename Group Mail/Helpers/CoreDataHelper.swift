//
//  CoreDataHelper.swift
//  Group Mail
//
//  Created by Kunwar Vats on 19/07/23.
//

import UIKit
import CoreData

class CoreDataHelper: NSObject {

    //Creating Singleton
    static let shared: CoreDataHelper = CoreDataHelper()
    
    var managedObjectContext: NSManagedObjectContext!
    
    //Private INIT method for Singleton Functionality
    private override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        managedObjectContext = appDelegate.persistentContainer.viewContext
    }
    
    //Adding Sample email addresses for testing
    func createSampleEmails()
    {        
        for obj in 1...10
        {
            // Create Email
            let email = Email(context: managedObjectContext)
            
            // Configure Email
            email.email = "email\(obj)@gmail.com"
        }
        
        do {
            //Save emails
            try managedObjectContext.save()
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    //MARK: Fetch All Email Addresses
    func fetchEmailAddresses() -> [Email]? {
        
        let fetchRequest: NSFetchRequest<Email> = Email.fetchRequest()
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            let emailAddresses = results
            return emailAddresses
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        
        return nil
    }
    
    //MARK: Fetch All Groups
    func fetchGroups() -> [Group]? {
        
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            let groups = results
            return groups
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        
        return nil
    }
    
    //MARK: Create Group
    func createGroup(_ name: String, _ emails: [Email])
    {
        // Create Group
        let group = Group(context: managedObjectContext)
        
        // Configure Group
        group.name = name
        
        for obj in emails
        {
            group.addToGroupEmails(obj)
        }
        
        do {
            try managedObjectContext.save()
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    //MARK: Remove Email From Group
    func removeEmail(_ email: Email, _ group: Group)
    {
        group.removeFromGroupEmails(email)
        do {
            try managedObjectContext.save()
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    //MARK: Add Email to Group
    func addEmails(_ emails: [Email], _ group: Group, _ name: String)
    {
        group.name = name
        for obj in emails
        {
            group.addToGroupEmails(obj)
        }
        do {
            try managedObjectContext.save()
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
