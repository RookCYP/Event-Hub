//
//  ShareTarget.swift
//  Event Hub
//
//  Created by Sergey Zakurakin on 9/19/25.
//

import SwiftUI

// MARK: - MODEL

enum ShareTarget: Identifiable, Hashable {
    case copyLink
    case whatsapp
    case telegram
    case facebook
    case messenger
    case twitter
    case instagram
    case iMessage

    var id: String { title }
    var title: String {
        switch self {
        case .copyLink:  return "Copy Link"
        case .whatsapp:  return "WhatsApp"
        case .telegram:  return "Telegram"
        case .facebook:  return "Facebook"
        case .messenger: return "Messenger"
        case .twitter:   return "Twitter"
        case .instagram: return "Instagram"
        case .iMessage:  return "iMessage"
        }
    }
    
    var iconAssetName: String {
        switch self {
        case .copyLink:  return "copy"
        case .whatsapp:  return "whatsApp"
        case .telegram:  return "telegram"
        case .facebook:  return "facebook"
        case .messenger: return "messenger"
        case .twitter:   return "twitter"
        case .instagram: return "instagram"
        case .iMessage:  return "message"
        }
    }
}





    
