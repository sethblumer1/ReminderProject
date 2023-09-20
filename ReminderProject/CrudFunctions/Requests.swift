//
//  Requests.swift
//  ReminderProject
//
//  Created by Blumer, Seth on 6/16/23.
//

import Foundation

let URI = "https://3s5hv467o8.execute-api.us-east-1.amazonaws.com/reminders"

// struct ReminderModel: Codable {
//    var id: String
//    var userPhoneNumber: String
//    var reminderDate: String
//    var reminderTitle: String
//    var reminderNotes: String
//    var isRepeat: String
//}

typealias JSONDictionary = [String : Any]

func dictionaryToString(jsonDictionary: JSONDictionary) -> String {
  do {
    let data = try JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
    return String(data: data, encoding: String.Encoding.utf8) ?? ""
  } catch {
    return ""
  }
}

func getStringFromDate(reminderDate: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d yyyy, h:mm a"
    return dateFormatter.string(from: reminderDate)
}

func addReminderHosted(id: String, reminderDate: Date, reminderTitle: String, reminderNotes: String, isRepeat: Int) {
    var minutesOffset: Int { return TimeZone.current.secondsFromGMT() }
    let hoursOffset = minutesOffset / 3600 * -1
    
    // Create new reminer dictionary
    let reminderDict: JSONDictionary = ["id": id,
                                       "phoneNum": "12037247233",
                                       "date": getStringFromDate(reminderDate: reminderDate),
                                       "title": reminderTitle,
                                       "notes": reminderNotes,
                                       "isRepeat": String(isRepeat),
                                       "hoursOffset": String(hoursOffset),
                                       "textSent": false]
    
    print(reminderDict)
    
    // Stringify dictionary
    let reminderDictStringified = dictionaryToString(jsonDictionary: reminderDict)
        
    let reminderData = reminderDictStringified.data(using: .utf8)
    
    // Create request
    var request = URLRequest(url: URL(string: URI)!,timeoutInterval: 30)
    
    // Set request headers
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // Set request parameters
    request.httpMethod = "PUT"
    request.httpBody = reminderData
    
    // Send to database
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data else {
        print(String(describing: error))
        return
      }
      print(String(data: data, encoding: .utf8)!)
    }

    task.resume()
}

func deleteRemindersHosted(id: String) {
    var URIString = URI + "/" + id
    print("URI String \(URIString)")
    var request = URLRequest(url: URL(string: URIString)!,timeoutInterval: 30)
    request.httpMethod = "DELETE"

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data else {
        print(String(describing: error))
        return
      }
      print(String(data: data, encoding: .utf8)!)
    }

    task.resume()
}


func getRemindersHosted(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
    guard let url = URL(string: urlString) else {
        let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        completion(.failure(error))
        return
    }
    
    let request = URLRequest(url: url)
    let session = URLSession.shared
    
    let task = session.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            let error = NSError(domain: "No data received", code: 0, userInfo: nil)
            completion(.failure(error))
            return
        }
        
        completion(.success(data))
    }
    
    task.resume()
}
