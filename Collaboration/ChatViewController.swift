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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print ("C - viewWillAppear")
        super.viewWillAppear(true)
        self.navigationItem.title = chatDelegate.selectedTask?.title
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let masterVC = self.chatDelegate as? MasterViewController {
            masterVC.detailViewController?.tableView.reloadData()
        }
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "Chat Cell A", for: indexPath) as! TasknameTableViewCell
            return cell
        } // else if (indexPath.section == 1)
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Chat Cell B", for: indexPath)
            
            if let task = chatDelegate.selectedTask {
                cell.textLabel?.text = "\(task.date) \(task.logCreator[indexPath.row]) \(task.logs[indexPath.row])"
            }
            return cell
        }        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print ("C - textFieldShouldReturn \(String(describing: chatDelegate.selectedTask?.title))")
        
        chatDelegate.selectedTask?.logs.append("said: " + "\"" + textField.text! + "\"")
        chatDelegate.selectedTask?.logId.append((chatDelegate.selectedTask?.logId.count)!)
        chatDelegate.selectedTask?.logCreator.append((chatDelegate.selectedTask?.username)!)
        textField.resignFirstResponder()
        
        let task_json = Task_Json(to_json: chatDelegate.selectedTask!)
        chatDelegate.sentData = task_json.json
        chatDelegate.peerToPeer.send(data: (chatDelegate.sentData)!)
        tableView.reloadData()
        
        return true
    }
}
