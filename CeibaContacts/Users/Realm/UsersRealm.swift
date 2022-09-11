//
//  UsersRealm.swift
//  CeibaContacts
//
//  Created by Dev IOS on 11/09/22.
//

import Foundation
import Realm
import UIKit
import RealmSwift


class UsersRealmModel:Object{
    
    @objc dynamic var id = 0
    @objc dynamic var name: String?
    @objc dynamic var username: String?
    @objc dynamic var email: String?
    @objc dynamic var address:  Address?
    @objc dynamic var phone: String?
    @objc dynamic var website: String?
    @objc dynamic var company : Company?
    
    required convenience init(_ id: Int, name: String?, username: String?,email:String?,phone:String?,website:String? ,Address : Address?,company:Company?) {
            self.init()
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.phone = phone
        self.website = website
        self.address = Address
        self.company = company
        }
    
    
}

class Address : Object {
    
    @objc dynamic var street: String?
    @objc dynamic var suite: String?
    @objc dynamic var city: String?
    @objc dynamic var zipcode: String?
    @objc dynamic var geo: Geo?
    
    required convenience init(_ street: String?, suite: String?, city: String?,zipcode:String?,Geo:Geo?) {
            self.init()
        self.street = street
        self.suite = suite
        self.city = city
        self.zipcode = zipcode
        self.geo = Geo
        }
    

}

class Geo: Object {
    
    @objc dynamic var lat : String?
    @objc dynamic var lng : String?
    
    required convenience init(_ lat: String?, lng: String?) {
            self.init()
        self.lat = lat
        self.lng = lng
        }
    
}

class Company: Object  {
    
    @objc dynamic var name : String?
    @objc dynamic var catchPhrase : String?
    @objc dynamic var bs : String?
    
    required convenience init(_ name: String?, catchPhrase: String?, bs: String?) {
            self.init()
        self.name = name
        self.catchPhrase = catchPhrase
        self.bs = bs
        }
    
}


