
import Foundation
import FluentProvider
import Vapor

final class PostController {
    let droplet: Droplet
    
    init(drop: Droplet) {
        self.droplet = drop
    }
    
    func addRoutes() {
        self.droplet.get("allposts", handler: index)
        self.droplet.post("createpost", handler: createPost)
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        let allPosts = try Post.all()
        return try JSON(node: ["posts": allPosts])
    }
    
    func createPost(request: Request) throws -> ResponseRepresentable {
        if let title = request.data[Post.titleKey]?.string {
            let post = Post(title: title)
            try post.save()
            return post
        }
        return try JSON(node: ["error": "error saving post!"])
    }
    
}
