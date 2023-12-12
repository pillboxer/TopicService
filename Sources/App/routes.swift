import Fluent
import Vapor

func routes(_ app: Application) throws {
	
	app.group("topics") { route in
		let controller = TopicController(client: app.aws.client)
		route.on(.GET, use: controller.index)
	}
}
