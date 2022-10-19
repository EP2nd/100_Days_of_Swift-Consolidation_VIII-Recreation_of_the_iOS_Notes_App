//
//  DetailViewController.swift
//  Consolidation_8-Recreation_of_the_iOS_Notes_app
//
//  Created by Edwin Przeźwiecki Jr. on 16/10/2022.
//

import UIKit

class DetailViewController: UIViewController {
    // MARK: Variables:
    
    @IBOutlet var note: UITextView!
    var notes: [Note]!
    var noteIndex: Int!
    
    // MARK: Initializers:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(promptForNoteDeletion))
        toolbarItems = [spacer, deleteButton]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditing))
        
        // Adds the UITextView's text to Note's text variable.
        note.text = notes[noteIndex].text
    }
    
    /* override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    } */
    
    // MARK: Actions:
    
    func setNoteParameters(notes: [Note], noteIndex: Int) {
        self.notes = notes
        self.noteIndex = noteIndex
    }
    
    @objc func promptForNoteDeletion() {
        let ac = UIAlertController(title: "Delete note", message: "Are you certain you wish to delete this note?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .destructive) { [ weak self ] _ in
            self?.deleteNote()
        })
        ac.addAction(UIAlertAction(title: "No", style: .cancel))
        present(ac, animated: true)
    }
    
    func deleteNote() {
        notes.remove(at: noteIndex)
        
        DispatchQueue.global().async { [ weak self ] in
            if let notes = self?.notes {
                SavedNotes.save(notes: notes)
            }
            DispatchQueue.main.async {
                // Pops the main viewController back:
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func doneEditing() {
        note.endEditing(true)
        saveNote()
    }
    
    func saveNote() {
        notes[noteIndex].text = note.text
        
        SavedNotes.save(notes: notes)
    }
}
