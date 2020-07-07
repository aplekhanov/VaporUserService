import Vapor
import Fluent

final class User: Model {

    static let schema = "users"

    init() {}

    init(_ email: String, _ firstName: String? = nil, _ lastName: String? = nil, _ password: String) throws {
        self.email = email
        self.firstname = firstName
        self.lastname = lastName
        self.password = try BCryptDigest().hash(password)
    }
    
    struct FieldKeys {
        static var firstname:   FieldKey { "firstname" }
        static var lastname:    FieldKey { "lastname" }
        static var email:       FieldKey { "email" }
        static var password:    FieldKey { "password" }
        static var createdAt:   FieldKey { "createdAt" }
        static var updatedAt:   FieldKey { "updatedAt" }
        static var deletedAt:   FieldKey { "deletedAt" }
    }

    @ID() var id: UUID?

    @Field(key: FieldKeys.firstname)    var firstname: String?
    @Field(key: FieldKeys.lastname)     var lastname: String?
    @Field(key: FieldKeys.email)        var email: String
    @Field(key: FieldKeys.password)     var password: String

    @Timestamp(key: FieldKeys.createdAt, on: .create) var createdAt: Date?
    @Timestamp(key: FieldKeys.updatedAt, on: .update) var updatedAt: Date?
    @Timestamp(key: FieldKeys.deletedAt, on: .delete) var deletedAt: Date?
}
