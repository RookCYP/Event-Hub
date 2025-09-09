//
//  StringOrInt.swift
//  Event Hub
//
//  Created by Aleksandr Meshchenko on 09.09.25.
//


enum StringOrInt: Codable, Equatable {
    case string(String)
    case int(Int)

    init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if let s = try? c.decode(String.self) {
            self = .string(s)
        } else if let i = try? c.decode(Int.self) {
            self = .int(i)
        } else if c.decodeNil() {
            self = .string("") // или бросай ошибку/делай отдельный case
        } else {
            throw DecodingError.typeMismatch(
                StringOrInt.self,
                .init(codingPath: decoder.codingPath,
                      debugDescription: "Expected String or Int")
            )
        }
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.singleValueContainer()
        switch self {
        case .string(let s): try c.encode(s)
        case .int(let i):    try c.encode(i)
        }
    }

    var text: String {
        switch self {
        case .string(let s): return s
        case .int(let i):    return "\(i)+"
        }
    }
}
