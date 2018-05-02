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
    
    var detailItem: String? {
        didSet {
           
        }
    }
    /// delegate (the MasterViewController)
    var delegate: TaskListProtocol!
    /// user's changes (of the particular task) are cancelled
    let sectionHeaders = ["Task", "Collaborators", "Log"]
    var selectedTask: Task? = Task(title: "h")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "Task"
        
        /* guard let thisItem = delegate.selectedTask else {
            taskDescription = "test"
            return
        }
        taskDescription = thisItem.title */
    }
    
    /// Gets invoked just before the view disappears
    override func viewWillDisappear(_ animated: Bool) {
        if let sel = selectedTask?.title {
            delegate.save(withName: sel)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* if let detail = detailItem {
            if let textF = myCell.myTextLabel {
                textF.text = detail.description
            }
        } */
        
        print("detailItem: \(String(describing: detailItem))")
        print("selectedTask.title: \(selectedTask?.title)")
        print("selectedTask.complete: \(selectedTask?.complete)")
        print("selectedTask.collaborators: \(selectedTask?.collaborators)")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Detail Cell A", for: indexPath) as! MyTableViewCell

        if let task = selectedTask {
            cell.myTextLabel.delegate = self
            cell.myTextLabel.text? = task.title
            cell.myTextLabel.placeholder = task.title
        }
        else {
            print ("missing detailItem value")
        }
        return cell
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
