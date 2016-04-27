//
//  ServerManager.swift
//  Caltrain
//
//  Created by Genady Okrain on 3/3/16.
//  Copyright © 2016 Okrain. All rights reserved.
//

import Foundation

class ServerManager {
    static func load(url: String, completion: ((parties: [Party], JSON: AnyObject?) -> Void)?) {
        if let url = NSURL(string: url) {
            let request = NSURLRequest(URL: url)
            let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
            let task = session.dataTaskWithRequest(request) { data, _, _ in
                dispatch_async(dispatch_get_main_queue()) {
                    if let data = data {
                        do {
                            let response = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                            completion?(parties: processJSON(response), JSON: response)
                        } catch {
                            completion?(parties: [], JSON: nil)
                        }
                    } else {
                        completion?(parties: [], JSON: nil)
                    }
                }
            }
            task.resume()
        } else {
            completion?(parties: [], JSON: nil)
        }
    }

    static func processJSON(JSON: AnyObject?) -> [[Party]] {
        var ps = [Party]()
        if let parties = JSON as? [AnyObject] {
            for party in parties {
                if let p = party as? [String: AnyObject],
                    objectId = p["objectId"] as? String,
                    icon = p["icon"] as? String, iconURL = NSURL(string: icon),
                    logo = p["logo"] as? String, logoURL = NSURL(string: logo),
                    title = p["title"] as? String,
                    details = p["details"] as? String,
                    address1 = p["address1"] as? String,
                    address2 = p["address2"] as? String,
                    address3 = p["address3"] as? String,
                    latitude = p["latitude"] as? Double,
                    longitude = p["longitude"] as? Double,
                    url = p["url"] as? String, URL = NSURL(string: url)
                {
                    ps.append(Party(objectId: objectId, icon: iconURL, logo: logoURL, title: title, startDate: NSDate(), endDate: NSDate(), details: details, address1: address1, address2: address2, address3: address3, latitude: latitude, longitude: longitude, url: URL))
                }
            }
        }
        // sort
        // put in new array
        return ps
    }
}