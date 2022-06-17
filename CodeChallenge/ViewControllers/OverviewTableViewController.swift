//
//  OverviewTableViewController.swift
//  CodeChallenge
//
//  Created by Allan Jasa on 16/06/2022.
//

import UIKit

class OverviewTableViewController: UITableViewController {

    private var entries: [PostData]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        entries = Utils.getAllPostDataFromRealm()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        20.0 // Just to give it a little space
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        
        let postData = entries[indexPath.row]
        var content = UIListContentConfiguration.subtitleCell()
        
        content.text = postData.total
        content.secondaryText = postData.currency
        
        cell.contentConfiguration = content

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postData = entries[indexPath.row]
        
        let postVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        postVC.postData = postData
        navigationController?.pushViewController(postVC, animated: true)

    }
    


}
