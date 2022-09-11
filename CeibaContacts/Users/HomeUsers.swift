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
import Realm
import RealmSwift

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
    let SQLUSer = UserSQL()
    
    var UserID:Int?
    let underKeyboardLayoutConstraint = UnderKeyboardLayoutConstraint()
    
    var UsersListOriginal:[UsersModel.UsersData] = []
    var UsersList:[UsersModel.UsersData] = []
    
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        underKeyboardLayoutConstraint.setup(ButtonConstraint, view: self.view)
        configureInput(input: search, dataInput: "Buscar Usuario")
        self.hideKeyboardWhenTappedAround()
        
        self.title = "Prueba de ingreso"
        
        //Aca Puedes Cambiar el Como guardara el Programa los datos dependiendo de la libreria
        StorageType = .UserDefault
        
        if StorageType == .SQL{
            
            SQLUSer.createTable()
            
        }
        
        
        self.Getinformation()
        
    }
    
    func Getinformation(){
        
        switch StorageType {
            
        case .UserDefault:
            
            if Defaults[UsersData] != nil{
                
                ViewModel.GetUsersWithData(data: Defaults[UsersData]!) { Result in
                    
                    self.UsersList = Result!
                    self.UsersListOriginal = Result!
                    self.TableView.reloadData()
                    
                }
                
            }else{
                
                self.GetUsers()
                
            }
            
        case .SQL:
            
            let list = SQLUSer.listLikes()
            
            if list.count != 0{
                
                
                self.UsersList = list
                self.UsersListOriginal = list
                self.TableView.reloadData()
                
                
            }else{
                
                self.GetUsers()
                
            }
            
        case .Realm:
            
            if realm.isEmpty == false{
                
                let Users = self.realm.objects(UsersRealmModel.self)
                
                for user in Users{
                    
                    self.UsersList.append(UsersModel.UsersData.init(Id: user.id, Name: user.name!, Email: user.email!, Phone: user.phone!))
                    
                }
                
                self.UsersListOriginal = self.UsersList
                self.TableView.reloadData()
                
                
            }else{
                
                self.GetUsers()
                
            }
            
        }
        
    }
    
    func GetUsers(){
        
        ViewModel.GetUsers { Result in
            
            if Result != nil{
                
                if self.StorageType == .SQL{
                    
                    for User in Result!{
                        
                        self.SQLUSer.insertUser(IdFunc: User.id!, NameFunc: User.name!, PhoneFunc: User.phone!, EmailFunc: User.email!)
                        
                    }
                    
                }
                
                if self.StorageType == .Realm{
                    
                    
                    for User in Result!{
                        
                        try! self.realm.write {
                            self.realm.add(type(of: UsersRealmModel()).init(User.id ?? -1, name: User.name, username: User.username, email: User.email, phone: User.phone, website: User.website,Address: type(of: Address()).init(User.address?.street, suite: User.address?.suite, city: User.address?.city, zipcode: User.address?.zipcode, Geo: type(of: Geo()).init(User.address?.geo?.lat, lng: User.address?.geo?.lng)), company: type(of: Company()).init(User.company?.name, catchPhrase: User.company?.catchPhrase, bs: User.company?.bs)))
                            }
                        
                    }
                    
                    
                    
                    
                }
                
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? PostVC {
            
            vc.UserID = UserID
            
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
        cell.ButtonPublics.tag = i
        cell.ButtonPublics.addTarget(self, action: #selector(GoToPost), for: UIControl.Event.touchUpInside)
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
    
    @objc func GoToPost( sender: UIButton!) {
        
        let i = sender.tag
        UserID = UsersList[i].id
        self.performSegue(withIdentifier: "Post", sender: nil)
    
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




extension Object {
    func toDictionary() -> NSDictionary {
        let properties = self.objectSchema.properties.map { $0.name }
        let dictionary = self.dictionaryWithValues(forKeys: properties)

        let mutabledic = NSMutableDictionary()
        mutabledic.setValuesForKeys(dictionary)

        for prop in self.objectSchema.properties as [Property] {
            // find lists
            if let nestedObject = self[prop.name] as? Object {
                mutabledic.setValue(nestedObject.toDictionary(), forKey: prop.name)
            }

        }
        return mutabledic
    }

}



func convertToDictionary(text: String) -> Any? {
    
    if let data = text.data(using: .utf8) {
        
        do {
            
            return try JSONSerialization.jsonObject(with: data, options: [])
            
        } catch {
            
            print(error.localizedDescription)
            
        }
    }
    
    return nil
    
}


