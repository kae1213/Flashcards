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
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    //array that will hold the flashcards
    var flashcards = [Flashcard]()
    
    //start of flashcard index
    var currentIndex = 0

    
    override func viewDidLoad() {
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

    @IBAction func didTapOnFlashcard(_ sender: Any) {
        
        if (frontLabel.isHidden == false){
            frontLabel.isHidden = true
        }

        else if(frontLabel.isHidden == true){
            frontLabel.isHidden = false
        }
        
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
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        //increasding index
        currentIndex = currentIndex + 1
        
        //update labels
        updateLabels()
        
        //update Buttons
        updateNextPrevButtons()
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


}
