//
//  ViewController.swift
//  Project7
//
//  Created by Oscar Lui on 28/2/2022.
//

import UIKit

class ViewController: UITableViewController {
    var petitions:[Petition] = []
    var filteredP:[Petition] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(showApi)),
            UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterP)),
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshpage))]
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
           
        }
    
    @objc func fetchJSON() {
        let urlString:String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        
            
        if let url = URL(string:urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    func search(_ keywords:String) {
        for item in petitions {
            if item.title.lowercased().contains(keywords.lowercased()) == false{
                guard let i = petitions.firstIndex(of: item) else { return  }
                petitions.remove(at: i)
                tableView.reloadData()
            }
        }
    }
       
    @objc func refreshpage() {
        petitions = filteredP
        tableView.reloadData()
    }
    
    @objc func filterP() {
        let ac = UIAlertController(title: "Search", message: "Please enter your keywords", preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title:"Submit",style: .default) {
            [weak self,weak ac] _ in
            guard let keywords = ac?.textFields?[0].text else {
                return
            }
            self?.search(keywords)
        }
        
        ac.addAction(submitAction)

        present(ac,animated: true)
        
        }
    
    @objc func showApi() {
        
        let ac = UIAlertController(title: "Data description", message: "The data comes from the We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac,animated: true)
    }
    
    @objc func showError(){
       
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac,animated: true)
            
        
    }
    
    func parse(json:Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            filteredP = petitions
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
            
        } else {
            
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
            
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

