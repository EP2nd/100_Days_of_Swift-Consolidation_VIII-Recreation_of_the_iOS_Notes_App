//
//  DetailViewController.swift
//  Consolidation_8-Recreation_of_the_iOS_Notes_app
//
//  Created by Edwin Przeźwiecki Jr. on 16/10/2022.
//

import UIKit

/// Protocol for updating saved notes in ViewController:
protocol UpdateDelegate {
    func update(_ editor: DetailViewController, toUpdate notes: [Note])
}

class DetailViewController: UIViewController {
    
    @IBOutlet var note: UITextView!
    
    var notes: [Note]!
    
    var noteIndex: Int!
    var initialText: String!
    
    var delegate: UpdateDelegate?
    
    var doneButton: UIBarButtonItem!
    var deleteButton: UIBarButtonItem!
    var shareButton: UIBarButtonItem!
    var composeButton: UIBarButtonItem!
    var spacer: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(promptForNoteDeletion))
        deleteButton.tintColor = .systemYellow
        
        composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNote))
        composeButton.tintColor = .systemYellow
        
        toolbarItems = [deleteButton, spacer, composeButton]
        
        shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        navigationItem.rightBarButtonItems = [shareButton]
        
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditing))
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        /// UITextView's text added to Note's text variable:
        note.text = notes[noteIndex].text
        initialText = notes[noteIndex].text
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveNote()
    }
    
    @objc func createNote() {
        
        saveNote()
        
        notes.append(Note(text: ""))
        
        notifyDelegateToUpdate(notes: notes)
        
        noteIndex = notes.count - 1
        note.text = ""
        initialText = ""
        
        saveNote(newNote: true)
    }
    
    func setNoteParameters(notes: [Note], noteIndex: Int) {
        self.notes = notes
        self.noteIndex = noteIndex
    }
    
    @objc func doneEditing() {
        note.endEditing(true)
    }
    
    func saveNote(newNote: Bool = false) {
        
        if note.text != initialText || newNote {
            initialText = note.text
            notes[noteIndex].text = note.text
        }
        
        DispatchQueue.global().async { [ weak self] in
            if let notes = self?.notes {
                SavedNotes.save(notes: notes)
            }
        }
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
        notifyDelegateToUpdate(notes: notes)
        
        DispatchQueue.global().async { [ weak self ] in
            if let notes = self?.notes {
                SavedNotes.save(notes: notes)
            }
            DispatchQueue.main.async {
                /// Pop ViewController back:
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func shareTapped() {
        
        guard let text = note.text else { return }
        
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(vc, animated: true)
    }
    
    func notifyDelegateToUpdate(notes: [Note]) {
        if let delegate = delegate {
            delegate.update(self, toUpdate: notes)
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            note.contentInset = .zero
            
            navigationItem.rightBarButtonItems = [shareButton]
        } else {
            note.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            
            navigationItem.rightBarButtonItems = [doneButton]
        }
        
        note.scrollIndicatorInsets = note.contentInset
        
        let selectedRange = note.selectedRange
        note.scrollRangeToVisible(selectedRange)
    }
}
