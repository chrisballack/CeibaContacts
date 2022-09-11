//
//  ViewController.swift
//  CeibaContacts
//
//  Created by Dev IOS on 11/09/22.
//

import UIKit
import SkyFloatingLabelTextField

class HomeUsers: UIViewController {

    @IBOutlet weak var search: SkyFloatingLabelTextField!
    @IBOutlet weak var TableView: UITableView!{
        
        didSet{
            
            TableView.delegate = self
            TableView.dataSource = self
            
        }
        
    }
    let ViewModel = UsersViewModel()
    
    var UsersListOriginal:[UsersModel.UsersData] = []
    var UsersList:[UsersModel.UsersData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureInput(input: search, dataInput: "Buscar Usuario")
        self.hideKeyboardWhenTappedAround()
        self.title = "Prueba de ingreso"
        self.GetUsers()
        
    }
    
    
    func GetUsers(){
        
        ViewModel.GetUsers { Result in
            
            if Result != nil{
                
                self.UsersList = Result!
                self.UsersListOriginal = Result!
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
        cell.selectionStyle = .none
        return cell
        
    }
    
    func configureInput(input: SkyFloatingLabelTextField, dataInput: String) {
        input.placeholder = dataInput
        input.title = dataInput
        input.selectedTitleColor = UIColor(named: "HomeGreenColor")!
        input.lineHeight = 0
        input.selectedLineHeight = 0
    }
    
}


extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        
        view.endEditing(true)
        
    }
    
}
