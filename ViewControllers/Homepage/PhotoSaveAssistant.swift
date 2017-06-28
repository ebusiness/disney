//
//  PhotoSaveAssistant.swift
//  disney
//
//  Created by ebuser on 2017/6/28.
//  Copyright © 2017年 e-business. All rights reserved.
//

import Photos

class PhotoSaveAssistant: NSObject, FileLocalizable {

    let localizeFileName = "Homepage"

    let image: UIImage
    var userCollections: PHFetchResult<PHCollection>!
    private var saveLock = false
    private var album: PHAssetCollection?
    private var status = PhotoSaveAssistantStatus.none {
        didSet {
            print("current status: \(status)")
        }
    }

    init(image: UIImage) {
        self.image = image
    }

    deinit {
        print("photo library notification unregistered")
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    func save() {
        if saveLock {
            return
        } else {
            saveLock = true
        }
        status = .began

        PHPhotoLibrary.shared().register(self)
        userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)

        checkFolderAndSaveFile()
    }

    private func checkFolderAndSaveFile() {

        album = existFolder()

        if album != nil {
            status = .folderCreated
            saveFile()
        } else {
            createFolderAndSaveFile()
        }
    }

    private func existFolder() -> PHAssetCollection? {
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined:
            status = .authorizationWaiting
            return nil
        case .denied, .restricted:
            status = .failed
            return nil
        case .authorized:
            break
        }

        let albumTitle = localize(for: "Photo Library Album")

        var photoCollection: PHAssetCollection?
        userCollections.enumerateObjects { (collection, _, stop) in
            if collection.localizedTitle == albumTitle {
                photoCollection = collection as? PHAssetCollection
                stop.pointee = true
            }
        }

        return photoCollection
    }

    private func createFolderAndSaveFile() {
        let albumTitle = localize(for: "Photo Library Album")
        var assetCollectionPlaceholder: PHObjectPlaceholder!
        PHPhotoLibrary.shared().performChanges({
            let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumTitle)
            assetCollectionPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
        }, completionHandler: { success, _ in
            if success {
                let collectionFetchResult =
                    PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [assetCollectionPlaceholder.localIdentifier],
                                                            options: nil)
                self.album = collectionFetchResult.firstObject
                self.saveFile()
            }
        })
    }

    private func saveFile() {
        guard let album = album else {
            status = .failed
            return
        }

        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetChangeRequest.creationRequestForAsset(from: self.image)
            let addAssetRequest = PHAssetCollectionChangeRequest(for: album)
            addAssetRequest?.addAssets([creationRequest.placeholderForCreatedAsset!] as NSArray)
        }, completionHandler: { [weak self] success, _ in
            if success {
                self?.status = .fileSaved
            }
        })
    }
}

extension PhotoSaveAssistant: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        if status == .authorizationWaiting {
            status = .authorizationPassed
            checkFolderAndSaveFile()
        }
    }
}

enum PhotoSaveAssistantStatus {
    case none
    case began
    case authorizationWaiting
    case authorizationPassed
    case folderCreated
    case fileSaved
    case failed
}
