//
//  ViewController.swift
//  Flashcards
//
//  Created by Kelvin Martinez on 2/15/20.
//  Copyright © 2020 Kelvin Martinez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    let alert = UIAlertController(title: "Missing Text", message: "Please fill in a question or an answer", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapOnFlashcard(_ sender: Any) {
        
        if (frontLabel.isHidden == false){
            frontLabel.isHidden = true
        }

        else if(frontLabel.isHidden == true){
            frontLabel.isHidden = false
        }
        
    }
    
    
    func updateFlashcard(question: String, answer: String){
        
        frontLabel.text = question
        backLabel.text = answer
        
        if (frontLabel.isHidden == true){
            frontLabel.isHidden = false
        }
         
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigationController = segue.destination as! UINavigationController
        
        let CreationController = navigationController.topViewController as! CreationViewController
        
        CreationController.flashcardsController = self
    }

    

    

    

}


