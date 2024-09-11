//
//  File.swift
//
//
//  Created by Mason Ma on 2024/9/9.
//

import Dependencies
import Foundation
import SafariServices

public struct ContentBlockerService {
    public var checkUserEnableContenBlocker: (String) async -> Bool
    public var reloadUserEnableContentBlocker: (String) async -> Void
}

extension ContentBlockerService: DependencyKey {
//    public static var liveValue = ContentBlockerService { bundleID in

//    }
    public static var liveValue = ContentBlockerService { bundleID in
        await withCheckedContinuation { continuation in
            SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: bundleID, completionHandler: {
                state, error in
                continuation.resume(returning: state?.isEnabled ?? false)
                if let error {
                    // log
                }
            })
        }
    } reloadUserEnableContentBlocker: { bundleID in
        await withCheckedContinuation { coninuation in
            SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: bundleID, completionHandler: {
                state, error in
                coninuation.resume()
                if let error {
                    // log
//                    coninuation.resume(throwing: error)
                }
            })
        }
    }

}

extension ContentBlockerService: TestDependencyKey {
    public static var testValue = ContentBlockerService(
        checkUserEnableContenBlocker: unimplemented("checkUserEnableContentBlocker"),
        reloadUserEnableContentBlocker: unimplemented("reloadUserEnableContentBlocker")
    )
}

public extension DependencyValues {
    var contentBlockerService: ContentBlockerService {
        get { self[ContentBlockerService.self] }
        set { self[ContentBlockerService.self] = newValue }
    }
}

/*
 if #available(iOS 10.0, *) {
     SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: contentBlockerExteiosnIdentifier, completionHandler: { (state, error) -> Void in
         switch state?.isEnabled {
         case .some(true):
             SFContentBlockerManager.reloadContentBlocker(withIdentifier: contentBlockerExteiosnIdentifier, completionHandler: { (error) -> Void in
                 if error == nil {
                     print("background reloadContentBlocker complete")
                     completionHandler(.newData)
                 } else {
                     print("background reloadContentBlocker: \(String(describing: error))")
                     completionHandler(.failed)
                 }
             })
         default:
             completionHandler(.noData)
         }
     })
 } else {
     SFContentBlockerManager.reloadContentBlocker(withIdentifier: contentBlockerExteiosnIdentifier, completionHandler: { (error) -> Void in
         if error == nil {
             print("background reloadContentBlocker complete")
             completionHandler(.newData)
         } else {
             print("background reloadContentBlocker: \(String(describing: error))")
             completionHandler(.failed)
         }
     })
 }
 */
