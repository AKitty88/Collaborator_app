//
//  DetailViewController.swift
//  Collaboration
//
//  Created by Kitti Almasy on 26/4/18.
//  Copyright © 2018 Kitti Almasy. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController, UITextFieldDelegate {
    
    /// delegate (the MasterViewController)
    var delegate: TaskListProtocol!
    /// user's changes (of the particular task) are cancelled
    let sectionHeaders = ["Task", "Collaborators", "Log"]
    
    @IBAction func NewLog(_ sender: UIBarButtonItem) {
        //delegate.selectedTask?.log.append(<#T##newElement: String##String#>)
    }
    
    enum Sections: Int {
        case sectionA = 0
        case sectionB = 1
        case sectionC = 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "Task"
    }
    
    /// Gets invoked just before the view disappears
    override func viewWillDisappear(_ animated: Bool) {
        
        if let indexPath = tableView.indexPathForSelectedRow {
            if delegate.selectedTask != nil {
                if let cell = tableView.cellForRow(at: indexPath as IndexPath) as? MyTableViewCell {
                    delegate.save(withName: (cell.myTextLabel?.text) ?? "", history: (cell.myTextLabel?.text) ?? "")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionHeaders.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Return false if you do not want the specified item to be editable.
        return sectionHeaders[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var identifier: String
        
        guard let section = Sections(rawValue: indexPath.section) else {
            fatalError("Wrong section: \(indexPath.section)")
        }
        
        switch section {
        case .sectionA:
            identifier = "Detail Cell A"
        case .sectionB:
            identifier = "Detail Cell B"
        case .sectionC:
            identifier = "Detail Cell C"
        }
        
        if identifier == "Detail Cell A" {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MyTableViewCell
            
            if let task = delegate.selectedTask {
                cell.myTextLabel.delegate = self
                cell.myTextLabel.text? = task.title
            }
            else {
                print ("missing selectedTask value")
            }
            return cell
        }
        else if identifier == "Detail Cell C" {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MyTableViewCell
            
            if let task = delegate.selectedTask {
                cell.myTextLabel.delegate = self
                
                for logLine in task.log {
                    cell.myTextLabel.text? = logLine
                }
            }
            else {
                print ("missing selectedTask value")
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! UITableViewCell
            return cell
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate.selectedTask?.title = (textField.text)!
        delegate.save(withName: (delegate.selectedTask?.title)!, history: "")
        textField.resignFirstResponder()
        return true
    }
}

