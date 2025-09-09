//
//  LocationField.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 09.09.25.
//

// В CoreModels.swift

enum LocationField: Codable {
    case slug(String)
    case full(Location)

    init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if let s = try? c.decode(String.self) {
            self = .slug(s)
        } else {
            self = .full(try c.decode(Location.self))
        }
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.singleValueContainer()
        switch self {
        case .slug(let s): try c.encode(s)
        case .full(let loc): try c.encode(loc)
        }
    }

    var slug: String? {
        switch self {
        case .slug(let s): return s
        case .full(let loc): return loc.slug
        }
    }

    var model: Location? {
        switch self {
        case .slug: return nil
        case .full(let loc): return loc
        }
    }
}
