//
//  DBHelper.swift
//  ApiToSqulite
//
//  Created by apple on 04/07/24.
//

import Foundation
 import SQLite3


class DBHelper {
    static let shared = DBHelper()
    var db: OpaquePointer?
    
    private init() {
       openDataBase()
        createTable()
    }
    
    func openDataBase(){
        let fileURL =  try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("user.sqlite")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
    }
    
    func createTable() {
        let createTableString = """
            CREATE TABLE IF NOT EXISTS User(
                Id INTEGER PRIMARY KEY AUTOINCREMENT,
                Email TEXT,
                Username TEXT,
                Password TEXT,
                Phone TEXT,
                FirstName TEXT,
                LastName TEXT);
            """
        
        var createTableStatment : OpaquePointer?
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatment, nil) == SQLITE_OK{
            if sqlite3_step(createTableStatment) == SQLITE_DONE{
                print("User table created.")
            } else {
                print("User table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatment)
            
    }
    func insertUser(_ user: User) {
        let insertStatementString = """
            INSERT INTO User (Email, Username, Password, Phone, FirstName, LastName) VALUES (?, ?, ?, ?, ?, ?);
            """
        
        var insertStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (user.email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (user.username as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (user.password as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (user.phone as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (user.name.firstname as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (user.name.lastname as NSString).utf8String, -1, nil)

            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row. Error: \(String(cString: sqlite3_errmsg(db)))")
            }
        } else {
            print("INSERT statement could not be prepared. Error: \(String(cString: sqlite3_errmsg(db)))")
        }
        sqlite3_finalize(insertStatement)
    }



    func getAllUsers() -> [User] {
        let queryStatementString = "SELECT * FROM User;"
        var queryStatement: OpaquePointer?
        var users: [User] = []

        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let email = String(cString: sqlite3_column_text(queryStatement, 1))
                let username = String(cString: sqlite3_column_text(queryStatement, 2))
                let password = String(cString: sqlite3_column_text(queryStatement, 3))
                let phone = String(cString: sqlite3_column_text(queryStatement, 4))
                let firstname = String(cString: sqlite3_column_text(queryStatement, 5))
                let lastname = String(cString: sqlite3_column_text(queryStatement, 6))

                let user = User(id: Int(id), email: email, username: username, password: password, name: Name(firstname: firstname, lastname: lastname), phone: phone)
                users.append(user)
                print("Data retrieved successfully")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return users
    }
    
}
