//
//  PostViewModel.swift
//  CeibaContacts
//
//  Created by Dev IOS on 11/09/22.
//

import Foundation

class PostViewModel{

    func GetUsers(UserId:Int,completion : @escaping ([PostModel.PostData]?) -> ()) {
        
        PostApiClient().GetPost(UserID: UserId) { response in
            
            switch response.result {
                
            case .success(_):
                
                
                if let Data = try? JSONDecoder().decode([PostModel.PostData].self, from: response.data!) as [PostModel.PostData]{
                    
                    completion(Data)
                    
                }else{
                    
                    completion(nil)
                    
                }
                
            case .failure(_):
                
                completion(nil)
                break
                
            @unknown default:
                break
            }
            
        }
    }
    
}
