import Vapor
import Fluent
import SimpleJWTMiddleware

final class AuthController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        routes.post("register", use: register)
        routes.post("login", use: login)
        routes.post("accessToken", use: refreshAccessToken)
    }
    
    func register(_ request: Request) throws -> EventLoopFuture<UserSuccessResponse> {
        
        let registeredUser = try request.content.decode(NewUserInput.self)
        let newUser = try User(registeredUser.email, registeredUser.firstname, registeredUser.lastname, registeredUser.password)
        
        return User.query(on: request.db).filter(\.$email == newUser.email).count().flatMap { all in
            if all > 0 {
                return request.eventLoop.makeFailedFuture(Abort(.badRequest, reason: "This email is already registered."))
            }
            return newUser.save(on: request.db).transform(to: newUser)
        }.map { user in
            return UserSuccessResponse(user: UserResponse(user: user))
        }
    }
    
    func login(_ request: Request) throws -> EventLoopFuture<LoginResponse> {
        
        let data = try request.content.decode(LoginInput.self)
        
        return User.query(on: request.db).filter(\.$email == data.email).all().flatMap { users in
            
            if users.count == 0 {
                return request.eventLoop.makeFailedFuture(Abort(.unauthorized))
            }
            
            let user = users.first!
            var check = false
            do {
                check = try Bcrypt.verify(data.password, created: user.password)
            } catch {}
            
            if check {
                let userPayload = Payload(id: user.id!, email: user.email)
                do {
                    let accessToken = try request.application.jwt.signers.sign(userPayload)
                    let refreshPayload = RefreshToken(user: user)
                    let refreshToken = try request.application.jwt.signers.sign(refreshPayload)
                    let userResponse = UserResponse(user: user)
                    return user.save(on: request.db).transform(to: LoginResponse(accessToken: accessToken, refreshToken: refreshToken, user: userResponse))
                } catch {
                    return request.eventLoop.makeFailedFuture(Abort(.internalServerError))
                }
            } else {
                return request.eventLoop.makeFailedFuture(Abort(.unauthorized))
            }
        }
    }
    
    func refreshAccessToken(_ request: Request) throws -> EventLoopFuture<RefreshTokenResponse> {
        
        let data = try request.content.decode(RefreshTokenInput.self)
        let refreshPayload: RefreshToken = try request.application.jwt.signers.verify(data.refreshToken, as: RefreshToken.self)
        
        return User.query(on: request.db).filter(\.$id == refreshPayload.id).all().flatMap { users in
            if users.count == 0 {
                return request.eventLoop.makeFailedFuture(Abort(.badRequest, reason: "No user found."))
            }
            let user: User = users.first!
            let payload = Payload(id: user.id!, email: user.email)
            var payloadString = ""
            do {
                payloadString = try request.application.jwt.signers.sign(payload)
            } catch {}
            
            return user.save(on: request.db).map { _ in
                return RefreshTokenResponse(accessToken: payloadString)
            }
        }
    }
}
