//
//  ViewController.swift
//  fights
//
//  Created by Юрий on 12.07.17.
//  Copyright © 2017 Styleru. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class ViewController: UIViewController {

    @IBOutlet var login: UITextField!
    @IBOutlet var pass: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if (UserDefaults.standard.value(forKey: "token") != nil)
            {
            DispatchQueue.main.async
            {
                let token = UserDefaults.standard.value(forKey: "token") as! String
                Alamofire.request("https://makub.ru/api/checktoken", method: .post, parameters: ["token": token]).responseJSON { response in
                    if let json = response.result.value as? [String:Any] {
                        if(json["error"] as? Int ?? 100  == 0)
                        {
                            
                            let fetchRequest:NSFetchRequest<Player> = Player.fetchRequest()
                            fetchRequest.predicate = NSPredicate(format: "id = %d", Int16((json["id"] as! NSString).intValue))
                            
                            do{
                                let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
                                for result in searchResults as [Player]{
                                    DatabaseController.getContext().delete(result)
                                }
                                
                            }
                            catch
                            {
                                
                            }
                        
                        let player: Player =  NSEntityDescription.insertNewObject(forEntityName: "Player",into: DatabaseController.getContext()) as! Player
                        player.name = json["name"] as? String;
                        player.surname = json["surname"] as? String
                        player.id = Int16((json["id"] as! NSString).intValue)
                        player.club_id = Int16((json["club_id"] as! NSString).intValue)
                        player.rating = Int16((json["rating_of_player"] as! NSString).intValue)
                        
                        UserDefaults.standard.setValue(Int16((json["id"] as! NSString).intValue), forKey: "id")
                            DatabaseController.saveContext()
                         self.performSegue(withIdentifier: "login", sender: nil)
                        }
                    }
                }
                
                
            }


        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func login_button(_ sender: UIButton) {
        //проверка на заполнения поля
        if (login.text?.isEmpty)! || (pass.text?.isEmpty)! {
            let alert = UIAlertController(title: "Заполните поля", message: "Поле логин и пароль обязательно к заполнению", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Понятно", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            
            
            Alamofire.request("https://makub.ru/api/login", method: .post, parameters: ["login": login.text!, "pass":pass.text!]).responseJSON { response in
                
                if let json = response.result.value as? [String:Any] {
                    
                    if(json["error"] as! Int == 0)
                    {
                        
                        let token = json["token"]!
                        UserDefaults.standard.setValue(token, forKey: "token")
                        //получить данные в кордату и пойти на след экран
                        Alamofire.request("https://makub.ru/api/checktoken", method: .post, parameters: ["token": token]).responseJSON { response in
                            if let json2 = response.result.value as? [String:Any] {
                                if(json2["error"] as? Int ?? 100  == 0)
                                {
                                    
                                    let fetchRequest:NSFetchRequest<Player> = Player.fetchRequest()
                                    fetchRequest.predicate = NSPredicate(format: "id = %d", Int16((json2["id"] as! NSString).intValue))
                                    
                                    do{
                                        let searchResults = try DatabaseController.getContext().fetch(fetchRequest)
                                        for result in searchResults as [Player]{
                                            DatabaseController.getContext().delete(result)
                                        }
                                        
                                    }
                                    catch
                                    {
                                        
                                    }
                                    
                                    let player: Player =  NSEntityDescription.insertNewObject(forEntityName: "Player",into: DatabaseController.getContext()) as! Player
                                    player.name = json2["name"] as? String;
                                    player.surname = json2["surname"] as? String
                                    player.id = Int16((json2["id"] as! NSString).intValue)
                                    player.club_id = Int16((json2["club_id"] as! NSString).intValue)
                                    player.rating = Int16((json2["rating_of_player"] as! NSString).intValue)
                                    
                                    UserDefaults.standard.setValue(Int16((json2["id"] as! NSString).intValue), forKey: "id")
                                    DatabaseController.saveContext()
                                    self.performSegue(withIdentifier: "login", sender: nil)
                                }
                            }
                        }
                        
                    }
                }
            }
        }

    }


}

