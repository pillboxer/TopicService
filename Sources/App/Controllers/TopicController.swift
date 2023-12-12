import Fluent
import Vapor
import SotoS3

struct TopicResponse: Content {
	let id: UUID
	let name: String
	let imageUrl: URL
}

struct TopicController {
	
	private let client: AWSClient
	
	init(client: AWSClient) {
		self.client = client
	}
	
	func index(_ req: Request) throws -> EventLoopFuture<[TopicResponse]> {
		return Topic.query(on: req.db).all().flatMap { topics in
			let s3 = S3(client: client, region: .euwest2)
			let presignedURLFutures = topics.compactMap { topic -> EventLoopFuture<TopicResponse>? in
				guard let topicID = topic.id else { return nil }
				return s3.signURL(
					url: URL(string:"https://stretto-topics.s3.eu-west-2.amazonaws.com/topics/\(topicID.uuidString.lowercased()).png")!,
					httpMethod: .GET,
					expires: .hours(1)
				).map { TopicResponse(id: topicID, name: topic.name, imageUrl: $0) }
			}
			return presignedURLFutures.flatten(on: req.eventLoop)
		}
	}
}
