//
//  Person.swift
//  ApiToSqulite
//
//  Created by apple on 04/07/24.
//

import Foundation
struct User : Decodable{
    //var address : Address
    var id : Int
    var email : String
    var username : String
    var password : String
    var name : Name
    var phone : String
    var v : Int?
    
    enum CodingKeys : String,CodingKey{
        //case address
        case id
        case email
        case username
        case password
        case name
        case phone
        case v = "_v"
    }

}

struct Name : Decodable {
    var firstname : String
    var lastname : String
    
}
//struct Address : Decodable{
//    var geolocation : Geolocation
//    var city : String
//    var street : String
//    var number : Int
//    var zipcode : String
//}

struct Geolocation : Decodable{
    var lat : String
    var long : String
}

