//
//  MasterViewController.swift
//  Collaboration
//
//  Created by Kitti Almasy on 26/4/18.
//  Copyright © 2018 Kitti Almasy. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, TaskListProtocol {
    
    var selectedItemSection: Int?
    /// the index of the task which is selected at the moment (property of TaskListProtocol)
    var selectedItemIndex: Int?
    /// the task which is selected at the moment (property of TaskListProtocol)
    var selectedTask: Task?
    /// array of the tasks
    var taskList = [[Task(title: "test1", complete: true)], [Task(title: "test2", complete: true)]]
    
    // @IBOutlet weak var myTableView: UITableView!
    var detailViewController: DetailViewController? = nil
    let sectionHeaders = ["Ongoing", "Done"]
    
    @IBAction func AddClicked(_ sender: UIBarButtonItem) {
        //if let indexPath = indexPathForSelectedRow {
        //taskList[
    }
    
    
    
    /**
     Saves the task that is being edited (method of TaskListProtocol)
     - parameter task : description of task
     - parameter dateDue : date chosen by user
     - parameter isDue : tells us if the task has a duedate
     - parameter status : tells us if the task is completed
     */
    func save(withName task: String, history log: String) {
        //if selectedTask != nil {
        
            selectedTask?.title = task
        
        /*} else {
            if let indexPath = tableView.indexPathForSelectedRow {
                taskList[indexPath.section].append(Task(title: task))
            }
        } */
        
        tableView.reloadData()
    }
    
    /// cancels the editing of the current task (method of TaskListProtocol)
    func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
            detailViewController?.delegate = self
            
            selectedTask = taskList[0][0]
            print("\(String(describing: selectedTask))")
            
            selectedItemSection = 0
            selectedItemIndex = 0            
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var dvc : DetailViewController!
        
        if  detailViewController != nil {
            if let detailViewController = segue.destination as? UINavigationController {
                dvc = detailViewController.topViewController as! DetailViewController
            } else {
                dvc = segue.destination as! DetailViewController
            }
        
            if let indexPath = tableView.indexPathForSelectedRow {
                let task = taskList[indexPath.section][indexPath.row]
                selectedTask = task
                
                dvc.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                dvc.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel!.text = taskList[indexPath.section][indexPath.row].title
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Return false if you do not want the specified item to be editable.
        return sectionHeaders[section]
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            taskList[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath as IndexPath) != nil {
            selectedItemSection = indexPath.section
            selectedItemIndex = indexPath.row
            selectedTask = taskList[selectedItemSection!][selectedItemIndex!]
            
            if let cell = detailViewController?.tableView.cellForRow(at: indexPath) as? MyTableViewCell {
                save(withName: cell.myTextLabel?.text ?? "", history: cell.myTextLabel?.text ?? "")
            }
        }
        tableView.reloadData()
    }
}

