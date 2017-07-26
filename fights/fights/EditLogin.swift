//
//  EditLogin.swift
//  fights
//
//  Created by Юрий on 25.07.17.
//  Copyright © 2017 Styleru. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class EditLogin: UIViewController, UITextFieldDelegate {

    @IBOutlet var login: UITextField!
    @IBOutlet var pass: UITextField!
    @IBOutlet var pass2: UITextField!
    var playerId: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pass2.delegate = self
        // Do any additional setup after loading the view.
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("[eq nfv")
        if pass.text != pass2.text
        {
            let alert = UIAlertController(title: "Пароли не совпадают", message: "Введите пароль еще раз", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ОК", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            if login.text == "" || pass.text == ""
            {
                let alert = UIAlertController(title: "Поля не заполнены", message: "логин и пароль обязательны к заполнению", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "ОК", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
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
                    Alamofire.request("https://makub.ru/api/edit_login_pass", method: .post, parameters: ["token": token, "id": self.playerId, "login": self.login.text!, "pass": self.pass.text!])
                        .responseJSON() { response in
                            if let json = response.result.value as? [String:Any] {
                                if(json["error"] as? Int ?? 100  == 0)
                                {
                                    self.navigationController?.popViewController(animated: true)
                                }
                                if(json["error"] as? Int ?? 100  == 5)
                                {
                                    let alert = UIAlertController(title: "Логин уже заняти", message: "выберите другой логин", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "ОК", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                    }
                    
                    
                }
            }
        }

        
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func change(_ sender: UIButton) {
        if pass.text != pass2.text
        {
            let alert = UIAlertController(title: "Пароли не совпадают", message: "Введите пароль еще раз", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ОК", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            if login.text == "" || pass.text == ""
            {
                let alert = UIAlertController(title: "Поля не заполнены", message: "логин и пароль обязательны к заполнению", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "ОК", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
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
                    Alamofire.request("https://makub.ru/api/edit_login_pass", method: .post, parameters: ["token": token, "id": self.playerId, "login": self.login.text!, "pass": self.pass.text!])
                        .responseJSON() { response in
                            if let json = response.result.value as? [String:Any] {
                                if(json["error"] as? Int ?? 100  == 0)
                                {
                                    _ = self.navigationController?.popViewController(animated: true)
                                }
                                if(json["error"] as? Int ?? 100  == 5)
                                {
                                    let alert = UIAlertController(title: "Логин уже заняти", message: "выберите другой логин", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "ОК", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
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
