import Vapor
import SimpleJWTMiddleware

func routes(_ app: Application) throws {
    
    let root = app.grouped(.anything, "users")
    let auth = root.grouped(SimpleJWTMiddleware())
    
    root.get("health") { request in return "OK" }
    
    try root.register(collection: AuthController())
}
