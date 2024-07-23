//
//  ServerViewController.swift
//  ApiToSqulite
//
//  Created by apple on 04/07/24.
//

import UIKit

class ServerViewController: UIViewController {
    var url: URL?
    var urlSession: URLSession?
    var urlRequest: URLRequest?
    var user: [User] = []
    var filteredUser: [User] = []
    
    @IBOutlet weak var searchData: UISearchBar!
    @IBOutlet weak var userTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        getServerResponse()
        setupSearchBar()
    }

    func setupTableView() {
        let uiNib = UINib(nibName: "UserTableViewCell", bundle: nil)
        self.userTableView.register(uiNib, forCellReuseIdentifier: "UserTableViewCell")
        self.userTableView.delegate = self
        self.userTableView.dataSource = self
    }
    
    func setupSearchBar() {
        searchData.delegate = self
    }

    func getServerResponse() {
        url = URL(string: "https://fakestoreapi.com/users")
        urlRequest = URLRequest(url: url!)
        urlRequest?.httpMethod = "GET"
        urlSession = URLSession(configuration: .default)
        let dataTask = urlSession?.dataTask(with: urlRequest!) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                let response = try jsonDecoder.decode([User].self, from: data)
                self.user = response
                self.filteredUser = response // Initialize filtered array with all users
                
                print(response)
                
                for user in self.user {
                    DBHelper.shared.insertUser(user)
                }
                DispatchQueue.main.async {
                    self.userTableView.reloadData()
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        dataTask?.resume()
    }
}

extension ServerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUser.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.userTableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        cell.idLabel.text = String(filteredUser[indexPath.row].id)
        cell.nameLabel.text = "\(filteredUser[indexPath.row].name.firstname ?? "")"
        cell.emailLabel.text = "\(filteredUser[indexPath.row].email)"
        cell.userNameLabel.text = "\(filteredUser[indexPath.row].username)"
        cell.phoneLabel.text = "\(filteredUser[indexPath.row].phone)"
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
}

extension ServerViewController: UISearchBarDelegate {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredUser = user // If search bar is empty, show all users
        } else {
            filteredUser = user.filter { user in
                // Check if any of the fields contain the searchText
                let searchString = searchText.lowercased()
                
                // Check user fields
                let fields = [
                    "\(user.id)",
                    user.email.lowercased(),
                    user.username.lowercased(),
                    user.password.lowercased(),
                    "\(user.phone)",
                    "\(user.v ?? 0)", // Convert optional to non-optional for comparison
                    "\(user.name.firstname.lowercased()) \(user.name.lastname.lowercased())"
                ]
                
                // Return true if any field contains the search string
                return fields.contains { $0.contains(searchString) }
            }
        }
        userTableView.reloadData()
    }
}
