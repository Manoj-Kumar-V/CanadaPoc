//
//  apiHandler.swift
//  Canada
//
//  Created by Manoj on 25/04/20.
//  Copyright © 2020 Manoj. All rights reserved.
//

import Foundation
import UIKit

struct CanadaResponse: Decodable {
    let title: String?
    let rows: [Row]?
}

struct Row: Decodable {
    let title: String?
    let description: String?
    let imageHref: String?
    
}
class apiHandler {
    
    static let shared = apiHandler()
    
    func makeApiCall(onSuccess: ((CanadaResponse) -> Void)? , onError: ((NSError) -> Void)? = nil ){
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts")!
        let task = session.dataTask(with: url) { data, response, error in
            
            // ensure there is no error for this HTTPS response
            guard error == nil else {
                print ("error: \(error!)")
                return
            }
            
            // ensure there is data returned from this HTTPS response
            guard let content = data else {
                print(NSLocalizedString("NO_DATA", comment: "NO_DATA"))
                return
            }
            let tempStr = String.init(data: content, encoding: String.Encoding.isoLatin1)
            guard let encodedData = tempStr?.data(using: String.Encoding.utf8) else {return}
            let canadaRes: CanadaResponse = try! JSONDecoder().decode(CanadaResponse.self, from: encodedData)
            onSuccess!(canadaRes)
        }
        task.resume()
        
    }
}
