//
//  FavoriteEvent+CoreDataProperties.swift
//  Event Hub
//
//  Created by Rook on 21.09.2025.
//
//

public import Foundation
public import CoreData


public typealias FavoriteEventCoreDataPropertiesSet = NSSet

extension FavoriteEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteEvent> {
        return NSFetchRequest<FavoriteEvent>(entityName: "FavoriteEvent")
    }

    @NSManaged public var categories: String?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var eventDescription: String?
    @NSManaged public var id: Int32
    @NSManaged public var imageURL: String?
    @NSManaged public var isFree: Bool
    @NSManaged public var location: String?
    @NSManaged public var placeTitle: String?
    @NSManaged public var price: String?
    @NSManaged public var shortTitle: String?
    @NSManaged public var slug: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var title: String?

}

extension FavoriteEvent : Identifiable {

}
