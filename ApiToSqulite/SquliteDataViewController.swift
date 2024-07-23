//
//  SquliteDataViewController.swift
//  ApiToSqulite
//
//  Created by apple on 04/07/24.
//

import UIKit

class SquliteDataViewController: UIViewController {

    @IBOutlet weak var squliteDataTableView: UITableView!
    
    var user : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        xib()
        getSqliteData()
    }
    
    func xib(){
        let UiNib =  UINib(nibName: "SqliteTableViewCell", bundle: nil)
        self.squliteDataTableView.register(UiNib, forCellReuseIdentifier: "SqliteTableViewCell")
    }
    func getSqliteData(){
        user = DBHelper.shared.getAllUsers()
        
        DispatchQueue.main.async {
            self.squliteDataTableView.reloadData()
        }
    }

   
}

extension SquliteDataViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return user.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SqliteTableViewCell", for: indexPath) as! SqliteTableViewCell
        
        let user = user[indexPath.row]
        cell.sIdLabel.text = "\(user.id)"
        cell.sNameLabel.text = "\(user.name)"
        cell.sEmailLabel.text = "\(user.email)"
        cell.sUserNameLabel.text = "\(user.username)"
        cell.sFirstNameLabel.text = "\(user.name.firstname)"
       
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    }
    
    


