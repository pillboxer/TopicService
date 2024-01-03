import Fluent
import Vapor

func routes(_ app: Application) throws {
	
	app.group("topics") { route in
		let topic = TopicController(client: app.aws.client)
		route.on(.GET, use: topic.index)
		let stages = TopicStageController()
		route.on(.GET, "stages", use: stages.index)
	}
}
