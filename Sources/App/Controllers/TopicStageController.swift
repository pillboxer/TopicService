import Fluent
import Vapor

struct TopicStageController {
	
	func index(_ req: Request) throws -> EventLoopFuture<[TopicStage]> {
		let id: UUID = try req.query.get(at: "id")
		return TopicStage.query(on: req.db)
			.filter(\.$topic.$id == id)
			.all()
	}
}
