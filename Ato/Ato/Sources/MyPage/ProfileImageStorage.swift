//
//  ProfileImageStorage.swift
//  Ato
//
//  Created by Codex on 6/11/26.
//

import Foundation
import UIKit

enum ProfileImageStorage {
    static func saveImageData(_ data: Data) throws -> String {
        guard let image = UIImage(data: data), let jpegData = image.jpegData(compressionQuality: 0.86) else {
            throw APIError.invalidResponse
        }

        let directoryURL = try profileImageDirectoryURL()
        let fileURL = directoryURL.appendingPathComponent("\(UUID().uuidString).jpg")
        try jpegData.write(to: fileURL, options: [.atomic])
        return fileURL.absoluteString
    }

    static func localImageData(from urlString: String?) -> Data? {
        guard
            let urlString,
            let url = URL(string: urlString),
            url.isFileURL
        else {
            return nil
        }

        return try? Data(contentsOf: url)
    }

    private static func profileImageDirectoryURL() throws -> URL {
        let documentsURL = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        let directoryURL = documentsURL.appendingPathComponent("ProfileImages", isDirectory: true)

        if !FileManager.default.fileExists(atPath: directoryURL.path) {
            try FileManager.default.createDirectory(
                at: directoryURL,
                withIntermediateDirectories: true
            )
        }

        return directoryURL
    }
}
