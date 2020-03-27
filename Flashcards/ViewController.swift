//
//  ViewController.swift
//  Flashcards
//
//  Created by Kelvin Martinez on 2/15/20.
//  Copyright © 2020 Kelvin Martinez. All rights reserved.
//

import UIKit

struct Flashcard{
    var question: String
    var answer:String
}

class ViewController: UIViewController {
    
    //IBA Outlets
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    //array that will hold the flashcards
    var flashcards = [Flashcard]()
    
    //start of flashcard index
    var currentIndex = 0

    override func viewDidLoad() {
        
        card.layer.cornerRadius = 20.0
        card.clipsToBounds = true

        card.layer.shadowRadius = 15.0
        card.layer.shadowOpacity = 0.8

        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        // Read saved flashcards
        readSavedFlashcards()
        
        // Adding our initial flashcard if needed
        if flashcards.count == 0{
            updateFlashcard(question: "Whats the capital of Brazil?", answer: "Brasilia")
        }
        else{
            updateLabels()
            updateNextPrevButtons()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // First start with the flashcard invisible and slightl smaller in size
        card.alpha = 0.0
        card.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        
        // animating Buttons
        nextButton.alpha = 0.0
        nextButton.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        
        prevButton.alpha = 0.0
        prevButton.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        
        plusButton.alpha = 0.0
        plusButton.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        
        
        // Animation
        UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.card.alpha = 1.0
            self.card.transform = CGAffineTransform.identity
        })
        UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.nextButton.alpha = 1.0
            self.nextButton.transform = CGAffineTransform.identity
        })
        UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.prevButton.alpha = 1.0
            self.prevButton.transform = CGAffineTransform.identity
        })
        UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.plusButton.alpha = 1.0
            self.plusButton.transform = CGAffineTransform.identity
        })
    }

    @IBAction func didTapOnFlashcard(_ sender: Any) {
        flipFlashcard()
    }
    
    func flipFlashcard(){
        
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: {
            if (self.frontLabel.isHidden == false){
                self.frontLabel.isHidden = true
            }

            else if(self.frontLabel.isHidden == true){
                self.frontLabel.isHidden = false
            }
            
        })
        
    }
    
    
    
    @IBAction func didTapOnDelete(_ sender: Any) {
        
        // chow confirmation
        let alert = UIAlertController(title: "Delete flashcard", message: "Are you sure you want to delete it?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.deleteCurrentFlashcard()
        }
        alert.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        
        present(alert, animated: true)
        alert.addAction(cancelAction)

    }
    
    
    func deleteCurrentFlashcard(){
        
        //delete current
        flashcards.remove(at: currentIndex)
        
        // Special Case: Check if last card was deleted
        if (currentIndex > flashcards.count - 1){
            currentIndex = flashcards.count - 1
            
        }
        
        /*
         *  Tried to put an alert to show up
         */
        
//        else if(currentIndex == 0){
//            let alert = UIAlertController(title: "Invalid Action", message: "Can't delete base card", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "Ok", style: .default)
//            present(alert, animated: true)
//            alert.addAction(okAction)
//        }
        updateNextPrevButtons()
        updateLabels()
        saveAllFlashcardsToDisk()
        
    }
    func updateFlashcard(question: String, answer: String){
        
        let flashcard = Flashcard(question: question, answer: answer)
        
        // adding flashcard in the flashcard array
        flashcards.append(flashcard)
        
        // Logging to console t
        print("Added a new flahscar:)")
        print("We now have \(flashcards.count) flashcards\n")
        
        // Update Current index
        currentIndex = flashcards.count - 1
        print("Our current index is \(currentIndex)")
        
        // Update Next Prev Buttons
        updateNextPrevButtons()
        
        // Update Labels
        updateLabels()
        
        // We may need this for the memory thing
        saveAllFlashcardsToDisk()
        
        // if user taps on either side of the flashcard
        if (frontLabel.isHidden == true){
            frontLabel.isHidden = false
        }
         
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigationController = segue.destination as! UINavigationController
        
        let CreationController = navigationController.topViewController as! CreationViewController
        
        CreationController.flashcardsController = self
    }

    
    @IBAction func didTapOnPrev(_ sender: Any) {
        
        // Decrasing index count
        currentIndex = currentIndex - 1
        
        //update labels
        updateLabels()
        
        //update Buttons
        updateNextPrevButtons()
        
        // Animation
        animateCardIn()
      
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        //increasding index
        currentIndex = currentIndex + 1
        
        //update labels
        //updateLabels()
        
        //update Buttons
        updateNextPrevButtons()
        
        // Animating card out
        animateCardOut()
    }
    
    func updateNextPrevButtons(){
        
        //disable next button if at the end
        if currentIndex == flashcards.count - 1{
            nextButton.isEnabled = false
        }
        else{
            nextButton.isEnabled = true
        }
        
        //disable prev button if at the beginning
        if currentIndex == 0{
            prevButton.isEnabled = false
        }
        else{
            prevButton.isEnabled = true
        }
    }
    
    func updateLabels(){
        
        // Get current flashcard
        let currentFlashcard = flashcards[currentIndex]
        
        // Update Labels
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
    }
    
    func saveAllFlashcardsToDisk(){
        
       // From flashcard array to dictionarry array
        let dictionaryArray = flashcards.map { (card) -> [String: String] in return ["question" : card.question, "answer" : card.answer]
            
        }
        // save array on disk using userDefaults
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        // logging it
        print("Flashcards saved to UserDefaults")
    }
    
    func readSavedFlashcards(){
        
        // Read dictionary array (if any)
        // if let is another type of if: it lets you define a constant
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]]{
            
            // Inside we know that their excist a dictionary array
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in
                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
            }
            flashcards.append(contentsOf: savedCards)
        
        }

    }
    
    func animateCardOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        }, completion: { finished in
        
        
        // Update Labels
        self.updateLabels()
        
        // Run other animation
        self.animateCardIn()
        })
    }
    
    func animateCardIn(){
        
        // Start on the right side (don't animate this)
        card.transform = CGAffineTransform.identity.translatedBy(x: 300, y: 0.0)
        
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity
        }
    }
}
