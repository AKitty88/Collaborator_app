//
//  MasterViewController.swift
//  Collaboration
//
//  Created by Kitti Almasy on 26/4/18.
//  Copyright © 2018 Kitti Almasy s5110592. All rights reserved.
//


import UIKit

class MasterViewController: UITableViewController, TaskListProtocol, PeerToPeerManagerDelegate {    
    
    /// the section of the task which is selected at the moment (property of TaskListProtocol)
    var selectedItemSection: Int?               // DEBUG: Might be not needed
    /// the index of the task which is selected at the moment (property of TaskListProtocol)
    var selectedItemIndex: Int?                 // DEBUG: Might be not needed
    /// the task which is selected at the moment (property of TaskListProtocol)
    var selectedTask: Task?
    /// array of the tasks
    var taskList = [[Task(title: "Test1")], [Task(title: "Test2")]]
    
    var peerToPeer = PeerToPeerManager()
    
   var sentData: Data?
    
    // @IBOutlet weak var myTableView: UITableView!
    var detailViewController: DetailViewController? = nil
    let sectionHeaders = ["Ongoing", "Done"]
    
    // Gets called when user clicks on the Add button
    @IBAction func AddClicked(_ sender: UIBarButtonItem) {
        print ("M - AddClicked \(String(describing: selectedTask?.title))")
        
        taskList[0].append(Task(title: "New Task \(taskList[0].count)"))
        taskList[0][taskList[0].count-1].task_id = UUID().uuidString
        taskList[0][taskList[0].count-1].username = String(describing: peerToPeer.peerId.displayName)
        tableView.reloadData()
    }
    
    /**
     Saves the task that is being edited (method of TaskListProtocol)
     - parameter withName : description of task
     - parameter history : log
     */
    func save(withName task: String, history log: String) {
        print ("M - save \(String(describing: selectedTask?.title))")
        
        selectedTask?.title = task
        tableView.reloadData()
    }
    
    /// cancels the editing of the current task (method of TaskListProtocol)
    func cancel() {
        print ("M - cancel \(String(describing: selectedTask?.title))")
        
        navigationController?.popViewController(animated: true)
    }
    
    /// method called from session (didreceive) when data was received
    func manager(_ manager: PeerToPeerManager, didReceive data: Data) {
        print ("M - manager \(String(describing: selectedTask?.title))")
        
        var task_json = Task_Json()
        task_json.json = data
        var found_index_1 = -2
        var found_index_2 = -2
        print("Received json: \(String(describing: task_json.json))")
        
        found_index_1 = task_json.find(tasklist: taskList[0], id: task_json.taskInJson.task_id!)
        found_index_2 = task_json.find(tasklist: taskList[1], id: task_json.taskInJson.task_id!)
        
        if (found_index_1 == -1 && (found_index_2 == -1)) {
            if (!task_json.taskInJson.completed) {
                taskList[0].append(task_json.taskInJson)
            } else if (task_json.taskInJson.completed) {
                taskList[1].append(task_json.taskInJson)
            }
        }
        
        if ((task_json.taskInJson.completed && (found_index_1 > -1)) || (!task_json.taskInJson.completed && (found_index_2 > -1))) {
            if (found_index_1 > -1) {
                taskList[0].remove(at: found_index_1)
                taskList[1].append(task_json.taskInJson)
                selectedTask = taskList[0][found_index_1]
            }
            else if (found_index_2 > -1) {
                taskList[1].remove(at: found_index_2)
                taskList[0].append(task_json.taskInJson)
                selectedTask = taskList[1][found_index_2]
            }
        }
        else {
            if (found_index_1 > -1) {
                taskList[0][found_index_1] = task_json.taskInJson
                selectedTask = taskList[0][found_index_1]
            }
            if (found_index_2 > -1) {
                taskList[1][found_index_2] = task_json.taskInJson
                selectedTask = taskList[1][found_index_2]
            }
        }
        tableView.reloadData()
        detailViewController?.tableView.reloadData()                                // FAULT: doesn't reload: Yammer !!!
    }
    
    func updatePeers() {                                                            // DEBUG: might not need it
        detailViewController?.peerlist = peerToPeer.session.connectedPeers          // DEBUG: might not need it
        detailViewController?.tableView.reloadData()                                // DEBUG: might not need it
    }
    
    override func viewDidLoad() {
        print ("M - viewDidLoad \(String(describing: selectedTask?.title))")
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        peerToPeer.delegate = self
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
            detailViewController?.delegate = self
            
            selectedTask = taskList[0][0]
            selectedItemSection = 0
            selectedItemIndex = 0
            taskList[0][0].task_id = "AB8419ED-058E-4726-AB87-1CC88CD573DE"                 // for test1 default task
            taskList[0][0].username = String(describing: peerToPeer.peerId.displayName)     // for test1 default task
            taskList[1][0].task_id = "AB8419ED-058E-4726-AB87-1CC88CD573DF"                 // for test2 default task
            taskList[1][0].username = String(describing: peerToPeer.peerId.displayName)     // for test2 default task
            taskList[1][0].completed = true                                                 // for test2 default task
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print ("M - viewWillAppear \(String(describing: selectedTask?.title))")
        
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print ("M - prepare \(String(describing: selectedTask?.title))")
        
        var dvc : DetailViewController!
        
        if detailViewController != nil {
            if let detailViewController = segue.destination as? UINavigationController {
                dvc = detailViewController.topViewController as! DetailViewController
            } else {
                dvc = segue.destination as! DetailViewController
            }
            dvc.delegate = self
            dvc.peerlist = peerToPeer.session.connectedPeers
            
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let task = taskList[indexPath.section][indexPath.row]
                selectedItemSection = indexPath.section
                selectedItemIndex = indexPath.row
                selectedTask = task
                
                dvc.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                dvc.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    func update() {
        tableView.reloadData()
    }
        
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        print ("M - numberOfSections \(String(describing: selectedTask?.title))")
        
        return sectionHeaders.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print ("M - tableView numberOfRowsInSection \(String(describing: selectedTask?.title))")
        
        return taskList[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print ("M - tableView cellForRowAt \(String(describing: selectedTask?.title))")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = taskList[indexPath.section][indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        print ("M - tableView canEditRowAt \(String(describing: selectedTask?.title))")
        
        // Return false if you do not want the specified item to be editable
        return true
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        print ("M - tableView titleForHeaderInSection \(String(describing: selectedTask?.title))")
        
        // Return false if you do not want the specified item to be editable
        return sectionHeaders[section]
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print ("M - tableView editingStyle \(String(describing: selectedTask?.title))")
        
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
        
        print ("M - tableView moveRowAt \(String(describing: selectedTask?.title))")
        let taskToMove = taskList[sourceIndexPath.section][sourceIndexPath.row]
        selectedTask = taskToMove
        selectedItemSection = destinationIndexPath.section
        selectedItemIndex = destinationIndexPath.row
        
        taskList[destinationIndexPath.section].insert(taskToMove, at: destinationIndexPath.row)
        taskList[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        
        if (destinationIndexPath.section != sourceIndexPath.section) {
            if (destinationIndexPath.section == 0) {
                selectedTask?.logMovedToOngoing()
                selectedTask?.completed = false
            }
                
            else if (destinationIndexPath.section == 1) {
                selectedTask?.logMovedToCompleted()
                selectedTask?.completed = true
            }            
            detailViewController?.tableView.reloadData()
        }
    }
}

