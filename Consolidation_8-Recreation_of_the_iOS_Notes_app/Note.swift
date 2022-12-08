//
//  Note.swift
//  Consolidation_8-Recreation_of_the_iOS_Notes_app
//
//  Created by Edwin Przeźwiecki Jr. on 16/10/2022.
//

import Foundation

class Note: Codable {
    
    var text: String
    
    init(text: String) {
        self.text = text
    }
}
