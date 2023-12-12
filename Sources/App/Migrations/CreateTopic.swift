import Fluent

struct CreateTopicMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Topic.schema)
            .id()
            .field("name", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
		try await database.schema(Topic.schema).delete()
    }
}
