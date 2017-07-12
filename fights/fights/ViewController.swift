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
            let token = UserDefaults.standard.value(forKey: "token") as! String
            Alamofire.request("https://makub.ru/api/checktoken", method: .post, parameters: ["token": token]).responseJSON { response in
                if let json = response.result.value as? [String:Any] {
                    if(json["error"] as? Int ?? 100  == 0)
                    {
                        UserDefaults.standard.setValue(json["id"], forKey: "id")
                        
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
                        
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "login", sender: nil)
                        }
                        
                    }
                }
            }
        }

    }


}

