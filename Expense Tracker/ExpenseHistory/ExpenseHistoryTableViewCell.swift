//
//  ExpenseHistoryTableViewCell.swift
//  Expense Tracker
//
//  Created by madi on 3/24/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//

import UIKit

class ExpenseHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
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
