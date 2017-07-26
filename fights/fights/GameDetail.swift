//
//  GameDetail.swift
//  fights
//
//  Created by Юрий on 23.07.17.
//  Copyright © 2017 Styleru. All rights reserved.
//

import UIKit
import Alamofire

class GameDetail: UITableViewController {
    
    var gameId: Int!
    var comments: NSMutableArray!
    var flag: Bool! = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        DispatchQueue.main.async{
            let token = UserDefaults.standard.value(forKey: "token") as! String
            Alamofire.request("https://makub.ru/api/get_comments", method: .post, parameters: ["token": token, "game_id": self.gameId])
                .responseJSON(){ response in
                    if let json = response.result.value as? [String:Any] {
                        if(json["error"] as? Int ?? 100  == 0)
                        {
                            self.comments = (json["comments"] as! NSArray).mutableCopy() as! NSMutableArray
                            self.flag = true
                            self.tableView.reloadData()
                        }
                    }
                }

            
        }
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
       
        if(UserDefaults.standard.value(forKey: "refresh")  != nil)
        {
            DispatchQueue.main.async{
                UserDefaults.standard.removeObject(forKey: "refresh")
                let token = UserDefaults.standard.value(forKey: "token") as! String
                Alamofire.request("https://makub.ru/api/get_comments", method: .post, parameters: ["token": token, "game_id": self.gameId])
                    .responseJSON(){ response in
                        if let json = response.result.value as? [String:Any] {
                            if(json["error"] as? Int ?? 100  == 0)
                            {
                                self.comments = (json["comments"] as! NSArray).mutableCopy() as! NSMutableArray
                                self.flag = true
                                self.tableView.reloadData()
                            }
                        }
                }
                
                
            }

        }
        else
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
        if(self.flag)
        {
            return self.comments.count + 1
        }
        else{
            return 1
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0)
        {
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "write", for: indexPath)
            return cell
        }
        else{
            let cell:CommentTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as! CommentTableViewCell
            let comment = self.comments[indexPath.row - 1] as! NSDictionary
            if(Int(comment.object(forKey: "player_id") as! String) == 0)
            {
                cell.Author.text = String(format: "Автор: Арбитр", comment.object(forKey: "surname") as! String)
            }
            else{
                cell.Author.text = String(format: "Автор: %@ %@", comment.object(forKey: "surname") as! String, comment.object(forKey: "name") as! String)
            }
            cell.comment.text = String(format: "%@", comment.object(forKey: "comment") as! String)
            cell.player_id = Int(comment.object(forKey: "player_id") as! String)
            return cell
            
        }

        // Configure the cell...

        
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
        if(segue.identifier == "addcomment")
        {
            let dest = segue.destination as! AddComment
            dest.gameId = self.gameId
        }
    }
 

}
