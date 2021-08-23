//
//  ContentView.swift
//  BaustelleLive
//
//  Created by Felix De Montis on 17.08.21.
//

import SwiftUI
import URLImage
import Just

struct ContentView: View {
    @State var li16 = URL(string: "https://latest.baustelle.live/li16.jpg");
    @State var li27 = URL(string: "https://latest.baustelle.live/li27.jpg");
    
    var li16txt = URL(string: "https://latest.baustelle.live/li16.txt");
    var li27txt = URL(string: "https://latest.baustelle.live/li27.txt");
    
    var baustelleLiveApi = "https://latest.baustelle.live/api.json"
    
    @State var li16date = "Datum lädt..."
    @State var li27date = "Datum lädt..."
    @State var isLoading = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Lindengasse 16")
                        .font(.title)
                        .padding(.horizontal, 16.0)
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    
                    URLImage(li16!) {
                        // This view is displayed before download starts
                        EmptyView()
                    } inProgress: { progress in
                        // Display progress
                        VStack {
                            Spacer()
                            Text("Lädt...")
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .aspectRatio(4 / 3, contentMode: .fit)
                        .background(Color.gray)
                    } failure: { error, retry in
                        // Display error and retry button
                        VStack {
                            Text(error.localizedDescription)
                            Button("Retry", action: {
                                retry()
                            })
                        }
                    } content: { image, info in
                        NavigationLink(
                            destination:
                                LocationView(location: "Lindengasse 16", image: image, id: "li16", rawImage: info.cgImage, date: li16date),
                            label: {
                                image
                                    .resizable()
                                    .aspectRatio(4 / 3, contentMode: .fit)
                            })
                        
                    }
                    
                    Text(li16date)
                        .padding(.horizontal, 16.0)
                        .padding(/*@START_MENU_TOKEN@*/.bottom, 10.0/*@END_MENU_TOKEN@*/)
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    
                    Text("Lindengasse 27")
                        .font(.title)
                        .padding(.horizontal, 16.0)
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    
                    URLImage(li27!) {
                        // This view is displayed before download starts
                        EmptyView()
                    } inProgress: { progress in
                        // Display progress
                        VStack {
                            Spacer()
                            Text("Lädt...")
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .aspectRatio(16 / 9, contentMode: .fit)
                        .background(Color.gray)
                    } failure: { error, retry in
                        // Display error and retry button
                        VStack {
                            Text(error.localizedDescription)
                            Button("Retry", action: {
                                retry()
                            })
                        }
                    } content: { image, info in
                        
                        NavigationLink(
                            destination:
                                LocationView(location: "Lindengasse 27", image: image, id: "li27", rawImage: info.cgImage, date: li27date),
                            label: {
                                image
                                    .resizable()
                                    .aspectRatio(16 / 9, contentMode: .fit)
                            })
                    }
                    
                    Text(li27date)
                        .padding(.horizontal, 16.0)
                        .padding(/*@START_MENU_TOKEN@*/.bottom, 10.0/*@END_MENU_TOKEN@*/)
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                }
                
            }
            
            .padding(.top, 1)
            .navigationTitle("BaustelleLive")
            .navigationBarTitle("test")
            .toolbar(content: {
                Button(action: loadData) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                }
                .disabled(self.isLoading)
                
            })
            
        }
        .onAppear {
            loadData()
            print("hallo")
        }
        
    }
    
    func loadData() {
        self.isLoading = true
        
        let r = Just.get(baustelleLiveApi)
        
        if (r.ok) {
            print("request ok")
            let decoder = JSONDecoder()
            let apiData = try! decoder.decode(BaustelleLiveApi.self, from: r.content!)
            
            self.li16 = URL(string: apiData.li16.imageUrl);
            self.li27 = URL(string: apiData.li27.imageUrl);
            
            self.li16date = apiData.li16.human;
            self.li27date = apiData.li27.human;
            
            self.isLoading = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPod touch (7th generation)")
    }
}
