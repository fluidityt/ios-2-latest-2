//
//  MenuVC.swift
//  Pong
//
//  Created by James Kirkwood on 18/03/2017.
//  Copyright © 2017 James Kirkwood. All rights reserved.
//

import Foundation
import UIKit

enum GameType {
    case easy
    case wobble
    case player2

}

var currentGameType: GameType = .easy

class MenuVC : UIViewController {
    
    @IBAction func Player2(_ sender: Any) {
        moveToGame(game: .player2)
    }
    @IBAction func Easy(_ sender: Any) {
        moveToGame(game: .easy)
    }
    @IBAction func Wobble(_ sender: Any) {
        moveToGame(game: .wobble)
    }
    
    func moveToGame(game: GameType) {
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "gameVC") as! GameViewController
        
        currentGameType = game
        
        self.navigationController?.pushViewController(gameVC, animated: true)
    
    }
}
