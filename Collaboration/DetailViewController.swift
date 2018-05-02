//
//  DetailViewController.swift
//  Collaboration
//
//  Created by Kitti Almasy on 26/4/18.
//  Copyright © 2018 Kitti Almasy. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController, UITextFieldDelegate {
    
    // todo: Add button -> action: append tasklist (title: new task), tableview.reloaddata
    // - check if everything is the same (this one <-> Assignment1) !!!
    
   
    // @IBOutlet weak var myCell: MyTableViewCell!
    

    /// delegate (the MasterViewController)
    var delegate: TaskListProtocol!
    /// user's changes (of the particular task) are cancelled
    let sectionHeaders = ["Task", "Collaborators", "Log"]
    
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
                    delegate.save(withName: (cell.myTextLabel?.text) ?? "")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if delegate == nil {
            if let split = splitViewController {
                let controllers = split.viewControllers
                let masterViewController = (controllers[controllers.count-2] as! UINavigationController).topViewController as? MasterViewController
                delegate = masterViewController
                
                if masterViewController?.taskList[0][0] != nil {
                    masterViewController?.selectedTask = masterViewController?.taskList[0][0]
                }
                
                masterViewController?.selectedItemSection = 0
                masterViewController?.selectedItemIndex = 0
            }
        }
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
                cell.myTextLabel.text? = task.log
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
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
