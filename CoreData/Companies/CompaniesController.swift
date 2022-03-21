//
//  ViewController.swift
//  CoreData
//
//  Created by Ammar Ali on 8/3/21.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
    
    var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.companies = CoreDataManager.shared.fetchCompany()
            
        view.backgroundColor = .white
        
        tableView.backgroundColor = .darkBlue
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .white
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        
        navigationItem.title = "Companies"
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let company = self.companies[indexPath.row]
        let employeeController = EmployeesController()
        employeeController.company = company
        navigationController?.pushViewController(employeeController, animated: true)
    }
    
    @objc func handleAddCompany(){
        print("Add Comapnay...")
        
        let createCompnayController = CreateComanyController()
        
        let navController = CustomNavigationController(rootViewController: createCompnayController)
        createCompnayController.delegate = self
        navController.modalPresentationStyle = .overCurrentContext
        present(navController, animated: true, completion: nil)
        
    }
    
    @objc func handleReset(){
        print("Delete companies from core data")
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        
        do {
            try context.execute(batchDeleteRequest)
            
            // upon deletion from core data succeeded
            
            var indexPathsToRemove = [IndexPath]()
            
            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            companies.removeAll()
            tableView.deleteRows(at: indexPathsToRemove, with: .left)
            
        } catch let delErr {
            print("Failed to delete objects from Core Data:", delErr)
        }
    }
}

