//
//  PostVC.swift
//  CeibaContacts
//
//  Created by Dev IOS on 11/09/22.
//

import UIKit

class PostVC: UIViewController {

    @IBOutlet weak var EmptyTable: UILabel!
    @IBOutlet weak var TableView: UITableView!

    let ViewModel = PostViewModel()
    var UserID:Int?
    
    var Posts: [PostModel.PostData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem()
        backButton.title = "Atras"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        GetPosts()
    }
    
    // Obtiene los Post por el id del usuario seleccionado
    func GetPosts(){
        
        showLoadingView(vista: self)
        
        ViewModel.GetUsers(UserId: UserID!) { Result in
            
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
