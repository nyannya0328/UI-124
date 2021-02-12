//
//  HomeViewModel.swift
//  UI-124
//
//  Created by にゃんにゃん丸 on 2021/02/12.
//

import SwiftUI
import Photos
import AVKit

class HomeViewModel: NSObject, ObservableObject,PHPhotoLibraryChangeObserver {
   
    
    @Published var txt = ""
    
    @Published var ShowimagePicker = false
    
    @Published var libray_Status = LibraryStatas.deneid
    
    @Published var fetchPhotos : [Asset] = []
    
    @Published var allphotos : PHFetchResult<PHAsset>!
    
    @Published var showpreview = false
    @Published var selectedimagepreview : UIImage!
    @Published var selectedvideopreview : AVAsset!
    
    func openimagepicker(){
        
        withAnimation{
            
            UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
            if fetchPhotos.isEmpty{
               fetchphot()
                
                
            }
            
            
            ShowimagePicker.toggle()
        }
        
       
    }
    
    
    func setup(){
        PHPhotoLibrary.requestAuthorization(for: .readWrite) {[self] (statas) in
            
            DispatchQueue.main.async {
                switch statas{
                
                case.denied :libray_Status = .deneid
                case .authorized : libray_Status = .approved
                case .limited : libray_Status = .limited
                default : libray_Status = .deneid
                    
                  

                }
                
            }
           
        }
        PHPhotoLibrary.shared().register(self)
        
        
    }
    
    func fetchphot(){
        
        let options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        
        ]
        
        options.includeHiddenAssets = false
        
        let fetchresult = PHAsset.fetchAssets(with: options)
        allphotos = fetchresult
        fetchresult.enumerateObjects {[self] (asset, index, _) in
            
            getImageFromAsset(asset: asset, size: CGSize(width: 150, height: 150)) { (image) in
                fetchPhotos.append(Asset(asset: asset, image: image))
            }
            
        }
        
        
        
    }
    
    func getImageFromAsset(asset : PHAsset,size:CGSize,competion:@escaping(UIImage)->()){
        
        let imagemanager = PHCachingImageManager()
        imagemanager.allowsCachingHighQualityImages = true
        let imageoptions = PHImageRequestOptions()
        imageoptions.deliveryMode = .highQualityFormat
        imageoptions.isSynchronous = false
        
        let size = CGSize(width: 150, height: 150)
        
        imagemanager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: imageoptions) { (image, _) in
            guard let resized = image else {return}
            
            competion(resized)
        }
        
        
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let _ = allphotos else {return}
        
        if let updates = changeInstance.changeDetails(for: allphotos){
            let updatephoto = updates.fetchResultAfterChanges
            updatephoto.enumerateObjects{[self] (asset, index, _) in
                if !allphotos.contains(asset){
                    
                    getImageFromAsset(asset: asset, size: CGSize(width: 150, height: 150)) { (image) in
                        DispatchQueue.main.async {
                            fetchPhotos.append(Asset(asset: asset, image: image))
                        }
                    }
                    
                    
                }
            }
            allphotos.enumerateObjects{ (asset, index, _) in
                
                DispatchQueue.main.async {
                    self.fetchPhotos.removeAll { (result) -> Bool in
                        return result.asset == asset
                    }
                }
                
            }
            DispatchQueue.main.async {
                self.allphotos = updatephoto
            }
            
            
        }
    }
    
    func extractpreviewData(asset:PHAsset){
        let manager = PHCachingImageManager()
        
        if asset.mediaType == .image{
            
            getImageFromAsset(asset: asset, size: PHImageManagerMaximumSize) { (image) in
                DispatchQueue.main.async {
                    self.selectedimagepreview = image
                }
            }
        
            
            
            
        }
        if asset.mediaType == .video{
            
            let videomanager = PHVideoRequestOptions()
            videomanager.deliveryMode = .highQualityFormat
            manager.requestAVAsset(forVideo: asset, options: videomanager) { (videoasset, _, _) in
                guard let videourl = videoasset else{return}
                
                DispatchQueue.main.async {
                    self.selectedvideopreview = videourl
                }
                
               
            }
            
            
            
        }
        
        
    }
    
    
}


