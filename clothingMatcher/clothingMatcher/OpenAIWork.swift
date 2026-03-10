//
//  OpenAIWork.swift
//  clothingMatcher
//
//  Created by Dylan Madden on 4/21/25.
//

//this whole class took me FOREVER. working with AI was the recommened way to create this app. because it is relativly new there isn't a million articles about how to make this happen
//thanks to claude and openAI for helping and my parents who both have some experience in AI
import Foundation
import SwiftUI
let devMode = false //allows me to switch and test so i dont spend money on every test run. money = me happy ;)
//also devmode is for local testing

//gets the openAI api key from info
//doing it this way because open suggested that this was safer
func getAPIKey() -> String? {
    return Bundle.main.infoDictionary?["OpenAI_API_Key"] as? String
}


//sends formatted text to openai as a request to get the feedback
//gets descirption and is told to return feedback
func getOutfitFeedback(from description: String, completion: @escaping (String?) -> Void) {
    //first have to see if we are testing
    if devMode {
        print("Dev Mode: Using mock response.")
        completion("Mock Feedback: the suit almost looks as good as you") //this joke made me laugh at 1AM
        return
    }
    
    //safely unwrap the API key  (also advice given from openai)
    guard let apiKey = getAPIKey() else {
        completion("API key not found.")
        return
    }

    //setup API url and request headers
    let url = URL(string: "https://api.openai.com/v1/chat/completions")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    //JSON body that is the prompt and insturctions that is given to the system
    //I formated it into bullet points because someone on instagram stated that AI simply reads things better when in bullet point form so yeah...
    let body: [String: Any] = [
        "model": "gpt-3.5-turbo",
        "messages": [
            ["role": "system", "content": "You are a fashion stylist. Be helpful and honest."],
            ["role": "user", "content":"""
            Give me outfit feedback for the following outfit:\n\(description)

            Do not include hex codes or color values. Split your response into two sections, each starting with a bold heading on its own line: “What Works” and “What Could Improve.”

            - The “What Works” section should be 2–3 short sentences explaining which color combinations or item choices work well and why.
            - The “What Could Improve” section should also be 2–3 short sentences. First, suggest clothing colors or types for any items marked as “Not selected.” Then, briefly suggest any possible improvements to the chosen outfit.

            You may suggest alternatives if they would improve overall style or coordination.
            """
            ]

        ]
    ]

    //send the actual request
    request.httpBody = try? JSONSerialization.data(withJSONObject: body)
    
    
//network request to openAI. thanks to my dad who helped me with this section :)
    //do the api call
    URLSession.shared.dataTask(with: request) { data, response, error in
        //check for a valid response and if not my phone bugs out for 5 minutes :(
        guard let data = data else {
            completion("No data received.")
            return
        }

        //parsing the json response
        do {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let choices = json["choices"] as? [[String: Any]],
               let message = choices.first?["message"] as? [String: Any],
               let content = message["content"] as? String {
                //returns the formatted feedback string
                completion(content)
            } else {
                //if it couldnt parse which happened a lot
                completion("Could not parse response.")
            }
            //i did this just to be safe but i actually dont know if you need it
        } catch {
            completion("Error decoding response.")
        }
    }.resume() //start the task
}
