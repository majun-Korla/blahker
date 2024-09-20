import ComposableArchitecture
@testable import Features
import XCTest

@MainActor
final class AboutFeatureTests: XCTestCase {
    func testTapReportCell_checkCanSendMail_disabled_presentAlert() async throws {
        let store = TestStore(initialState: AboutFeature.State(), reducer: { AboutFeature() }) {
            $0.mailComposeClient.canSendMail = { false }
        }

      
        
        
        await store.send(.tapReportCell)
        await store.receive(.presentPleaseMailOpenAlert)
        {
            $0.alert = .pleaseMailOpen
            
        }
        
        
    }
    
    func testTapReportCell_checkCanSendMail_enabled() async throws {
        let store = TestStore(initialState: AboutFeature.State(), reducer: { AboutFeature() }) {
            $0.mailComposeClient.canSendMail = { true }
        }

      
        
        
        await store.send(.tapReportCell)
        //UIKit present MailCompose Controller
        
        
    }
}
