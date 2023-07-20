//
//  GroupsListViewController.swift
//  Group Mail
//
//  Created by Kunwar Vats on 19/07/23.
//

import UIKit

class GroupsListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var viewModel = {
        GroupsListViewModel()
    }()
    
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Email Groups"
        
        initViewModel()
    }
    
    //MARK: Initialize View Model
    func initViewModel() {
        // Get employees data
        viewModel.getGroups()
        
        // Reload TableView closure
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    //MARK: New Group Button action
    @IBAction func NewGroupButtonAction(_ sender: Any) {
        
        guard let nav = self.navigationController else { return }
        viewModel.pushEmailList(nav: nav)
    }
}

//MARK: UITableView DataSource & Delegates
extension GroupsListViewController: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.groups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.groups[section].groupEmails?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = .lightGray
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = viewModel.groups[section].name
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        
        headerView.addSubview(label)
        
        let button = UIButton()
        button.frame = headerView.frame
        button.tag = section
        button.addTarget(self, action: #selector(groupButtonAction(_:)), for: .touchUpInside)
        
        headerView.addSubview(button)
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")

        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        }
        
        let email = viewModel.groups[indexPath.section].groupEmails?[indexPath.row] as? Email
        
        cell?.textLabel?.text = email?.email
        return cell!
    }
    
    //MARK: Group button Action To Edit Group
    @objc func groupButtonAction(_ button: UIButton)
    {
        guard let nav = self.navigationController else { return }
        viewModel.pushGroupEditVC(nav, button.tag)
    }
}
