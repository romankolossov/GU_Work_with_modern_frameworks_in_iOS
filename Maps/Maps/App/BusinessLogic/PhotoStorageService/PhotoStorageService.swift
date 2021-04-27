//
//  PhotoCacheService.swift
//  Maps
//
//  Created by Roman Kolosov on 26.04.2021.
//

import UIKit

class PhotoStorageService {

    // MARK: - Private properties

    static let shared = PhotoStorageService()

    // Create images files dirrectory.

    private static let pathName: String = {
        let pathName = "images"
        guard let documentURL = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask).first else {
            return pathName
        }
        let url = documentURL.appendingPathComponent(pathName, isDirectory: true)

        guard FileManager.default.fileExists(atPath: url.path) else {
            try? FileManager.default.createDirectory(
                at: url,
                withIntermediateDirectories: true,
                attributes: nil
            )
            return pathName
        }
        return pathName
    }()

    // MARK: - Initializers

    private init() { }

    // MARK: - Public methods

    func saveImage(image: UIImage, forKey key: String) {
        guard let filePath = getFilePath(forKey: key),
              let data = image.pngData() else {
            return
        }
        FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil)
    }

    func retrieveImage(forKey key: String) -> UIImage? {
        guard let filePath = getFilePath(forKey: key) else {
            return nil
        }
        // let fileData = FileManager.default.contents(atPath: filePath)
        // let image = UIImage(data: fileData)
        let image = UIImage(contentsOfFile: filePath)

        return image
    }

    // MARK: - Private methods

    // Get image file path basing on image name.

    private func getFilePath(forKey key: String) -> String? {
        guard let documentURL = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask).first else {
            return nil
        }
        let documentName = key
        let path = documentURL.appendingPathComponent(PhotoStorageService.pathName + "/" + documentName).path

        return path
    }

}
