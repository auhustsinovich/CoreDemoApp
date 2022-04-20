//
//  TaskListViewController.swift
//  CoreDemoApp
//
//  Created by Daniil on 20.04.22.
//

import UIKit
import CoreData

class TaskListViewController: UITableViewController {
    
    private let storageManager = StorageManager.shared
    private let cellID = "task"
    private var taskList: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        view.backgroundColor = .white
        setupNavigationBar()
        fetch()
    }
        
    @objc private func addNewTask() {
        showAlert(with: "New Task", and: "What do you want to do?")
    }
    private func editTask(with text: String, at index: IndexPath) {
        let task = taskList[index.row]
        task.title = text
        storageManager.saveContext()
        tableView.reconfigureRows(at: [index])
        
    }
    
    private func showAlert(with title: String, and message: String, _ index: IndexPath? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            
            if let index = index {
                self.editTask(with: task, at: index)
            } else {
                self.save(task)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.placeholder = "New Task"
            if let index = index {
                textField.text = self.taskList[index.row].title
            }
        }
        present(alert, animated: true)
    }
    
    private func save(_ taskName: String) {
        let task = storageManager.createTask()
        task.title = taskName
        taskList.append(task)
        storageManager.saveContext()
        
        let cellIndex = IndexPath(row: taskList.count - 1, section: 0)
        tableView.insertRows(at: [cellIndex], with: .automatic)
        
    }
    
    private func delete(_ atIndex: Int) {
        taskList.remove(at: atIndex)
    }
    
    private func fetch() {
        storageManager.fetchContext(&taskList)
    }
}

//MARK: - Extensions
extension TaskListViewController {
    //MARK: - Navigator settings
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        navigationController?.navigationBar.tintColor = .white
    }
    
    //MARK: - tableView functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = taskList[indexPath.row]
            storageManager.deleteTask(task)
            taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showAlert(with: "Update Task", and: "What do you want to do?", indexPath)
    }
}
