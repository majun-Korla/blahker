//
//  File.swift
//
//
//  Created by Mason Ma on 2024/9/9.
//

import Dependencies
import Foundation
import SafariServices
import DependenciesMacros

@DependencyClient
public struct ContentBlockerService {
    public var checkUserEnableContenBlocker: (_ bundleID: String) async -> Bool = { _ in
       unimplemented(_:"checkUserEnableContentBlocker", placeholder: false)
    }
    public var reloadUserEnableContentBlocker: (_ bundleID: String) async throws -> Void
}

extension ContentBlockerService: DependencyKey {

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
        try await withCheckedThrowingContinuation { continuation in
            SFContentBlockerManager.reloadContentBlocker(withIdentifier: bundleID, completionHandler: {
                 error in
                
                if let error {
                    continuation.resume(throwing: error)
                }
                else {
                    continuation.resume()
                }
            })
            
        }
        
    }

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
