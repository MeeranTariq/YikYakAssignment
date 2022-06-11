import Foundation

class TranslationViewModel: ObservableObject {
    
    @Published var languages: [Language] = []
    @Published var translatedText: String = String()
    
    
    func fetchAvailableLanguages() {
        makeRequest(to: Endpoint.languages, method: "GET", completion: { (data) in
            do {
                let languages = try JSONDecoder().decode([Language].self, from: data)
                self.languages = languages
            }
            catch {
                print("Unable to decode response data | Fetching Languages")
            }
        })
    }
    
    func detectLanguage(for text: String, completion: @escaping (String?) -> ()) {
        makeRequest(
            to: Endpoint.detect,
            method: "POST", params: [
                URLQueryItem(name: "q", value: text)
            ],
            completion: { data in
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary] {
                        completion(json[0]["language"] as? String);
                    } else {
                        let jsonStr = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                        // No error thrown, but not array of Array of Dict
                        print("Error could not parse JSON Array: \(String(describing: jsonStr))")
                    }
                } catch let parseError {
                    print(parseError)
                }
            })
    }
    
    func translate(text: String, from: String, to: String) {
        
        makeRequest(
            to: Endpoint.translate,
            method: "POST",
            params: [
                URLQueryItem(name: "q", value: text),
                URLQueryItem(name: "source", value: from),
                URLQueryItem(name: "target", value: to),
                URLQueryItem(name: "format", value: "text")
            ],
            completion: { data in
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        guard let text = json["translatedText"] as? String else {
                            return
                        }
                        self.translatedText = text
                    } else {
                        let jsonStr = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                        // No error thrown, but not NSDictionary
                        print("Error could not parse JSON: \(String(describing: jsonStr))")
                    }
                } catch let parseError {
                    print(parseError)
                }
            })
    }
}
