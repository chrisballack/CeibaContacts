//
//  UsersSQL.swift
//  CeibaContacts
//
//  Created by Dev IOS on 11/09/22.
//

import Foundation
import SQLite
import UIKit

class UserSQL{
    
    var database: Connection!
    let UsersTable = Table("UsersTable")
    let Name = Expression<String>("Name")
    let Phone = Expression<String>("Phone")
    let Email = Expression<String>("Email")
    let ID = Expression<Int>("ID")
    
    init(){
        
        do {
            
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let fileUrl = documentDirectory.appendingPathComponent("Users").appendingPathExtension("sqlite3")
            let db = try Connection(fileUrl.path)
            database = db
            
        } catch {
            
            print(error)
            
        }
        
    }
    
    func createTable() {
        
        let createTable = UsersTable.create {
            
            (table) in
            table.column(Name)
            table.column(Phone)
            table.column(Email)
            table.column(ID)
            
        }
        
        do {
            
            try database.run(createTable)
            print("Created Table")
            
        } catch {
            
            print(error)
            
        }
        
    }
    
    func DeleteUsers(){
        
        let deleteUsers = UsersTable.delete()
        
        do{
            
            try database.run(deleteUsers)
            print("Delete Like")
            
        }catch{
            
            print(error)
            
        }
        
    }
    
    func UpdateUser(IdFunc:Int,NameFunc:String,PhoneFunc:String,EmailFunc:String,completion : @escaping (Bool) -> ()){
        
        let LikeFilter = UsersTable.filter(ID == IdFunc)
        let updateLike = LikeFilter.update(Name <- NameFunc,Phone <- PhoneFunc,Email <- EmailFunc)
        
        do {
            
            try database.run(updateLike)
            completion(true)
            
        } catch {
            
            print(error)
            completion(false)
            
        }
        
    }
    
    func insertUser(IdFunc:Int,NameFunc:String,PhoneFunc:String,EmailFunc:String) {
        
        let insertLike = UsersTable.insert(ID <- IdFunc,Name <- NameFunc,Phone <- PhoneFunc,Email <- EmailFunc)
        
        do {
            
            try database.run(insertLike)
            
        } catch {
            
            print(error)
            
        }
        
    }
    
func listLikes() -> [(UsersModel.UsersData)] {
    
    var LocalArray:[(UsersModel.UsersData)] = []
    
    do {
        
        let Users = try database.prepare(UsersTable)
        
        for User in Users {
            
            LocalArray.append((UsersModel.UsersData.init(Id: User[ID], Name: User[Name], Email: User[Email], Phone: User[Phone])))
                //.append((IsLike: Like[IsLike], Name: Like[Name], DateFunc: Like[Date]))
            
        }
        return LocalArray
        
    } catch {
        
        print(error)
        return []
        
    }
    
    
}


}
