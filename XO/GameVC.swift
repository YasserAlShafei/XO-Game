//
//  GameVC.swift
//  XO
//
//  Created by Mohamed Zakout on 10/31/19.
//  Copyright © 2019 Mohamed Zakout. All rights reserved.
//

import UIKit
import FirebaseDatabase

class GameVC: UIViewController {
    
    @IBOutlet weak var board: UIStackView!
    
    @IBOutlet weak var c11: UIButton!
    @IBOutlet weak var c12: UIButton!
    @IBOutlet weak var c13: UIButton!
    @IBOutlet weak var c21: UIButton!
    @IBOutlet weak var c22: UIButton!
    @IBOutlet weak var c23: UIButton!
    @IBOutlet weak var c31: UIButton!
    @IBOutlet weak var c32: UIButton!
    @IBOutlet weak var c33: UIButton!
    
    var cells: [UIButton] = []
    
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var whoAmILabel: UILabel!
    @IBOutlet weak var startNewGameBTN: UIButton!
    @IBOutlet weak var exitBTN: UIButton!
    
    var turns = ["X", "O"]
    
    var turn: Int!
    var whoAmI: String!
    var gameCode: String!
    
    var dataRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        cells = [c11, c12, c13, c21, c22, c23, c31, c32, c33]
        dataRef = Database.database().reference().child("Games").child(gameCode)
        
        setupGame()
    }
    
    func setupGame() {
        
        dataRef.child("board").observe(.value) { (dataSnapShot) in
            let board = dataSnapShot.value as! [String : String]
            
            for cell in self.cells {
                let title = board[String(cell.tag)]
                cell.setTitle(title, for: .normal)
                if title == "X" {
                    cell.setTitleColor(.red, for: .normal)
                }else if title == "O" {
                    cell.setTitleColor(.orange, for: .normal)
                }
            }
            
            for (cell, value) in board {
                for button in self.cells {
                    if String(button.tag) == cell && value != "-"{
                        button.isEnabled = false
                    }
                }
            }
        }
        
        dataRef.child("turn").observe(.value) { (dataSnapShot) in
            let turn = dataSnapShot.value as! Int
            self.turnLabel.text = self.turns[turn]
            self.turnLabel.text == "X" ? (self.turnLabel.textColor = .red) : (self.turnLabel.textColor = .orange)
            self.turn = turn
            
            if self.turns[self.turn] == self.whoAmI {
                self.myTurn()
            }else {
                self.notMyTurn()
            }
        }
        
        dataRef.child("winner").observe(.value) { (dataSnapShot) in
            let winner = dataSnapShot.value as! String
            
            if winner != "-"{
                if winner == "No" {
                    self.showAlert("Shit", "No One Won!", false)
                }else if winner == self.whoAmI {
                    self.showAlert("Congrate", "You Won!", false)
                }else {
                    self.showAlert("Sorry", "You lost :(", false)
                }
                
                self.endGame()
            }
        }
        
        dataRef.child("isRunning").observe(.value) { (dataSnapshot) in
            
            let isRunning = dataSnapshot.value as! Bool
            
            if isRunning {
                self.startNewGame()
            }else {
                self.endGame()
            }
        }
        
        dataRef.child("isAvailable").observe(.value) { (dataSnapShot) in
            let isAvailable = dataSnapShot.value as! Bool
            
            if !isAvailable {
                self.showAlert("Error", "Player was exit", true)
            }
        }
        
        startNewGame()
    }
    
    func startNewGame(){
        
        for cell in cells {
            cell.setTitle("-", for: .normal)
            cell.isEnabled = true
        }
        
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
        
        dataRef.child("board").setValue(board)
        dataRef.child("winner").setValue("-")
        
        for cell in cells {
            cell.setTitle("-", for: .normal)
            cell.isEnabled = true
        }
        
        if turns[turn] == whoAmI {
            myTurn()
        }else {
            notMyTurn()
        }
        
        turnLabel.text = turns[turn]
        whoAmILabel.text = whoAmI
        turnLabel.text == "X" ? (turnLabel.textColor = .red) : (turnLabel.textColor = .orange)
        whoAmI == "X" ? (whoAmILabel.textColor = .red) : (whoAmILabel.textColor = .orange)
        startNewGameBTN.isHidden = true
    }
    
    @IBAction func play(_ sender: UIButton) {
        sender.setTitle(turns[turn], for: .normal)
        sender.isEnabled = false
        notMyTurn()
        dataRef.child("board").child("\(sender.tag)").setValue(turns[turn]) { (_, _) in
            self.check()
        }
    }
    
    func endGame() {
        dataRef.child("isRunning").setValue(false)
        
        startNewGameBTN.isHidden = false
        for cell in cells {
            cell.isEnabled = false
        }
    }
    
    @IBAction func newGame(_ sender: Any) {
        dataRef.child("isRunning").setValue(true)
    }
    
    @IBAction func exitGame(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func check() {
        if c11.titleLabel?.text! == c12.titleLabel?.text && c12.titleLabel?.text == c13.titleLabel?.text && c13.titleLabel?.text != "-"{
            dataRef.child("winner").setValue(turns[turn])
        }else if c21.titleLabel?.text! == c22.titleLabel?.text && c22.titleLabel?.text == c23.titleLabel?.text && c23.titleLabel?.text != "-"{
            dataRef.child("winner").setValue(turns[turn])
        }else if c31.titleLabel?.text! == c32.titleLabel?.text && c32.titleLabel?.text == c33.titleLabel?.text && c33.titleLabel?.text != "-"{
            dataRef.child("winner").setValue(turns[turn])
        }else if c11.titleLabel?.text! == c21.titleLabel?.text && c21.titleLabel?.text == c31.titleLabel?.text && c31.titleLabel?.text != "-"{
            dataRef.child("winner").setValue(turns[turn])
        }else if c12.titleLabel?.text! == c22.titleLabel?.text && c22.titleLabel?.text == c32.titleLabel?.text && c32.titleLabel?.text != "-"{
            dataRef.child("winner").setValue(turns[turn])
        }else if c13.titleLabel?.text! == c23.titleLabel?.text && c23.titleLabel?.text == c33.titleLabel?.text && c33.titleLabel?.text != "-"{
            dataRef.child("winner").setValue(turns[turn])
        }else if c11.titleLabel?.text! == c22.titleLabel?.text && c22.titleLabel?.text == c33.titleLabel?.text && c33.titleLabel?.text != "-"{
            dataRef.child("winner").setValue(turns[turn])
        }else if c13.titleLabel?.text! == c22.titleLabel?.text && c22.titleLabel?.text == c31.titleLabel?.text && c31.titleLabel?.text != "-"{
            dataRef.child("winner").setValue(turns[turn])
        }else {
            var isEnded = true
            
            for cell in cells {
                if cell.titleLabel?.text == "-" {
                    isEnded = false
                    break
                }
            }
            
            if isEnded {
                dataRef.child("winner").setValue("No")
            }else {
                nextTurn()
            }
        }
    }
    
    func nextTurn() {
        turn == 0 ? (turn = 1) : (turn = 0)
        turnLabel.text = turns[turn]
        dataRef.child("turn").setValue(turn)
    }
    
    func myTurn() {
        board.isUserInteractionEnabled = true
    }
    
    func notMyTurn(){
        board.isUserInteractionEnabled = false
    }

    func showAlert(_ title: String, _ message: String, _ dismiss: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if dismiss {
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                self.dismiss(animated: true)
            }))
        }else {
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        }
        present(alert, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dataRef.child("isAvailable").setValue(false)
    }
}
