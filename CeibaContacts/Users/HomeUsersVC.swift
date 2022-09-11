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

    @IBOutlet weak var EmptyTable: UILabel!
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
    
    let underKeyboardLayoutConstraint = UnderKeyboardLayoutConstraint()
    let ViewModel = UsersViewModel()
    let SQLUSer = UserSQL()
    
    var UsersListOriginal:[UsersModel.UsersData] = []
    var UsersList:[UsersModel.UsersData] = []
    
    let realm = try! Realm()
    var UserID:Int?
    
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
    
    
    // Obtiene los datos el usuario Desde la fuente de datos seleccionada
    func Getinformation(){
        
        showLoadingView(vista: self)
        
        switch StorageType {
            
        case .UserDefault:
            
            if Defaults[UsersData] != nil{
                
                ViewModel.GetUsersWithData(data: Defaults[UsersData]!) { Result in
                    
                    self.UsersList = Result!
                    self.UsersListOriginal = Result!
                    HideLoadingView(vista: self)
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
                HideLoadingView(vista: self)
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
                HideLoadingView(vista: self)
                self.TableView.reloadData()
                
                
            }else{
                
                self.GetUsers()
                
            }
            
        }
        
    }
    
    
    // Obtiene los usuarios que entrega el servicio Rest
    func GetUsers(){
        
        ViewModel.GetUsers { Result in
            
            HideLoadingView(vista: self)
            
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
                
                AlertErrorConexion(vista: self)
                
            }
            
        }
        
    }
    
    // es un observable a cada que se edita un valor en el textfield
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        
            BuscarNombre(nombre:search.text!){
                
                (result) -> () in
                
                self.UsersList.removeAll()
                self.UsersList = result
                self.TableView.setContentOffset(CGPoint(x: 0, y: 0 - self.TableView.contentInset.top), animated: true)
                self.TableView.reloadData()
                
            }
            
    }
    
    
    // Se encarga de buscar por nombre de el usuario
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
    
    // Es la forma de enviar los datos entre vistas con el uso de segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? PostVC {
            
            vc.UserID = UserID
            
        }
        
    }
    
}

extension HomeUsers:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        EmptyTable.isHidden = !(UsersList.count == 0)
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
    
    // Accion del boton de la tabla
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
