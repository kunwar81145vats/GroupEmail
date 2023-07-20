//
//  GroupEditViewController.swift
//  Group Mail
//
//  Created by Kunwar Vats on 19/07/23.
//

import UIKit

class GroupEditViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var viewModel = {
        GroupEditViewModel()
    }()
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initViewModel()
        self.title = viewModel.group.name
    }

    //MARK: Initialize View Model
    func initViewModel() {
        
        viewModel.getEmails()
        
        // Reload TableView closure
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    //MARK: Add Emails button Action
    @IBAction func addEmailsButtonAction(_ sender: Any) {
        
        guard let nav = self.navigationController else { return }
        viewModel.pushEmailList(nav: nav)
    }
}

//MARK: UITableView DataSource & Delegates
extension GroupEditViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.emails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")

        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        }
        
        let email = viewModel.emails[indexPath.row]
        
        cell?.textLabel?.text = email.email
        
        return cell!
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            tableView.beginUpdates()
            let email = viewModel.emails[indexPath.section]
            viewModel.removeEmailFromGroup(email)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}
