import Fluent
import Vapor

struct CreateTopicStageMigration: Migration {
	
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		return database.schema(TopicStage.schema)
			.id()
			.field(.topic, .uuid, .required)
			.field(.title, .string, .required)
			.field(.body, .string, .required)
			.foreignKey(.topic, references: Topic.schema, .id)
			.create()
	}
	
	func revert(on database: Database) -> EventLoopFuture<Void> {
		return database.schema(TopicStage.schema).delete()
	}
	
}
