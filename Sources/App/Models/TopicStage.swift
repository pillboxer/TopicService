import Fluent
import Vapor

extension FieldKey {
	static var title: Self { "title" }
	static var body: Self { "body" }
	static var topic: Self { "topic" }
}

final class TopicStage: Model, Content {
	static let schema = "topic_stages"
	
	@ID(key: .id)
	var id: UUID?

	@Field(key: .title)
	var title: String
	
	@Field(key: .body)
	var body: String
	
	@Parent(key: .topic)
	var topic: Topic

	init() { }
	
}
