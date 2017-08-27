
//  Created by Stephen Bodnar on 20/08/2017.
//
//
import Foundation
import FluentProvider
import Vapor

final class TagController {
    let droplet: Droplet
    
    init(drop: Droplet) {
        self.droplet = drop
    }
    
    func addRoutes() {
        droplet.get("alltags", handler: index)
        droplet.post("createtag", handler: create)
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        let allTags = try Tag.all()
        return try JSON(node: ["tags": allTags])
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        if let name = request.data[Tag.nameKey]?.string {
            let tag = Tag(name: name)
            try tag.save()
            return tag
        }
        return try JSON(node: ["hello": "world"])
    }
}
