//
//  ViewController.swift
//  Project2
//
//  Created by  Vladislav Bondarev on 06.12.2019.
//  Copyright © 2019 Vladislav Bondarev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var Button3: UIButton!
    @IBOutlet weak var scoreLable: UILabel!
    
    var countries = [String]()
    var correctAnswer = 0
    var score = 0
    var bestScore: Int = 0
    var numQuest = 1
    var countQuest = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scoreLable.text = "Your score: \(score)"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(showScore))
        Button1.layer.borderWidth = 1
        Button1.layer.borderColor = UIColor.lightGray.cgColor
        
        Button2.layer.borderWidth = 1
        Button2.layer.borderColor = UIColor.lightGray.cgColor
        
        Button3.layer.borderWidth = 1
        Button3.layer.borderColor = UIColor.lightGray.cgColor
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        askQuestion()
        
        title = "\(numQuest) of \(countQuest): \(countries[correctAnswer].uppercased())"
        
    }
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        
        Button1.setImage(UIImage(named: countries[0]), for: .normal)
        Button2.setImage(UIImage(named: countries[1]), for: .normal)
        Button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = Int.random(in: 0...2)
        title = "\(numQuest) of \(countQuest): \(countries[correctAnswer].uppercased())"
        scoreLable.text = "Your score: \(score)"
        
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        if (sender.tag == correctAnswer) {
            title = "Correct"
            score += 1
        }
        else {
            title = "Wrong"
            score -= 1
            let ac = UIAlertController(title: title, message: "This is \(countries[sender.tag].uppercased()).", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default))
            present(ac, animated: true)
        }
        if numQuest == countQuest {
            numQuest = 1
            load()
            print("Your score is \(score). The best: \(bestScore)")
            let ac = UIAlertController(title: title, message: "Your score is \(score). The best: \(bestScore)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: askQuestion))
            present(ac, animated: true)
            if score > bestScore {
                save()
                print("Your score is \(score). The best: \(bestScore)")
            }
            score = 0
        }
        else {
            numQuest += 1
            askQuestion()
        }
    }
    
    @objc func showScore() {
        let vc = UIAlertController(title: "Info", message: "Your score is \(score).", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Close", style: .cancel))
        present(vc, animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(score) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "BestScore")
        } else {
            print("Failed to save people.")
        }
    }
    
    func load() {
        let defaults = UserDefaults.standard

        if let savedScore = defaults.object(forKey: "BestScore") as? Data {
            let jsonDecoder = JSONDecoder()

            do {
                bestScore = try jsonDecoder.decode(Int.self, from: savedScore)
            } catch {
                print("Failed to load people")
            }
        }
    }
}

