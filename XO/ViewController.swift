//
//  ViewController.swift
//  XO
//
//  Created by Mohamed Zakout on 10/31/19.
//  Copyright © 2019 Mohamed Zakout. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SwiftyCodeView
import MBProgressHUD


class ViewController: UIViewController {
    
    @IBOutlet weak var gameCodeInput: SwiftyCodeView!
    @IBOutlet weak var enterGameBTN: UIButton!
    
    var dataBaseRef: DatabaseReference!
    var gameCode: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        gameCodeInput.delegate = self
        dataBaseRef = Database.database().reference().child("Games")
    }
    
    
    
    @IBAction func startGame(_ sender: Any) {
        startGame()
    }
    
    @IBAction func startGameGuest(_ sender: Any) {
        startGuestGame()
    }
    
    @IBAction func enterGame(_ sender: Any) {
        enterGame()
    }
    
    func startGame() {
        let code = generateGameCode(length: 4)
        gameCode = code
        let firstPlayer = randomPlayer()
        let secondPlayer = firstPlayer == "X" ? "O" : "X"
        let turn = random()
        
        let board: [String : String] = ["11" : "-",
                                        "12" : "-",
                                        "13" : "-",
                                        "21" : "-",
                                        "22" : "-",
                                        "23" : "-",
                                        "31" : "-",
                                        "32" : "-",
                                        "33" : "-",
        ]
        
        let game: [String : Any] = ["gameCode" : code,
                                    "firstPlayer" : firstPlayer,
                                    "secondPlayer" : secondPlayer,
                                    "turn" : turn,
                                    "winner" : "-",
                                    "board" : board,
                                    "isRunning" : true,
                                    "isFull" : false,
                                    "isAvailable" : true,
                                    "Connection" : true
        ]
        
        dataBaseRef.child(code).setValue(game)
        dataBaseRef.child(code).observe(.value, with: { (dataSnapshot) in
            let game = dataSnapshot.value as! [String:Any]
            let isFull = game["isFull"] as! Bool
            
            if isFull {
                // Hide progress
                MBProgressHUD.hide(for: self.view, animated: true)
                self.performSegue(withIdentifier: "NewGame", sender: game)
            }
        })
        
        // Show Game Code with Progress
        let progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        progressHUD.animationType = .zoomOut
        progressHUD.mode = .indeterminate
        progressHUD.label.text = "\nYour Game Code is \(code)"
        progressHUD.label.numberOfLines = 2
        progressHUD.label.font = UIFont.boldSystemFont(ofSize: 16)
        progressHUD.detailsLabel.text = "\nWaiting For player\n"
        progressHUD.detailsLabel.font = UIFont.boldSystemFont(ofSize: 15)
        progressHUD.button.setTitle("Cancel", for: .normal)
        progressHUD.button.addTarget(self, action: Selector(("removeGame")), for: .touchUpInside)
        progressHUD.button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
    }
    
    func startGuestGame() {
        print("Click")
    }
    
    @objc
    func removeGame() {
        MBProgressHUD.hide(for: view, animated: true)
        dataBaseRef.child(gameCode).removeAllObservers()
        dataBaseRef.child(gameCode).setValue(nil)
    }
    
    func enterGame() {
        let progress = MBProgressHUD.showAdded(to: view, animated: true)
        progress.label.text = "Connecting"
        
        dataBaseRef.child(gameCode).observeSingleEvent(of: .value) { (dataSnapshot) in
            if let game = dataSnapshot.value as? [String:Any] {
                let isAvailable = game["isAvailable"] as! Bool
                let isFull = game["isFull"] as! Bool
                
                if isAvailable && !isFull {
                    self.dataBaseRef.child(self.gameCode).child("isFull").setValue(true)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.performSegue(withIdentifier: "EnterGame", sender: game)
                }else {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.showAlert(title: "Error", message: "Game Not Available")
                }
                
            }else {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.showAlert(title: "Error", message: "Game Not Available")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToGameGuest" {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "GameGuestVC") as! GameGuestVC
            self.present(vc, animated: true, completion: nil)
        }else{
            let vc = segue.destination as! GameVC
            let game = sender as! [String:Any]
            
            vc.gameCode = game["gameCode"] as? String
            vc.turn = game["turn"] as? Int
            
            if segue.identifier == "NewGame" {
                vc.whoAmI = game["firstPlayer"] as? String
            }else {
                vc.whoAmI = game["secondPlayer"] as? String
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func generateGameCode(length: Int) -> String {
        let letters = "0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func random() -> Int {
        return Int.random(in: 0...1)
    }
    
    func randomPlayer() -> String {
        return ["X", "O"].randomElement()!
    }
}






extension ViewController: SwiftyCodeViewDelegate {
    func codeViewIsNotFull() {
        enterGameBTN.isEnabled = false
    }
    
    func codeView(sender: SwiftyCodeView, didFinishInput code: String) {
        gameCode = code
        enterGameBTN.isEnabled = true
        enterGame()
    }
}
