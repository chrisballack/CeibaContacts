//
//  PostVC.swift
//  CeibaContacts
//
//  Created by Dev IOS on 11/09/22.
//

import UIKit

class PostVC: UIViewController {

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
    
    func GetPosts(){
        
        ViewModel.GetUsers(UserId: UserID!) { Result in
            
            if Result != nil{
                
                self.Posts = Result!
                self.TableView.reloadData()
                
            }else{
                
                
                
            }
            
        }
        
    }
    
}

extension PostVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
