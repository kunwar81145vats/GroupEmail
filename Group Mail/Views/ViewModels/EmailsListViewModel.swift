//
//  EmailsListViewModel.swift
//  Group Mail
//
//  Created by Kunwar Vats on 19/07/23.
//

import UIKit

class EmailsListViewModel: NSObject {
    
    var reloadTableView: (() -> Void)?
        
    var emailAddresses = [Email]() {
        didSet {
            reloadTableView?()
        }
    }
    
    //0: New Group, 1: Add to Group
    var pageType: Int = 0
    var group: Group!
    
    //MARK: Fetch email addresses
    func getEmailAddresses()
    {
        var emails = CoreDataHelper.shared.fetchEmailAddresses() ?? []
        if emails.count == 0//If no Email addresses found, add sample email addresses
        {
            CoreDataHelper.shared.createSampleEmails()
            emails = CoreDataHelper.shared.fetchEmailAddresses() ?? []
        }
        
        //Show all email Addresses
        if pageType == 0
        {
            emailAddresses = emails
        }
        else //Show Email addresses in the selected group
        {
            let groupEmails = group.groupEmails?.array as? [Email] ?? []
            emailAddresses = emails.filter({ email in
                !groupEmails.contains(email)
            })
        }
    }
    
    //MARK: Create or update Group
    func createGroup(_ selectedItems: [Email], _ vc: UIViewController)
    {
        let ac = UIAlertController(title: pageType == 0 ? "Enter Group Name" : "Confirm group Name", message: nil, preferredStyle: .alert)
        
        ac.addTextField { tf in
            tf.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
        }

        if pageType == 1
        {
            ac.textFields![0].text = group.name
        }
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel)

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            let nameTextField = ac.textFields![0]
            // do something interesting with "answer" here
            
            if nameTextField.text?.count == 0
            {
                return
            }
            
            //Update group
            if self.pageType == 1
            {
                CoreDataHelper.shared.addEmails(selectedItems, self.group, nameTextField.text ?? "")
            }
            else//Create group
            {
                CoreDataHelper.shared.createGroup(nameTextField.text ?? "", selectedItems)
            }
            
            vc.navigationController?.popViewController(animated: true)
        }
        
        ac.addAction(cancelAction)
        ac.addAction(submitAction)

        ac.actions[1].isEnabled = pageType == 0 ? false : true
        vc.present(ac, animated: true)
    }
    
    //Group name update detect method
    @objc func textChanged(_ sender: Any) {
        let tf = sender as! UITextField
        var resp : UIResponder! = tf
        while !(resp is UIAlertController) { resp = resp.next }
        let alert = resp as! UIAlertController
        alert.actions[1].isEnabled = (tf.text != "")
    }
}
