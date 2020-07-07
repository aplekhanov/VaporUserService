import Vapor

struct UserResponse: Content {
    let id: UUID?
    let firstname, lastname: String?
    let email: String
    init(user: User) {
        self.id = user.id
        self.firstname = user.firstname
        self.lastname = user.lastname
        self.email = user.email
    }
}

struct UserSuccessResponse: Content {
    let status: String = "success"
    let user: UserResponse
}

struct LoginResponse: Content {
    let status: String = "success"
    let accessToken: String
    let refreshToken: String
    let user: UserResponse
}

struct RefreshTokenResponse: Content {
    let status = "success"
    let accessToken: String
}
