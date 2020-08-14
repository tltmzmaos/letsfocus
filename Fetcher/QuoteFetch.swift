//
//  QuoteFetch.swift
//  studyfocus
//
//  Created by Jongmin Lee on 7/18/20.
//  Copyright © 2020 Jongmin Lee. All rights reserved.
//

import Foundation

class QuoteFetch: ObservableObject{
    @Published var quote = [Quote]()
    
    init(){
        guard let url = URL(string: "https://zenquotes.io/api/quotes") else{
            return
        }
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        session.dataTask(with: request){ (data, _, _) in
            guard let data = data else { return }
            do{
                print(data)
                let fetch = try JSONDecoder().decode([Quote].self, from: data)
                DispatchQueue.main.async {
                    self.quote = fetch
                }
            }catch let err{
                print("Decoder error: \(err)")
            }
        }.resume()
    }

}
