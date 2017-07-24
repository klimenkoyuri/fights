//
//  AddComment.swift
//  fights
//
//  Created by Юрий on 24.07.17.
//  Copyright © 2017 Styleru. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class AddComment: UIViewController {

    @IBOutlet var comment: UITextView!
    var gameId: Int!
    var playerId: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(gameId)
        // Do any additional setup after loading the view.
        comment.placeholderText = "Оставляя комментарий помните, что нужно давать не только негатив, но и позитив"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func add(_ sender: UIButton) {
        DispatchQueue.main.async{
            let fetchRequest:NSFetchRequest<Player> = Player.fetchRequest()
            
            do{
                let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
                for result in searchResults as [Player]{
                    self.playerId = Int(result.id)
                }
                
            }
            catch
            {
                
            }

            let token = UserDefaults.standard.value(forKey: "token") as! String
            print(token)
            print(self.gameId)
            print(self.playerId)
            print(self.comment.text)
            Alamofire.request("https://makub.ru/api/add_comment", method: .post, parameters: ["token": token, "game_id": self.gameId, "comment": self.comment.text, "player_id": self.playerId])
                .responseJSON() { response in
                    if let json = response.result.value as? [String:Any] {
                        if(json["error"] as? Int ?? 100  == 0)
                        {
                            _ = self.navigationController?.popViewController(animated: true)
                        }
                    }
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
