//
//  PostApiClient.swift
//  CeibaContacts
//
//  Created by Dev IOS on 11/09/22.
//

import Foundation
import Alamofire

class PostApiClient{
    
    func GetPost(UserID:Int,completion : @escaping (DataResponse<Any>) -> ()){
        
        Alamofires.request(Domain+GetURLs.UsersById.replacingOccurrences(of: "{User_Id}", with: "\(UserID)"), method: .get).responseJSON {
            
            response in
            completion(response)
            
        }
        
    }

}
