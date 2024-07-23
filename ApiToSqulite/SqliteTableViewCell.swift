//
//  SqliteTableViewCell.swift
//  ApiToSqulite
//
//  Created by apple on 04/07/24.
//

import UIKit

class SqliteTableViewCell: UITableViewCell {
    @IBOutlet weak var sIdLabel: UILabel!
    @IBOutlet weak var sNameLabel: UILabel!
    @IBOutlet weak var sEmailLabel: UILabel!
    @IBOutlet weak var sUserNameLabel: UILabel!
    @IBOutlet weak var sFirstNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
