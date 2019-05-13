//
//  ExportCoreDataViewController.swift
//  Expense Tracker
//
//  Created by madi on 5/13/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//

import CoreData
import UIKit

class ExportCoreDataViewController: UIViewController {
    
    fileprivate var managedContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func exportDataPressed(_ sender: Any) {
        let names = NSPersistentContainer(name: "Expense_Tracker").managedObjectModel.entities.map({ (entity) -> String in
            return entity.name!
        })
        
        var exportData: [String: [Any]] = [String: [Any]]()
        
        for name in names {
            let request = NSFetchRequest<NSManagedObject>(entityName: name)
            
            do {
                let cdContext = try managedContext.fetch(request)
                var csvData = [Any]()
                var logHeader = true
                
                for data in cdContext {
                    if logHeader {
                        for key in data.entity.attributesByName.keys {
                            csvData.append(key)
                            csvData.append(">EOL<")
                        }
                        logHeader = false
                    }
                    for key in data.entity.attributesByName.keys {
                        csvData.append(data.value(forKey: key) as Any)
                    }
                    csvData.append(">EOL<")
                }
                exportData[name] = csvData
            } catch let error as NSError {
                print("Could not fetch data, \(error), \(error.description)")
            }
        }
        print("exportData...\(exportData)")
        
        for (key, value) in exportData {
            exportCSV(name: key, valueArr: value)
        }
    }
    
    func exportCSV(name: String, valueArr: [Any]) -> Void {
        let fileName = "\(name).csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvText = ""
        var newLine = ""
        
        for value in valueArr {
            if value as? String == ">EOL<" {
                csvText.append(newLine)
                newLine = ""
            } else {
                newLine += "\(value),"
            }
        }
        
        do {
            try csvText.write(to: path!, atomically: true, encoding: .utf8)
        } catch {
            print("Failed to create file, \(error), \(error.localizedDescription)")
        }
        
        print("path...\(path)")
    }
}
