//
//  SavingsTableViewCell.swift
//  Expense Tracker
//
//  Created by madi on 3/26/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//

import UIKit

class SavingsTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
