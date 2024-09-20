import ComposableArchitecture
@testable import Features
import XCTest

@MainActor
final class AboutFeatureTests: XCTestCase {
    func testTapReportCell_checkCanSendMail() async throws {
        let store = TestStore(initialState: AboutFeature.State(), reducer: { AboutFeature() }) {
            $0.mailComposeClient.canSendMail = { false }
        }

      
        
        
        await store.send(.tapReportCell)
        await store.receive(.presentPleaseMailOpenAlert)
        {
            $0.alert = .pleaseMailOpen
            
        }
        // dependency
        
        
    }
}
