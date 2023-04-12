//
//  Word+CoreDataProperties.swift
//  WordBank
//
//  Created by Talaxy on 2023/4/12.
//
//

import Foundation
import CoreData


extension Word {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word")
    }

    @NSManaged public var name: String?
    @NSManaged public var partOfSpeech: String?
    @NSManaged public var definition: String?
    @NSManaged public var id: UUID?

}

extension Word : Identifiable {

}
