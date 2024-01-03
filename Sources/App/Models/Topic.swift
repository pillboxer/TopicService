import Fluent
import Vapor

extension FieldKey {
	static var name: Self { "name" }
}

final class Topic: Model, Content {
    static let schema = "topics"
    
    @ID(key: .id)
    var id: UUID?

	@Field(key: .name)
    var name: String

    init() { }
}
