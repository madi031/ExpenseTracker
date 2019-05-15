//
//  ExportCoreDataViewController.swift
//  Expense Tracker
//
//  Created by madi on 5/13/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//

import CoreData
import UIKit
import ZIPFoundation

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
                
                let keys = cdContext[0].entity.attributesByName.keys
                
                for data in cdContext {
                    if logHeader {
                        for key in keys {
                            csvData.append(key)
                        }
                        csvData.append(">EOL<")
                        logHeader = false
                    }
                    for key in keys {
                        if let val = data.value(forKey: key) {
                            csvData.append(val as Any)
                        } else {
                            csvData.append("nil" as Any)
                        }
                    }
                    csvData.append(">EOL<")
                }
                exportData[name] = csvData
            } catch let error as NSError {
                print("Could not fetch data, \(error), \(error.description)")
            }
        }
        
        if let currentWorkingPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let archiveUrl = currentWorkingPath.appendingPathComponent("CoreData.zip")
            
            guard let archive = Archive(url: archiveUrl, accessMode: .update) else {
                print("Some error happened while accessing archive url...")
                return
            }
            
            for (key, value) in exportData {
                let fileName = "\(key).csv"
                let fileUrl = exportCSV(fileName: fileName, valueArr: value)
                
                do {
                    try archive.addEntry(with: fileUrl.lastPathComponent, relativeTo: fileUrl.deletingLastPathComponent())
                } catch {
                    print("Adding entry to zip failed, \(error)")
                }
            }
            
            share(url: archiveUrl)
        }
    }
    
    func exportCSV(fileName: String, valueArr: [Any]) -> URL {
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvText = ""
        var newLine = ""
        
        for value in valueArr {
            if value as? String == ">EOL<" {
                csvText.append(newLine)
                csvText.append("\n")
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
        return path!
    }
    
    func share(url: URL) {
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
    }
}
