//
//  PairListTableViewController.swift
//  PairRandomizer
//
//  Created by Landon Epps on 10/25/19.
//  Copyright © 2019 Landon Epps. All rights reserved.
//

import UIKit

class PairListTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var pairs: [[Student]]?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        randomizePairs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return pairs?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Group \(section + 1)"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pairs?[section].count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)

        let student = pairs?[indexPath.section][indexPath.row]
        cell.textLabel?.text = student?.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let student = pairs?[indexPath.section][indexPath.row]
                else { return }
            // remove from pairs and Core Data
            pairs?[indexPath.section].remove(at: indexPath.row)
            StudentsController.shared.remove(student: student)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func shuffleButtonTapped(_ sender: Any) {
        randomizePairs()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Add Student", message: "Add a student to the list.", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Full Name"
            textField.autocapitalizationType = .words
            textField.autocorrectionType = .no
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            
            guard let name = alertController.textFields?.first?.text, !name.isEmpty else {
                self.present(alertController, animated: true)
                return
            }
            
            StudentsController.shared.addStudent(withName: name)
            self.pairs = StudentsController.shared.makePairs()
            self.tableView.reloadData()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        present(alertController, animated: true)
    }
    
    // MARK: - Helpers
    
    func randomizePairs() {
        pairs = StudentsController.shared.makePairs()
        tableView.reloadData()
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "cellToDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destination = segue.destination as? StudentDetailTableViewController
            else {
                print("Error in segue \"cellToDetailVC\"")
                return
            }
            
            destination.student = pairs?[indexPath.section][indexPath.row]
        }
    }
}
