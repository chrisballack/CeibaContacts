//
//  UsersApiClient.swift
//  CeibaContacts
//
//  Created by Dev IOS on 11/09/22.
//

import Foundation
import Alamofire


class UserApiClient{
    
    func GetUsers(completion : @escaping (DataResponse<Any>) -> ()){
        
        Alamofires.request(Domain+GetURLs.Users, method: .get).responseJSON {
            
            response in
            completion(response)
            
        }
        
    }

}
