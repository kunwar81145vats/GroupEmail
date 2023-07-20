//
//  EmailsListViewController.swift
//  Group Mail
//
//  Created by Kunwar Vats on 19/07/23.
//

import UIKit

class EmailsListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var createButton: UIButton!
    lazy var viewModel = {
        EmailsListViewModel()
    }()
    
    var selectedRows: [Int] = []
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initViewModel()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Email List"
    }
    
    //MARK: Initialize View Model
    func initViewModel() {
        // Get employees data
        viewModel.getEmailAddresses()
        
        // Reload TableView closure
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    //MARK: Update UI as per Page Type (New Group/Edit Group)
    func setupUI()
    {
        if viewModel.pageType == 1
        {
            createButton.setTitle("Add To Group", for: .normal)
        }
    }
    
    //MARK: Create Group or Edit Group Button Action
    @IBAction func createGroupButtonAction(_ sender: Any) {
        
        var selectedEmails: [Email] = []
        
        for (ind, obj) in viewModel.emailAddresses.enumerated()
        {
            if selectedRows.contains(ind)
            {
                selectedEmails.append(obj)
            }
        }
        
        viewModel.createGroup(selectedEmails, self)        
    }
    
}

//MARK: UITableView DataSource & Delegates
extension EmailsListViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.emailAddresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmailCell", for: indexPath) as? EmailCell else { fatalError("xib does not exists") }
        cell.selectionStyle = .none
        cell.nameLabel.text = viewModel.emailAddresses[indexPath.row].email
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? EmailCell else { return }
        if selectedRows.contains(indexPath.row)
        {
            cell.selectedIcon.isHidden = true
            if let index = selectedRows.firstIndex(of: indexPath.row) {
                selectedRows.remove(at: index)
            }
        }
        else
        {
            selectedRows.append(indexPath.row)
            cell.selectedIcon.isHidden = false
        }
    }
}
