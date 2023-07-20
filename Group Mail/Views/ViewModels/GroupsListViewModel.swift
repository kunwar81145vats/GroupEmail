//
//  GroupsListViewModel.swift
//  Group Mail
//
//  Created by Kunwar Vats on 19/07/23.
//

import UIKit

class GroupsListViewModel: NSObject {

    var reloadTableView: (() -> Void)?
        
    var groups = [Group]() {
        didSet {
            reloadTableView?()
        }
    }
    
    //MARK: Get groups
    func getGroups()
    {
        groups = CoreDataHelper.shared.fetchGroups() ?? []
    }

    //MARK: Push Email list View Controller to Create new group
    func pushEmailList(nav: UINavigationController)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let emailVC = storyboard.instantiateViewController(withIdentifier: "EmailsListViewController") as? EmailsListViewController else { return }
        nav.pushViewController(emailVC, animated: true)
    }
    
    //MARK: Push Edit Group View Controller
    func pushGroupEditVC(_ nav: UINavigationController, _ tag: Int)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let editVC = storyboard.instantiateViewController(withIdentifier: "GroupEditViewController") as? GroupEditViewController else { return }
        editVC.viewModel.group = groups[tag]
        nav.pushViewController(editVC, animated: true)
    }
}
