//
//  ViewController.swift
//  Consolidation_8-Recreation_of_the_iOS_Notes_app
//
//  Created by Edwin Przeźwiecki Jr. on 16/10/2022.
//

import UIKit

class ViewController: UITableViewController {
    // MARK: Variables:
    
    var notes = [Note]()

    // MARK: Initializers:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let compose = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNote))
        toolbarItems = [spacer, compose]
        navigationController?.isToolbarHidden = false
    }
    
    // MARK: tableView:
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let cell = cell as? NoteCell {
            let note = notes[indexPath.row]
            let splitText = note.text.split(separator: "\n", maxSplits: 2, omittingEmptySubsequences: true)
            cell.title?.text = viewTitle(splitText: splitText)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: Cell view:
    
    func viewTitle(splitText: [Substring]) -> String {
        if splitText.count >= 1 {
            return String(splitText[0])
        }
        return ""
    }
    
    func viewSubtext(splitText: [Substring]) -> String {
        if splitText.count >= 2 {
            return String(splitText[1])
        }
        return ""
    }
    
    // MARK: Actions:
    
    @objc func createNote() {
        notes.append(Note(text: ""))
        
        instantiateViewController(noteIndex: notes.count - 1)
    }
    
    func instantiateViewController(noteIndex: Int) {
        if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            detailViewController.setNoteParameters(notes: notes, noteIndex: noteIndex)
            //detailViewController.delegate = self
            
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
