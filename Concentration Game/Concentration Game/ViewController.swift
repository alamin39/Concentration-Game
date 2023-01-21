//
//  ViewController.swift
//  Concentration Game
//
//  Created by Al-Amin on 2023/01/21.
//

import UIKit

enum Box: Int {
    case zero, one, two, three, four, five, six, seven, eight, nine,
         ten, eleven, twelve, thirteen, fourteen, fifteen
}


class ViewController: UIViewController {
    
    @IBOutlet weak var playerOneLabel: UILabel!
    @IBOutlet weak var playerTwoLabel: UILabel!
    @IBOutlet weak var player1Score: UILabel!
    @IBOutlet weak var player2Score: UILabel!
    @IBOutlet weak var playerOneLine: UIView!
    @IBOutlet weak var playerTwoLine: UIView!
    
    @IBOutlet weak var box0: UILabel!
    @IBOutlet weak var box1: UILabel!
    @IBOutlet weak var box2: UILabel!
    @IBOutlet weak var box3: UILabel!
    @IBOutlet weak var box4: UILabel!
    @IBOutlet weak var box5: UILabel!
    @IBOutlet weak var box6: UILabel!
    @IBOutlet weak var box7: UILabel!
    @IBOutlet weak var box8: UILabel!
    @IBOutlet weak var box9: UILabel!
    @IBOutlet weak var box10: UILabel!
    @IBOutlet weak var box11: UILabel!
    @IBOutlet weak var box12: UILabel!
    @IBOutlet weak var box13: UILabel!
    @IBOutlet weak var box14: UILabel!
    @IBOutlet weak var box15: UILabel!
    
    private var boxValues = [String]()
    private var playerChoices: [UILabel] = []
    private var banishedBoxCount = 0
    private var playerOneScore = 0
    private var playerTwoScore = 0
    private var noOfTurn = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetGame()
    }
    
    private func resetGame() {
        banishedBoxCount = 0
        playerOneScore = 0
        playerTwoScore = 0
        noOfTurn = 0
        boxValues = []
        player1Score.text = "0"
        player2Score.text = "0"
        playerOneLine.backgroundColor = .systemYellow
        playerTwoLine.backgroundColor = .white
        setBoxValues()
        addTapGestures()
    }
    
    private func setBoxValues() {
        let randomValues = getUniqueRandomNumbers(min: 0, max: 15, count: 16)
        let startingValue = Int(("A" as UnicodeScalar).value)
        for value in randomValues {
            let temp = Character(UnicodeScalar(value % 8 + startingValue)!)
            boxValues.append(String(temp))
        }
    }
    
    private func getUniqueRandomNumbers(min: Int, max: Int, count: Int) -> [Int] {
        var set = Set<Int>()
        while set.count < count {
            set.insert(Int.random(in: min...max))
        }
        return Array(set)
    }
    
    private func addTapGestures() {
        createTap(on: box0, type: .zero)
        createTap(on: box1, type: .one)
        createTap(on: box2, type: .two)
        createTap(on: box3, type: .three)
        createTap(on: box4, type: .four)
        createTap(on: box5, type: .five)
        createTap(on: box6, type: .six)
        createTap(on: box7, type: .seven)
        createTap(on: box8, type: .eight)
        createTap(on: box9, type: .nine)
        createTap(on: box10, type: .ten)
        createTap(on: box11, type: .eleven)
        createTap(on: box12, type: .twelve)
        createTap(on: box13, type: .thirteen)
        createTap(on: box14, type: .fourteen)
        createTap(on: box15, type: .fifteen)
    }
    
    private func createTap(on boxView: UILabel, type box: Box) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.boxClicked(_:)))
        tap.name = "\(box.rawValue)"
        tap.numberOfTapsRequired = 1
        boxView.isUserInteractionEnabled = true
        boxView.addGestureRecognizer(tap)
        boxView.backgroundColor = .systemPurple
    }
    
    @IBAction func newGamePressed(_ sender: Any) {
        resetGame()
    }
    
    @objc func boxClicked(_ sender: UITapGestureRecognizer) {
        guard let boxNo = Int(sender.name!) else { return }
        let selectedBox = getBox(from: boxNo)
        if (playerChoices.count == 1 && playerChoices[0] == selectedBox) {
            return
        }
        selectedBox.text = boxValues[boxNo]
        selectedBox.backgroundColor = .yellow
        playerChoices.append(selectedBox)
        
        if (playerChoices.count == 2) {
            noOfTurn += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if(self.playerChoices[0].text == self.playerChoices[1].text) {
                    self.playerChoices[0].backgroundColor = .black
                    self.playerChoices[1].backgroundColor = .black
                    self.playerChoices[0].isUserInteractionEnabled = false
                    self.playerChoices[1].isUserInteractionEnabled = false
                    self.banishedBoxCount += 2
                    if (self.noOfTurn % 2 == 1) {
                        self.playerOneScore += 1
                        self.player1Score.text = "\(self.playerOneScore)"
                    }
                    else {
                        self.playerTwoScore += 1
                        self.player2Score.text = "\(self.playerTwoScore)"
                    }
                    self.noOfTurn -= 1
                }
                else {
                    self.playerChoices[0].backgroundColor = .systemPurple
                    self.playerChoices[1].backgroundColor = .systemPurple
                }
                
                self.playerChoices[0].text = ""
                self.playerChoices[1].text = ""
                self.playerChoices = []
                self.checkIfWon(self.banishedBoxCount)
                self.highlightPlayer(self.noOfTurn-1)
            }
        }
    }
    
    private func highlightPlayer(_ turnNo: Int) {
        if (turnNo%2 == 1) {
            playerOneLine.backgroundColor = .systemYellow
            playerTwoLine.backgroundColor = .white
        }
        else {
            playerOneLine.backgroundColor = .white
            playerTwoLine.backgroundColor = .systemYellow
        }
    }
    
    private func checkIfWon(_ boxCount: Int) {
        if boxCount == boxValues.count {
            var winner = "Player 1 wins!!"
            if (playerOneScore == playerTwoScore) {
                winner = "Draw!!"
            }
            else if (playerOneScore < playerTwoScore) {
                winner = "Player 2 wins!!"
            }
            
            let alert = UIAlertController(title: winner, message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
                self?.resetGame()
            })
            present(alert, animated: true)
        }
    }
    
    
    private func getBox(from number: Int) -> UILabel {
        let box = Box(rawValue: number)
        
        switch box {
        case .zero:
            return box0
        case .one:
            return box1
        case .two:
            return box2
        case .three:
            return box3
        case .four:
            return box4
        case .five:
            return box5
        case .six:
            return box6
        case .seven:
            return box7
        case .eight:
            return box8
        case .nine:
            return box9
        case .ten:
            return box10
        case .eleven:
            return box11
        case .twelve:
            return box12
        case .thirteen:
            return box13
        case .fourteen:
            return box14
        case .fifteen:
            return box15
        case .none:
            return box0
        }
    }
}
