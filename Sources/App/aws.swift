import SotoS3
import Vapor

public extension Application {
	
	var aws: AWS { AWS(application: self) }

	struct AWS {
		struct ClientKey: StorageKey {
			typealias Value = AWSClient
		}

		public var client: AWSClient {
			get {
				guard let client = self.application.storage[ClientKey.self] else {
					fatalError("AWSClient not setup. Use application.aws.client = ...")
				}
				return client
			}
			nonmutating set {
				self.application.storage.set(ClientKey.self, to: newValue) {
					try $0.syncShutdown()
				}
			}
		}

		let application: Application
	}
}
