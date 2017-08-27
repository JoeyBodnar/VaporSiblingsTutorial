//
//  Tag.swift
//  Routing
//
//  Created by Stephen Bodnar on 17/08/2017.
//
//

import Foundation
import Vapor
import FluentProvider

extension Tag: ResponseRepresentable { }

final class Tag: Model {
    let storage = Storage()
    static let idKey = "id"
    static let nameKey = "name"
    
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    init(row: Row) throws {
        name = try row.get(Tag.nameKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Tag.nameKey, name)
        return row
    }
}

extension Tag: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Tag.nameKey)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}


extension Tag: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(name: json.get(Tag.nameKey))
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Tag.idKey, id)
        try json.set(Tag.nameKey, name)
        return json
    }
    
}
