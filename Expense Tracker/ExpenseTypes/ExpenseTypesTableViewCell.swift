//
//  ExpenseTypesTableViewCell.swift
//  Expense Tracker
//
//  Created by madi on 3/22/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//

import UIKit

class ExpenseTypesTableViewCell: UITableViewCell {

    @IBOutlet weak var expenseTypeLabel: UILabel!
    @IBOutlet weak var expenseLimitLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
