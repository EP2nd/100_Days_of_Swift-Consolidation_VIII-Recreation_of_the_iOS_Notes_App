//
//  SavedNotes.swift
//  Consolidation_8-Recreation_of_the_iOS_Notes_app
//
//  Created by Edwin Przeźwiecki Jr. on 19/10/2022.
//

import Foundation

class SavedNotes {
    static func load() -> [Note] {
        var notes = [Note]()
        let defaults = UserDefaults.standard
        
        if let savedNotes = defaults.object(forKey: "notes") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                notes = try jsonDecoder.decode([Note].self, from: savedNotes)
            } catch {
                print("Failed to load saved notes.")
            }
        }
        return notes
    }
    
    static func save(notes: [Note]) {
        let jsonEncoder = JSONEncoder()
        
        if let savedNotes = try? jsonEncoder.encode(notes) {
            let defaults = UserDefaults.standard
            defaults.set(savedNotes, forKey: "notes")
        } else {
            print("Failed to save notes.")
        }
    }
}
