//
//  Requests.swift
//  ReminderProject
//
//  Created by Blumer, Seth on 6/16/23.
//

import Foundation

let URI = "https://3s5hv467o8.execute-api.us-east-1.amazonaws.com/reminders"

//struct ReminderModel: Codable {
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
    dateFormatter.dateFormat = "MMM d, h:mm a"
    return dateFormatter.string(from: reminderDate)
}

func addReminder(reminderDate: Date, reminderTitle: String, reminderNotes: String, isRepeat: Int) {
    // Create new reminer dictionary
    let reminderDict: JSONDictionary = ["id": UUID().uuidString,
                                       "phoneNum": "2037247233",
                                       "date": getStringFromDate(reminderDate: reminderDate),
                                       "title": reminderTitle,
                                       "notes": reminderNotes,
                                       "isRepeat": String(isRepeat)]
    
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
