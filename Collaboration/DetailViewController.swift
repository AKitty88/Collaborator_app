//
//  DetailViewController.swift
//  Collaboration
//
//  Created by Kitti Almasy on 26/4/18.
//  Copyright © 2018 Kitti Almasy. All rights reserved.


// pics: PeertoPeerMan. only, others are ready
// create another view on storyboard
// connect viewTapped()



import UIKit
import Foundation
import MultipeerConnectivity

class DetailViewController: UITableViewController, UITextFieldDelegate {
    
    /// delegate (the MasterViewController)
    var delegate: TaskListProtocol!
    /// user's changes (of the particular task) are cancelled
    let sectionHeaders = ["Task", "Collaborators", "Log"]
    /// helps to find cell for the clicked textfield
    var textFieldIndexPath: IndexPath? = nil
    
//    var peerToPeer = PeerToPeerManager()
    var peerlist = [MCPeerID]()
    
    /// Helps to decide which cell it is
    enum Sections: Int {
        case sectionA = 0
        case sectionB = 1
        case sectionC = 2
    }
    
    func CollaboratorClicked() {
        print ("D - CollaboratorClicked")
        var task_json: Task_Json
        
        // Ongoing task
        if (delegate.selectedItemSection == 0) {
            task_json = Task_Json(tasklist: delegate.taskList[0], id: (delegate.selectedTask?.task_id)!)
        }                   // Completed task
        else if (delegate.selectedItemSection == 1) {
            task_json = Task_Json(tasklist: delegate.taskList[1], id: (delegate.selectedTask?.task_id)!)
        }
        else {              // Not found task
            task_json = Task_Json(tasklist: delegate.taskList[1], id: String(-1))
        }
        
        delegate.sentData = task_json
        delegate.peerToPeer.send(data: (delegate.sentData?.json)!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "Task"
    }
    
    /// Gets invoked just before the view disappears
    override func viewWillDisappear(_ animated: Bool) {
        print ("D - viewWillDisappear \(String(describing: delegate.selectedTask?.title))")
        
        if let indexPath = tableView.indexPathForSelectedRow {
            if delegate.selectedTask != nil {
                if let cell = tableView.cellForRow(at: indexPath as IndexPath) as? MyTableViewCellForTaskname {
                    delegate.save(withName: (cell.myTextLabel?.text) ?? "", history: (cell.myTextLabel?.text) ?? "")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        print ("D - viewDidLoad \(String(describing: delegate.selectedTask?.title))")
        super.viewDidLoad()
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(CollaboratorTapped))
//        tap.numberOfTapsRequired = 1
//        view.addGestureRecognizer(tap)
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
        
        if section == 1 {
            if peerlist != nil {
                return peerlist.count
            }
        }
        else if section == 2 {
            return (delegate.selectedTask?.logs.count)!
        }
        // else if section == 0
        else {
            return 1
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Return false if you do not want the specified item to be editable.
        return sectionHeaders[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print ("D - tableView cellForRowAt \(String(describing: delegate.selectedTask?.title))")
        
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
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MyTableViewCellForTaskname
            
            if let task = delegate.selectedTask {
                cell.myTextLabel.delegate = self
                cell.myTextLabel.text? = task.title
            }
            else {
                print ("missing selectedTask value")
            }
            return cell
        }
        else if identifier == "Detail Cell B" {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MyTableViewCellForCollaborator
            
            cell.myLabel.text = peerlist[indexPath.row].displayName
            return cell
        }
        else if identifier == "Detail Cell C" {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MyTableViewCellForLog
            
            if let task = delegate.selectedTask {
                cell.dateLabel.text? = task.date
                cell.collaboratorLabel.text? = task.collaborators
                cell.myTextLabel.delegate = self
                cell.myTextLabel.text? = task.logs[indexPath.row]
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
    
    func textFieldDidEndEditing(textField: UITextField!) {
        print ("D - textFieldDidEndEditing \(String(describing: delegate.selectedTask?.title))")
        
        let pointInTable = textField.convert(textField.bounds.origin, to: self.tableView)
        textFieldIndexPath = self.tableView.indexPathForRow(at: pointInTable)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print ("D - textFieldShouldReturn \(String(describing: delegate.selectedTask?.title))")
        
        switch (textField.tag) {
        case 1:
            delegate.selectedTask?.title = (textField.text)!
            delegate.selectedTask?.taskNameChangedLog()
        case 2:
            delegate.selectedTask?.collaborators = (textField.text)!
        case 3:
            textFieldDidEndEditing(textField: textField)
            delegate.selectedTask?.logs[(textFieldIndexPath?.row)!] = (textField.text!)
        default:
            print ("default")
        }
        
        tableView.reloadData()
        delegate.save(withName: (delegate.selectedTask?.title)!, history: "")
        textField.resignFirstResponder()
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {            
            CollaboratorClicked()
        }
    }
    
    
}

