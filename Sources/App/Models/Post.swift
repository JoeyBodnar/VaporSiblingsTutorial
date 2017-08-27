//
//  Post.swift
//  Routing
//
//  Created by Stephen Bodnar on 17/08/2017.
//
//

import Foundation
import Vapor
import FluentProvider



final class Post: Model {
    let storage = Storage()
    static let idKey = "id"
    static let titleKey = "title"
    
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    init(row: Row) throws {
        title = try row.get(Post.titleKey)
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Post.titleKey, title)
        return row
    }
    
}

extension Post: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(title: json.get(Post.titleKey))
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Post.idKey, id)
        try json.set(Post.titleKey, title)
        return json
    }
    
}


extension Post: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Post.titleKey)
        }
    }
    
    /// Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}
extension Post: ResponseRepresentable { }
extension Post: NodeRepresentable { }

