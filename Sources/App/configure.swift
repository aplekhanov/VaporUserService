import Vapor
import SimpleJWTMiddleware
import Fluent
import FluentSQLiteDriver

// configures your application
public func configure(_ app: Application) throws {
    
    // Middlewares
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.middleware.use(CORSMiddleware())
    
    
    // Database and migrations
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    
    app.migrations.add(CreateUser())
    
    
    // Authorization
    guard let jwksString = Environment.process.JWKS else {
        fatalError("No value was found at the given public key environment 'JWKS'")
    }
    
    try app.jwt.signers.use(jwksJSON: jwksString)
    
    
    // register routes
    try routes(app)
}
