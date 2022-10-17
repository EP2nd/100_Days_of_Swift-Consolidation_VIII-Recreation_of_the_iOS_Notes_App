//
//  ViewController.swift
//  Consolidation_8-Recreation_of_the_iOS_Notes_app
//
//  Created by Edwin Przeźwiecki Jr. on 16/10/2022.
//

import UIKit

class ViewController: UITableViewController {
    var notes = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let compose = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNote))
        toolbarItems = [compose]
        navigationController?.isToolbarHidden = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let note = notes[indexPath.row]
        cell.textLabel?.text = note
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            detailViewController.selectedNote = notes[indexPath.row]
            
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    @objc func createNote() {
        
    }
}
