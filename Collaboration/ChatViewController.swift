//
//  ChatViewController.swift
//  Collaboration
//
//  Created by Kitti Almasy on 23/5/18.
//  Copyright © 2018 Kitti Almasy s5110592. All rights reserved.
//

import UIKit

class ChatViewController: UITableViewController, UITextFieldDelegate {

    var chatDelegate: TaskListProtocol!
    
    override func viewDidLoad() {
        print ("C - viewDidLoad")
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print ("C - viewWillAppear")
        super.viewWillAppear(true)
        self.navigationItem.title = chatDelegate.selectedTask?.title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            return (chatDelegate.selectedTask?.logs.count)!
        } // else if section == 0
        else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print ("C - tableView cellForRowAt")

        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Chat Cell A", for: indexPath) as! MyTableViewCellForTaskname
            return cell
        } // else if (indexPath.section == 1)
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Chat Cell B", for: indexPath)
            
            if let task = chatDelegate.selectedTask {
                cell.textLabel?.text = task.date + " " + task.username + " " + task.logs[indexPath.row]
            }
            return cell
        }        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print ("C - textFieldShouldReturn \(String(describing: chatDelegate.selectedTask?.title))")
        
        chatDelegate.selectedTask?.logs.append(textField.text!)
        textField.resignFirstResponder()
        return true
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
