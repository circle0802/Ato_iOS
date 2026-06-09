//
//  APIConstants.swift
//  Ato
//
//  Created by Codex on 6/9/26.
//

import Foundation

enum APIConstants {
    nonisolated static var baseURL: URL {
        guard
            let baseURLString = Bundle.main.object(forInfoDictionaryKey: "APIBaseURL") as? String,
            !baseURLString.isEmpty,
            !baseURLString.contains("$("),
            let baseURL = URL(string: baseURLString)
        else {
            fatalError("API_BASE_URL is missing. Create Ato/Config/Local.xcconfig from Local.xcconfig.example.")
        }

        return baseURL
    }
}
