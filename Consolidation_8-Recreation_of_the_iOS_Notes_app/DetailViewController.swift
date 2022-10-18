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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(promptForNoteDeletion))
        toolbarItems = [spacer, deleteButton]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditing))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveNote()
    }
    
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
    }
    
    @objc func doneEditing() {
        note.endEditing(true)
    }
    
    func saveNote() {
        notes[noteIndex].text = note.text
    }
    
    /* func save() {
        let defaults = UserDefaults.standard
        
        do {
            defaults.set()
        }
    } */
}
