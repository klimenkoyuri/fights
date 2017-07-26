//
//  MyGamesTableViewController.swift
//  fights
//
//  Created by Юрий on 13.07.17.
//  Copyright © 2017 Styleru. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class MyGamesTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var games_count = 0
    var player_id: Int!
    var surname:String!
    var name: String!
    var games: [NSDictionary]! = []
    var idGameToDetail: Int!
    var getData: Bool! = false
    var searchController: UISearchController!
    var searchResults: [NSDictionary]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        self.tableView.tableHeaderView = searchController.searchBar
        self.searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        DispatchQueue.main.async{
        let token = UserDefaults.standard.value(forKey: "token") as! String
            Alamofire.request("https://makub.ru/api/my_games_count", method: .post, parameters: ["token": token])
                .responseJSON() { response in
                if let json = response.result.value as? [String:Any] {
                    if(json["error"] as? Int ?? 100  == 0)
                    {
                        self.games_count = json["count"] as! Int
                        var to = 1000
                        if(self.games_count < 1000)
                        {
                            to = self.games_count
                        }
                        Alamofire.request("https://makub.ru/api/my_games", method: .post, parameters: ["token": token, "from": 0, "to": to ])
                            .responseJSON(){ response in
                                if let json2 = response.result.value as? [String:Any] {
                                    if(json2["error"] as? Int ?? 100  == 0)
                                    {
                                        self.games = json2["games"] as! Array
                                        self.getData = true
                                        
                                        self.tableView.reloadData()
                                    }
                                }
                        }
                        
                        
                        
                    }
                    else{
                        
                    }
                }
            
            }
        }
       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let fetchRequest:NSFetchRequest<Player> = Player.fetchRequest()
        
        do{
            let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
            for result in searchResults as [Player]{
                self.player_id = Int(result.id)
                self.name = result.name
                self.surname = result.surname
                
            }
            
        }
        catch
        {
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive
        {
            return self.searchResults.count
        }
        else
        {
            if(self.games_count == 0)
            {
                return 0
            }
            else{
                return self.games.count
            }
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:GameTableViewCell = tableView.dequeueReusableCell(withIdentifier: "game", for: indexPath) as! GameTableViewCell
        
        var cellArrays: [NSDictionary]
        if searchController.isActive
        {
            cellArrays = searchResults
        }
        else
        {
            cellArrays = games
        }
        
        let game = cellArrays[indexPath.row]
        
        cell.player1.text = self.surname + " " + self.name
        cell.score.text = String(format: "%@:%@", game.object(forKey: "our_score") as! String, game.object(forKey: "his_score") as! String )
        cell.player2.text = String(format: "%@ %@", game.object(forKey: "surname") as! String, game.object(forKey: "name") as! String)
        cell.game_id = Int(game.object(forKey: "id") as! String)
        
        // Configure the cell...

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexOfCell = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexOfCell) as! GameTableViewCell
        idGameToDetail = currentCell.game_id
        performSegue(withIdentifier: "to detail", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(getData)
        {
        let lastElement = self.games.count - 1
            if(lastElement == indexPath.row && self.games.count != games_count)
            {
                DispatchQueue.main.async{
                    let from = lastElement + 1
                    var to: Int! = 0
                    let needMore = self.games_count - self.games.count - 1000
                    if(needMore > 0)
                    {
                        to = 1000
                    }
                    else{
                        to = self.games_count - self.games.count
                    }
                    let token = UserDefaults.standard.value(forKey: "token") as! String
                    Alamofire.request("https://makub.ru/api/my_games", method: .post, parameters: ["token": token, "from": from, "to": to ])
                        .responseJSON() { response in
                            if let json = response.result.value as? [String:Any] {
                                if(json["error"] as? Int ?? 100  == 0)
                                {
                                    let inserts : [NSDictionary] = json["games"] as! Array
                                    for game in inserts{
                                        self.games.append(game)
                                    }
                                    self.tableView.reloadData()
                                    
                                }
                            }
                    }
                }
            }
        }
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "to detail") {
            let viewController =  segue.destination as? GameDetail
            viewController?.gameId = self.idGameToDetail
        }
        
    }
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text
        {
            self.searchResults = self.games!.filter({game in
                let sn = (game.object(forKey: "surname") as! String).range(of: searchText)
                
                let n = (game.object(forKey: "name") as! String).range(of: searchText)
                return sn != nil || n != nil
            })
            self.tableView.reloadData()
        }
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive
        {
            return false
        }
        else
        {
            return true
        }
    }

    


}
