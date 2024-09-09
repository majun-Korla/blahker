//
//  File.swift
//
//
//  Created by Mason Ma on 2024/9/9.
//

import Dependencies
import Foundation

public struct ContentBlockerService {
    public var checkUserEnableContenBloacker: (String) async -> Bool
}

extension ContentBlockerService: DependencyKey {
    public static var liveValue = ContentBlockerService { _ in
//        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: bundleID, completionHandler: { }

        true
    }
}

extension ContentBlockerService: TestDependencyKey {
    public static var testValue = ContentBlockerService(
        checkUserEnableContenBloacker: unimplemented("checkUserEnableContentBlocker")
    )
}

public extension DependencyValues {
    var contentBlockerService: ContentBlockerService {
        get { self[ContentBlockerService.self] }
        set { self[ContentBlockerService.self] = newValue }
    }
}
