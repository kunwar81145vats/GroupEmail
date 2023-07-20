//
//  GroupEditViewModel.swift
//  Group Mail
//
//  Created by Kunwar Vats on 19/07/23.
//

import UIKit

class GroupEditViewModel: NSObject {

    var reloadTableView: (() -> Void)?
    
    var emails = [Email]() {
        didSet {
            reloadTableView?()
        }
    }
    
    var group = Group()
    
    //MARK: Get group email addresses
    func getEmails()
    {
        emails = group.groupEmails?.array as? [Email] ?? []
    }
    
    //MARK: Remove email from group
    func removeEmailFromGroup(_ email: Email)
    {
        emails.removeAll { obj in
            obj == email
        }
        CoreDataHelper.shared.removeEmail(email, group)
    }
        
    //MARK: Push Email list View Controller
    func pushEmailList(nav: UINavigationController)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let emailVC = storyboard.instantiateViewController(withIdentifier: "EmailsListViewController") as? EmailsListViewController else { return }
        emailVC.viewModel.pageType = 1
        emailVC.viewModel.group = group
        nav.pushViewController(emailVC, animated: true)
    }
    
}
