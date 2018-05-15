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
    var taskList = [[Task(title: "test1")], [Task(title: "test2")]]
    
    // @IBOutlet weak var myTableView: UITableView!
    var detailViewController: DetailViewController? = nil
    let sectionHeaders = ["Ongoing", "Done"]
    
    // Gets called when user clicks on the Add button
    @IBAction func AddClicked(_ sender: UIBarButtonItem) {
        print ("M - AddClicked \(selectedTask?.title)")
        
        taskList[0].append(Task(title: "New Task \(taskList[0].count)"))
        tableView.reloadData()
    }
    
    /**
     Saves the task that is being edited (method of TaskListProtocol)
     - parameter withName : description of task
     - parameter history : log
     */
    func save(withName task: String, history log: String) {
        print ("M - save \(selectedTask?.title)")
        
        selectedTask?.title = task
        tableView.reloadData()
    }
    
    /// cancels the editing of the current task (method of TaskListProtocol)
    func cancel() {
        print ("M - cancel \(selectedTask?.title)")
        
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        print ("M - viewDidLoad \(selectedTask?.title)")
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
            detailViewController?.delegate = self
            
            selectedTask = taskList[0][0]
            selectedItemSection = 0
            selectedItemIndex = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print ("M - viewWillAppear \(selectedTask?.title)")
        
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print ("M - prepare \(selectedTask?.title)")
        
        var dvc : DetailViewController!
        
        if detailViewController != nil {
            if let detailViewController = segue.destination as? UINavigationController {
                dvc = detailViewController.topViewController as! DetailViewController
            } else {
                dvc = segue.destination as! DetailViewController
            }
            dvc.delegate = self
            
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
        print ("M - numberOfSections \(selectedTask?.title)")
        
        return sectionHeaders.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print ("M - tableView numberOfRowsInSection \(selectedTask?.title)")
        
        return taskList[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print ("M - tableView cellForRowAt \(selectedTask?.title)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = taskList[indexPath.section][indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        print ("M - tableView canEditRowAt \(selectedTask?.title)")
        
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        print ("M - tableView titleForHeaderInSection \(selectedTask?.title)")
        
        // Return false if you do not want the specified item to be editable.
        return sectionHeaders[section]
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print ("M - tableView editingStyle \(selectedTask?.title)")
        
        if editingStyle == .delete {
            taskList[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        print ("M - tableView moveRowAt \(selectedTask?.title)")
        let taskToMove = taskList[sourceIndexPath.section][sourceIndexPath.row]
        selectedTask = taskToMove
        
        taskList[destinationIndexPath.section].insert(taskToMove, at: destinationIndexPath.row)
        taskList[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        tableView.reloadData()
        
        if (destinationIndexPath.section != sourceIndexPath.section) {
            if (destinationIndexPath.section == 0) {
                selectedTask?.logMovedToOngoing()
            }
                
            else if (destinationIndexPath.section == 1) {
                selectedTask?.logMovedToCompleted()
            }
        }
    }
}

