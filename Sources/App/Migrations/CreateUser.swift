import Fluent

struct CreateUser: Migration {

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(User.schema)
            .id()
            .field(User.FieldKeys.firstname,.string)
            .field(User.FieldKeys.lastname, .string)
            .field(User.FieldKeys.email,    .string, .required)
            .field(User.FieldKeys.password, .string, .required)
            .field(User.FieldKeys.createdAt, .datetime)
            .field(User.FieldKeys.updatedAt, .datetime)
            .field(User.FieldKeys.deletedAt, .datetime)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(User.schema).delete()
    }
}
