
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
        self.droplet.get("viewsiblings", handler: viewFirstPostsTags)
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        let allPosts = try Post.all()
        return try JSON(node: ["posts": allPosts])
    }
    
    func viewFirstPostsTags(request: Request) throws -> ResponseRepresentable {
        let allPosts = try Post.all() // retrives all posts
        if let firstPost = allPosts.first { // get the first post
            let tagsBelongingTofirstPost = try firstPost.tags.all()
            for tag in tagsBelongingTofirstPost {
                print("the tag name is  \(tag.name)")
            }
            // Now, get all tags
            let tags = try Tag.all()
            if let firstTag = tags.first {
                let postsBelongingToFirtTag = try firstTag.posts.all()
                for post in postsBelongingToFirtTag {
                    print("the post title is \(post.title)")
                }
                return try JSON(node: ["result": "success"])
            }
        }
        return try JSON(node: ["result": "error"])
    }
    
    func createPost(request: Request) throws -> ResponseRepresentable {
        if let title = request.data[Post.titleKey]?.string {
            let post = Post(title: title)
            try post.save()
            if let tag = try Tag.all().first {
                try post.tags.add(tag)
                try post.save()
            }
            return post
        }
        return try JSON(node: ["error": "error saving post!"])
    }
    
}
