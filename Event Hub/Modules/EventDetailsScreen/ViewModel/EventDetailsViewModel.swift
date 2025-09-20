//
//  EventDetailsViewModel.swift
//  Event Hub
//
//  Created by Sergey Zakurakin on 9/19/25.
//

import Foundation

@MainActor
final class EventDetailsViewModel: ObservableObject {
    @Published var showShareSheet = false

    let link: String
    let message: String

    let title = "International Band Music Concert"
    let dateTitle = "14 December 2021"
    let dateSubtitle = "Tuesday, 4:00 pm - 9:00 pm"
    let placeTitle = "Gala Convention Centre"
    let placeSubtitle = "36 Guild Street London, UK"
    let organizerTitle = "Ashfak Sayem"
    let organizerSubtitle = "Organizer"
    let aboutText = """
    Discover events you’ll love and make every day unforgettable. Plan your perfect schedule with just a few taps, explore exciting activities happening near you, and connect with the moments that matter most. Stay inspired, stay informed, and never miss what’s happening around you!
    """

    init(link: String, message: String) {
        self.link = link
        self.message = message
    }

    var shareTargets: [ShareTarget] {
        [
            .copyLink,
            .whatsapp, .telegram, .facebook, .messenger,
            .twitter, .instagram, .iMessage
        ]
    }
}
