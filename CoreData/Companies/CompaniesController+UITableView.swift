//
//  CompaniesController+UITableView.swift
//  CompanyCoreData
//
//  Created by Ammar Ali on 2/7/22.
//

import UIKit

extension CompaniesController {
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
           //Delete Action
           let deleteItem = UIContextualAction(style: .destructive, title: "delete") { (action, view, bool) in
               let company = self.companies[indexPath.row]
               //update array
               self.companies.remove(at: indexPath.row)
               //update table view
               self.tableView.deleteRows(at: [indexPath], with: .automatic)
               //update core data
               let context = CoreDataManager.shared.persistentContainer.viewContext
               context.delete(company)
               do {
                   try context.save()
               }catch let saveErr {
                   print("failed to delete company", saveErr)
               }
           }
           
           //Edit Action
        let editItem = UIContextualAction(style: .normal, title: "Edit") { [self] (action, view, bool) in
               print("edit")
            
            
             let editCompanyController = CreateComanyController()
            editCompanyController.delegate = self
            editCompanyController.company = companies[indexPath.row]
             let navController = CustomNavigationController(rootViewController: editCompanyController)
            self.present(navController, animated: true, completion: nil)
           }
        
        
           let swipeAction = UISwipeActionsConfiguration(actions: [deleteItem, editItem])
           return swipeAction
           
       }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CompanyCell
        
        let company = companies[indexPath.row]
        cell.company = company
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No companies available..."
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return companies.count == 0 ? 150 : 0
    }
}
