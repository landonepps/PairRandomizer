//
//  StudentsController.swift
//  PairRandomizer
//
//  Created by Landon Epps on 10/25/19.
//  Copyright © 2019 Landon Epps. All rights reserved.
//

import Foundation
import CoreData

class StudentsController {
    
    // MARK: - Properties
    
    static let shared = StudentsController()
    
    var students: [Student] {
        let fetchRequest: NSFetchRequest<Student> = Student.fetchRequest()
        return (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
    }
    
    // MARK: - CRUD
    
    func addStudent(withName name: String) {
        Student(name: name)
        CoreDataStack.saveContext()
    }
    
    func update(student: Student, withName name: String) {
        student.name = name
        CoreDataStack.saveContext()
    }
    
    func remove(student: Student) {
        CoreDataStack.context.delete(student)
        CoreDataStack.saveContext()
    }
    
    // MARK: - Helper Methods
    
    func makePairs() -> [[Student]] {
        let shuffledStudents = students.shuffled()
        
        var pairs = [[Student]]()
        var pair = [Student]()
        
        for student in shuffledStudents {
            if pair.count == 0 {
                pair.append(student)
            } else {
                pair.append(student)
                pairs.append(pair)
                pair = [Student]()
            }
        }
        
        // If there's an odd student out, add them too
        if pair.count != 0 {
            pairs.append(pair)
        }
        
        return pairs
    }
}
