//
//  UsersViewModel.swift
//  CeibaContacts
//
//  Created by Dev IOS on 11/09/22.
//

import Foundation
import SwiftyUserDefaults

class UsersViewModel{

    func GetUsers(completion : @escaping ([UsersModel.UsersData]?) -> ()) {
        
        UserApiClient().GetUsers() { response in
            
            switch response.result {
                
            case .success(_):
                
                if Defaults[UsersData] == nil{
                    
                    Defaults[UsersData] = response.data!
                    
                }
                
                if let Data = try? JSONDecoder().decode([UsersModel.UsersData].self, from: response.data!) as [UsersModel.UsersData]{
                    
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
    
    func GetUsersWithData(data:Data,completion : @escaping ([UsersModel.UsersData]?) -> ()) {
        
                if let Data = try? JSONDecoder().decode([UsersModel.UsersData].self, from: data) as [UsersModel.UsersData]{
                    
                    completion(Data)
                    
                }else{
                    
                    completion(nil)
                    
                }
        
            
    }

}
