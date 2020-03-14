//
//  CreationViewController.swift
//  Flashcards
//
//  Created by Kelvin Martinez on 3/5/20.
//  Copyright © 2020 Kelvin Martinez. All rights reserved.
//

import UIKit

class CreationViewController: UIViewController {
    
    var flashcardsController: ViewController!
    @IBOutlet weak var didTapOnCancel: UIBarButtonItem!
    @IBOutlet weak var questionBar: UITextField!
    @IBOutlet weak var answerBar: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapOnCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func didTapOnDone(_ sender: Any) {
        
        // these lets kind of act like variables
        let questionText = questionBar.text
        let answerText = answerBar.text
        
        // this is the alert screen and pop up button
        let alert = UIAlertController(title: "Missing Text", message: "Must hava a question and an answer", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)

        
        if (questionText == nil || answerText == nil ||  questionText!.isEmpty || answerText!.isEmpty){
            //presents the variables of alert and the ok button that was created
            present(alert, animated: true)
            alert.addAction(okAction)
            
        }
            
        else{
            // if not empty, then taking the function from the viewcontroller, it will update the text fields
            flashcardsController.updateFlashcard(question: questionText!, answer: answerText!)
            dismiss(animated:true)
        
        }
        

        
    }
    
    
    

}
