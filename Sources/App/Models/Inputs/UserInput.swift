import Vapor

struct NewUserInput: Content {
    let firstname: String?
    let lastname: String?
    let email: String
    let password: String
}

struct EditUserInput: Content {
    let firstname: String?
    let lastname: String?
}

struct LoginInput: Content {
    let email: String
    let password: String
}

struct RefreshTokenInput: Content {
    let refreshToken: String
}
