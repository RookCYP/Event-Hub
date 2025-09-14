//
//  OnboardingViewModel.swift
//  Event Hub
//
//  Created by Sergey Zakurakin on 9/13/25.
//

import SwiftUI

final class OnboardingViewModel: ObservableObject {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @Published var index: Int = 0
    
    let titles = [
        "Explore Upcoming and\nNearby Events",
        "Web Have Modern Events\nCalendar Feature",
        "To Look Up More Events or\nActivities Nearby By Map"
    ]
    
    let subtitles = [
        "Discover events happening near you and never miss what's trending in your city.",
        "Use our smart calendar to track, save and get reminders for upcoming events.",
        "Browse the interactive map to explore new places and activities around you."
    ]
    
    var isLastPage: Bool {
        index == titles.count - 1
    }
    
    func next() {
        if isLastPage {
            hasSeenOnboarding = true
        } else {
            withAnimation(.easeInOut) {
                index += 1
            }
        }
    }
    
    func skip() {
        hasSeenOnboarding = true
    }
}
