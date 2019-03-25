//
//  String.swift
//  Expense Tracker
//
//  Created by madi on 3/25/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//

import Foundation

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
}
