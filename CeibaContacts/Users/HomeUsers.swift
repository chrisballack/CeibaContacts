//
//  ViewController.swift
//  CeibaContacts
//
//  Created by Dev IOS on 11/09/22.
//

import UIKit
import SkyFloatingLabelTextField
import UnderKeyboard
import SwiftyUserDefaults

var UsersData = DefaultsKey<Data?>("UsersListInfo")

enum LocalStorageType{
    
    case UserDefault
    case SQL
    case Realm
    
}

class HomeUsers: UIViewController,UITextFieldDelegate {
    
    var StorageType:LocalStorageType = .UserDefault

    @IBOutlet weak var ButtonConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var search: SkyFloatingLabelTextField!{
        
        didSet{
            
            search.delegate = self
            search.addTarget(self, action: #selector(self.myTextFieldDidChange), for: .editingChanged)
            
        }
        
    }
    
    @IBOutlet weak var TableView: UITableView!{
        
        didSet{
            
            TableView.delegate = self
            TableView.dataSource = self
            
        }
        
    }
    
    let ViewModel = UsersViewModel()
    let underKeyboardLayoutConstraint = UnderKeyboardLayoutConstraint()
    
    var UsersListOriginal:[UsersModel.UsersData] = []
    var UsersList:[UsersModel.UsersData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        underKeyboardLayoutConstraint.setup(ButtonConstraint, view: self.view)
        configureInput(input: search, dataInput: "Buscar Usuario")
        self.hideKeyboardWhenTappedAround()
        
        self.title = "Prueba de ingreso"
        self.Getinformation()
        
    }
    
    
    func Getinformation(){
        
        if StorageType == .UserDefault{
            
            if Defaults[UsersData] != nil{
                
                ViewModel.GetUsersWithData(data: Defaults[UsersData]!) { Result in
                    
                    self.UsersList = Result!
                    self.UsersListOriginal = Result!
                    self.TableView.reloadData()
                    
                }
                
            }else{
                
                self.GetUsers()
                
            }
            
        }
        
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
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        
        if textField == search{
            
            BuscarNombre(nombre:search.text!){
                
                (result) -> () in
                
                self.UsersList.removeAll()
                self.UsersList = result
                self.TableView.setContentOffset(CGPoint(x: 0, y: 0 - self.TableView.contentInset.top), animated: true)
                self.TableView.reloadData()
                
            }
            
        }
        
    }
    
    func BuscarNombre(nombre:String, completion: @escaping (_ result: [(UsersModel.UsersData)])->()){
        
        var local:[(UsersModel.UsersData)] = []
        let cad = nombre.lowercased()
        
        if cad == "" || cad == " "{
            
            print("entre aca")
            completion(UsersListOriginal)
            
        }else{
            
            print("no era vacio")
            
            for t in UsersListOriginal{
                
                var tag = ""
                
                if t.name ?? "" != ""{
                    
                    tag = "\(t.name ?? "")"
                    
                }else{
                    
                    tag = "N/A"
                    
                }
                
                if tag.lowercased().range(of:"\(cad)", options:.literal) != nil{
                    
                    local.append(t)
                    
                }
                
            }
            
            completion(local)
            
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
