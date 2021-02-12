//
//  Home.swift
//  UI-124
//
//  Created by にゃんにゃん丸 on 2021/02/12.
//

import SwiftUI
import AVKit

struct Home: View {
    @EnvironmentObject var model : HomeViewModel
    @Environment(\.colorScheme) var scheme
    
    init() {
        UITabBar.appearance().backgroundColor = .gray
    }
    var body: some View {
        NavigationView{
            
            VStack{
                
                ScrollView{
                    
                    Image("p1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 768, height: 850)
                        .offset(x: 200)
                        .overlay(
                        
                        Text("我が名はチーター\n地上最速")
                            .font(.system(size: 40, weight: .heavy))
                            .font(.largeTitle)
                            .foregroundColor(.red)
                            .kerning(1.3)
                            .multilineTextAlignment(.center)
                            
                            
                            
                            
                            ,alignment: .top
                        )
                      
                    
                    
                }
                
                HStack(spacing:15){
                    
                    Button(action:
                        
                            model.openimagepicker
                        
                        
                        
                    , label: {
                        Image(systemName:model.ShowimagePicker ? "minus" : "plus")
                            .font(.title)
                            .foregroundColor(.gray)
                        
                        
                    })
                    TextField("Enter Message", text: $model.txt, onEditingChanged: { (opend) in
                        
                        if opend && model.ShowimagePicker{
                            
                            withAnimation{
                                
                                model.ShowimagePicker.toggle()
                            }
                        }
                        
                    })
                        .padding(.vertical,10)
                        .padding(.horizontal)
                        .background(Color.primary.opacity(0.06))
                        .clipShape(Capsule())
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "mic")
                            .font(.title)
                            .foregroundColor(.gray)
                        
                        
                    })
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "camera")
                            .font(.title)
                            .foregroundColor(.gray)
                        
                        
                    })
                    
                    
                    
                }
                .padding(.horizontal)
                .padding(.bottom,5)
                
                
                ScrollView(.horizontal, showsIndicators: false, content: {
                    
                    HStack(spacing:10){
                        
                        ForEach(model.fetchPhotos){photo in
                            
                            ThumnailView(photo: photo)
                                .onTapGesture {
                                    model.extractpreviewData(asset: photo.asset)
                                    model.showpreview.toggle()
                                }
                            
                            
                            
                        }
                        
                        if model.libray_Status == .deneid || model.libray_Status == .limited{
                            
                            VStack{
                                
                                Text(model.libray_Status == .deneid ? "Allow Access For Photo" : "Select MorePhoto")
                                    .multilineTextAlignment(.center)
                                
                                Button(action: {
                                    
                                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                                    
                                    
                                }) {
                                    Text(model.libray_Status == .deneid ? "Allow Access" : "Select More")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.vertical,10)
                                        .padding(.horizontal)
                                        .background(Color.blue)
                                        .cornerRadius(5)
                                    
                                    
                                }
                                
                                
                            }
                            .frame(width: 150)
                            
                            
                        }
                        
                        
                        
                    }
                    
                })
                .frame(height: model.ShowimagePicker ? 200 : 0)
                .background(Color.gray.opacity(0.02).ignoresSafeArea(.all, edges: .bottom))
                .opacity(model.ShowimagePicker ? 1 : 0)
                
                
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                        
                    })
                    
                }
                
                ToolbarItem(id: "Profile", placement: .navigationBarLeading, showsByDefault: true) {
                    
                    HStack(spacing:8){
                        
                        Circle()
                            .fill(Color.red)
                            .frame(width: 35, height: 35)
                            .overlay(
                            
                            Text("K")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                
                            )
                        
                        Divider()
                            .background(Color.purple)
                            .padding(.vertical,-5)
                        
                        Image("p1")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 35, height: 35)
                            .cornerRadius(10)
                        
                        Divider()
                            .background(Color.purple)
                            .padding(.vertical,-5)
                        
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Image(systemName: "pencil")
                                .font(.title)
                            
                            Text("Write")
                                .font(.title)
                                .fontWeight(.light)
                                .foregroundColor(.blue)
                                .kerning(2.3)
                        })
                        
                        
                        
                    }
                    
                }
                
                
                
                
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                        
                    })
                    
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "sun.min.fill")
                            .font(.title2)
                        
                    })
                    
                }
                
                
                
                
            })
            
            
            
        }
        .accentColor(scheme == .dark ? Color.white : Color.primary)
       
        .onAppear(perform: {model.setup()})
        .sheet(isPresented: $model.showpreview) {
            
            model.selectedvideopreview = nil
            model.selectedimagepreview = nil
            
        } content: {
            
        PreViewView()
            
        }

     
        
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct PreViewView : View {
    
    @EnvironmentObject var model : HomeViewModel
    var body: some View{
        
        NavigationView{
            
            ZStack{
                
            
                
                if model.selectedvideopreview != nil{
                    
                    VideoPlayer(player: AVPlayer(playerItem: AVPlayerItem(asset: model.selectedvideopreview)))
                
                    
                }
                
                if model.selectedimagepreview != nil{
                    
                    Image(uiImage: model.selectedimagepreview)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                    
            
                    
                    
                    
                }
                
            
            }
            .padding()
            .ignoresSafeArea(.all, edges: .bottom)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Text("Send")
                        .font(.title)
                        .bold()
                        .foregroundColor(.green)
                    
                }
            }
            
        }
        
    }
}

struct ThumnailView : View {
    
    var photo : Asset
    var body: some View{
        
        ZStack(alignment: .bottomTrailing) {
            
            Image(uiImage: photo.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .cornerRadius(15)
            
            if photo.asset.mediaType == .video{
                
                Image(systemName: "video.bubble.left.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(8)
                
            }
            
                
            
            
        }
        
        
    }
}
