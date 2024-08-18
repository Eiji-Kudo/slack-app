import Alamofire

class SlackAPIService {
    private let token = ProcessInfo.processInfo.environment["SLACK_API_TOKEN"] ?? ""
    private let baseURL = "https://slack.com/api/"
    
    func fetchMessages(channel: String, completion: @escaping ([String]) -> Void) {
        let url = "\(baseURL)conversations.history"
        let parameters: [String: Any] = ["channel": channel]
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, parameters: parameters, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any], let messages = json["messages"] as? [[String: Any]] {
                    let texts = messages.compactMap { $0["text"] as? String }
                    completion(texts)
                } else {
                    completion([])
                }
            case .failure:
                completion([])
            }
        }
    }
    
    func postMessage(channel: String, text: String, completion: @escaping (Bool) -> Void) {
        let url = "\(baseURL)chat.postMessage"
        let parameters: [String: Any] = ["channel": channel, "text": text]
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any], let ok = json["ok"] as? Bool {
                    completion(ok)
                } else {
                    completion(false)
                }
            case .failure:
                completion(false)
            }
        }
    }
}