//
//  EmailCell.swift
//  Group Mail
//  Email Cell Class for Cell on Email List Controller
//  Created by Kunwar Vats on 19/07/23.
//

import UIKit

class EmailCell: UITableViewCell {

    //MARK: IBOutlets
    @IBOutlet weak var selectedIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    //MARK: Awake method
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Hiding checkmark initially
        selectedIcon.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
