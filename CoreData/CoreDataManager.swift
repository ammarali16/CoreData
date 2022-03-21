//
//  CoreDataManager.swift
//  CompanyCoreData
//
//  Created by Ammar Ali on 1/31/22.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager() //will live forever as long as the application is still alive and its properties too
    
    let persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "TrainingModel")
        container.loadPersistentStores { storeDescription, err in
            if let err = err{
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()
    
    
    func fetchCompany() -> [Company] {
        
        //attempy my CoreData fetch somehow..
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            return companies
            
        } catch let fetchErr {
            print("Failed to fetch err", fetchErr)
            return []
        }
    }
    
    func createEmployee(employeeName: String, employeeType: String, birthday: Date, company: Company) -> (Employee?, Error?) {
        let context = persistentContainer.viewContext
        
        //create an employee
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
        
        employee.company = company
        employee.type = employeeType
        
        // lets check company is setup correctly
//        let company = Company(context: context)
//        company.employees
//
//        employee.company
        
        employee.setValue(employeeName, forKey: "name")
        
        let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as! EmployeeInformation
        
        employeeInformation.taxId = "456"
        employeeInformation.birthday = birthday
        
//        employeeInformation.setValue("456", forKey: "taxId")
        
        employee.employeeInformation = employeeInformation
        
        do {
            try context.save()
            // save succeeds
            return (employee, nil)
        } catch let err {
            print("Failed to create employee:", err)
            return (nil, err)
        }
        
    }
}
