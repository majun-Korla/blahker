//
//  MailComposeClient.swift
//  Features
//
//  Created by Mason Ma on 2024/9/20.
//

import Foundation
import Dependencies
import DependenciesMacros
import MessageUI


@DependencyClient
struct MailComposeClient {
    var canSendMail: () -> Bool = {
//        Unimplemented("canSendMail", placeholder: false)
            false
    }
    
}

extension MailComposeClient: DependencyKey {
    static var liveValue =  MailComposeClient(canSendMail: {
        MFMailComposeViewController.canSendMail()
        }
    )
    
    
}
extension DependencyValues {
    var mailComposeClient: MailComposeClient {
        get { self[MailComposeClient.self] }
        set { self[MailComposeClient.self] = newValue }
        
    }
}


