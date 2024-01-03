import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor
import SotoS3

public func configure(_ app: Application) async throws {
	
	guard
		let key = Environment.get("AWS_ACCESS_KEY"),
		let secret = Environment.get("AWS_SECRET_ACCESS_KEY") else {
		fatalError("Missing AWS Keys")
	}
	
	app.aws.client = AWSClient(credentialProvider: .static(accessKeyId: key, secretAccessKey: secret), httpClientProvider: .createNew)

    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)
	
	let serverPort = Environment.get("SERVER_PORT").flatMap(Int.init(_:)) ?? 8080
	app.http.server.configuration.port = serverPort
		
    app.migrations.add(CreateTopicMigration())
	app.migrations.add(CreateTopicStageMigration())

	try await app.autoMigrate()
    try routes(app)
}
