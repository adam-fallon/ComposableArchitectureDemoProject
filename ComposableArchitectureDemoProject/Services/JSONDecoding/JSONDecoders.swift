//
//  JSONDecoders.swift
//  ComposableArchitectureDemoProject
//
//  Created by Adam Fallon on 13/12/2022.
//

import Foundation
import ComposableArchitecture

enum DecoderType {
    case iso8601
}

enum DecoderError: Error {
    case noDecoderInCache
}

struct JSONDecoders {
    private static var cache: [DecoderType: JSONDecoder] = [.iso8601: iso8601JsonDecoder]
    var decoder: (DecoderType) throws -> JSONDecoder
    
    private static let iso8601JsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }()
}

extension JSONDecoders {
    static let live = Self(
        decoder: { type in
            switch type {
            case .iso8601:
                guard let decoder = cache[.iso8601] else {
                    throw DecoderError.noDecoderInCache
                }
                
                return decoder
            }
        }
    )
}

extension JSONDecoders: TestDependencyKey {
    static let testValue = JSONDecoders.live
}

extension JSONDecoders: DependencyKey {
    static let liveValue = JSONDecoders.live
}

extension DependencyValues {
  var jsonDecoders: JSONDecoders {
    get { self[JSONDecoders.self] }
    set { self[JSONDecoders.self] = newValue }
  }
}
