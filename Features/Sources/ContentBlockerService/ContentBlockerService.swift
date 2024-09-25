//
//  File.swift
//
//
//  Created by Mason Ma on 2024/9/9.
//

import Dependencies
import DependenciesMacros
import Foundation
import Models
import SafariServices

@DependencyClient
public struct ContentBlockerService {
    public var checkUserEnableContenBlocker: (_ bundleID: String) async -> Bool = { _ in
        unimplemented(_: "checkUserEnableContentBlocker", placeholder: false)
    }

    public var reloadUserEnableContentBlocker: (_ bundleID: String) async throws -> Void

    public var fetchBlockerList: () async throws -> [RuleItem] = {
        unimplemented(_: "fetchBlockerList", placeholder: [RuleItem]())
    }
}

extension ContentBlockerService: DependencyKey {
    public static var liveValue = ContentBlockerService(
        checkUserEnableContenBlocker: {
            _ in
            await withCheckedContinuation { continuation in
                //            SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: bundleID, completionHandler: {
                //                state, error in
                //                continuation.resume(returning: state?.isEnabled ?? false)
                //                if let error {
                //                    // log
                //                }
                //            })
                continuation.resume(returning: true)
            }
        },
        reloadUserEnableContentBlocker: {
            _ in
            try await withCheckedThrowingContinuation { continuation in
                //            SFContentBlockerManager.reloadContentBlocker(withIdentifier: bundleID, completionHandler: {
                //                 error in
                //
                //                if let error {
                //                    continuation.resume(throwing: error)
                //                }
                //                else {
                //                    continuation.resume()
                //                }
                //            })
                continuation.resume()
            }
        },
        fetchBlockerList: {
//            await withCheckedContinuation { continuation in
//                continuation.resume(returning: [RuleItem]())
//            }
            // urlsession fetch url
            // decode to Rule
            // convert to RuleItem
            
            let urlSession = URLSession.shared
            guard let url = URL(string: "https://raw.githubusercontent.com/ethanhuang13/blahker/master/Blahker.safariextension/blockerList.json") else {
                print("Invalid URL")
                return []
            }
            let (data, _) = try await urlSession.data(from: url)
            let rules = try JSONDecoder().decode([Rule].self, from: data)

            var rulesDict = [String: [String]]()

            for rule in rules {
                if let domains = rule.trigger.ifDomain,
                   let selector = rule.action.selector
                {
                    for domain in domains {
                        var selectors = rulesDict[domain] ?? []
                        selectors.append(selector)
                        rulesDict[domain] = selectors
                    }
                } else if let selector = rule.action.selector {
                    var selectors = rulesDict["Any"] ?? []
                    selectors.append(selector)
                    rulesDict["Any"] = selectors
                }
            }

            var ruleItems = [RuleItem]()
            for (domain, selectors) in rulesDict {
                let ruleItem = RuleItem(domain: domain, selectors: selectors)
                ruleItems.append(ruleItem)
            }
            
            return ruleItems
                .sorted(using: [KeyPathComparator(\.domain)])
        }
    )
}

public extension DependencyValues {
    var contentBlockerService: ContentBlockerService {
        get { self[ContentBlockerService.self] }
        set { self[ContentBlockerService.self] = newValue }
    }
}
