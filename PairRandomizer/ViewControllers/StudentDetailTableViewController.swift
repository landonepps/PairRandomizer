//
//  StudentDetailTableViewController.swift
//  PairRandomizer
//
//  Created by Landon Epps on 10/25/19.
//  Copyright © 2019 Landon Epps. All rights reserved.
//

import UIKit

class StudentDetailTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var student: Student?
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let student = student {
            nameTextField.text = student.name
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let newName = nameTextField.text, !newName.isEmpty,
            let student = student
            else { return }
        
        StudentsController.shared.update(student: student, withName: newName)
        navigationController?.popViewController(animated: true)
    }
}
