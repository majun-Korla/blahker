//
//  File.swift
//  
//
//  Created by Mason Ma on 2024/9/9.
//

import Foundation
import Dependencies


struct SafariService {
    var checkUserEnableContenBloacker: (String) async -> Bool
}

extension SafariService: DependencyKey {
    static var liveValue = SafariService { bundleID in
//        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: bundleID, completionHandler: { }
        
        return true
    }
}
extension SafariService: TestDependencyKey {
    static var testValue = SafariService(
        checkUserEnableContenBloacker: unimplemented("checkUserEnableContentBlocker")
    )
}

extension DependencyValues {
    var safariService: SafariService {
        get { self[SafariService.self] }
        set { self[SafariService.self] = newValue}
    }
}
