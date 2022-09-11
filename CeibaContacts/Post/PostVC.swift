//
//  PostVC.swift
//  CeibaContacts
//
//  Created by Dev IOS on 11/09/22.
//

import UIKit

class PostVC: UIViewController {

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Mail: UILabel!
    @IBOutlet weak var Phone: UILabel!
    @IBOutlet weak var EmptyTable: UILabel!
    @IBOutlet weak var TableView: UITableView!

    let ViewModel = PostViewModel()
    var UserInfo:UsersModel.UsersData?
    
    var Posts: [PostModel.PostData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupUI()
    }
    
    //Enviar llamar al numero del usuario
    @objc func CallingAction(_ sender: UITapGestureRecognizer? = nil) {
        
        if let url = URL(string: "tel://\(UserInfo!.phone!)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
    
    }
    
    //Enviar Mail a el correo del usuario
    @objc func MailAction(_ sender: UITapGestureRecognizer? = nil) {
        
        let email = UserInfo!.email!
        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    
    }
    
    //Configuracion principal de la vista
    func SetupUI() {
        
        let backButton = UIBarButtonItem()
        backButton.title = "Atras"
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        Name.text = UserInfo!.name ?? ""
        Phone.text = UserInfo!.phone ?? ""
        let CallingAction = UITapGestureRecognizer(target: self, action: #selector(self.CallingAction(_:)))
        Phone.isUserInteractionEnabled = true
        Phone.addGestureRecognizer(CallingAction)
        
        Mail.text = UserInfo!.email ?? ""
        let MailAction = UITapGestureRecognizer(target: self, action: #selector(self.MailAction(_:)))
        Mail.isUserInteractionEnabled = true
        Mail.addGestureRecognizer(MailAction)
        
        GetPosts()
    }

    
    // Obtiene los Post por el id del usuario seleccionado
    func GetPosts(){
        
        showLoadingView(vista: self)
        
        ViewModel.GetUsers(UserId: UserInfo!.id!) { Result in
            
            HideLoadingView(vista: self)
            
            if Result != nil{
                
                self.Posts = Result!
                self.TableView.reloadData()
                
            }else{
                
                AlertErrorConexion(vista: self)
                
            }
            
        }
        
    }
    
}

extension PostVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        EmptyTable.isHidden = !(Posts.count == 0)
        return Posts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let i = indexPath.row
        
        let cell = Bundle.main.loadNibNamed("PostCell", owner: self, options: nil)?.first as! PostCells
        cell.Title.text = Posts[i].title!
        cell.Msj.text = Posts[i].title!
        cell.selectionStyle = .none
        return cell
        
    }
    
    
}
