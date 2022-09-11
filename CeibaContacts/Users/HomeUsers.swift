//
//  ViewController.swift
//  CeibaContacts
//
//  Created by Dev IOS on 11/09/22.
//

import UIKit

class HomeUsers: UIViewController {

    @IBOutlet weak var search: UITextField!
    @IBOutlet weak var TableView: UITableView!{
        
        didSet{
            
            TableView.delegate = self
            TableView.dataSource = self
            
        }
        
    }
    let ViewModel = UsersViewModel()
    
    var UsersList:[UsersModel.UsersData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Prueba de ingreso"
        self.GetUsers()
    }
    
    
    func GetUsers(){
        
        ViewModel.GetUsers { Result in
            
            if Result != nil{
                
                self.UsersList = Result!
                self.TableView.reloadData()
                
            }else{
                
                
                
            }
            
        }
        
    }

}

extension HomeUsers:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return UsersList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let i = indexPath.row
        
        let cell = Bundle.main.loadNibNamed("HomeCell", owner: self, options: nil)?.first as! HomeCell
        cell.Name.text = UsersList[i].name ?? ""
        cell.PhoneNumber.text = UsersList[i].phone ?? ""
        cell.Email.text = UsersList[i].email ?? ""
        return cell
        
    }
    
}

