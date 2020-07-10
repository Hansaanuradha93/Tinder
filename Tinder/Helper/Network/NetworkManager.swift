import UIKit

class NetworkManager {
    
    // MARK: Properties
    static let shared = NetworkManager()
    fileprivate let cache = NSCache<NSString, UIImage>()
    
    // MARK: Initializers
    private init() {}
}


// MARK: - Methods
extension NetworkManager {
    
    func cacheImage(from urlString: String) {
        let cacheKey = NSString(string: urlString)
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self,
                    error == nil,
                    let response = response as? HTTPURLResponse, response.statusCode == 200,
                    let data = data,
                    let image = UIImage(data: data) else { return }
            self.cache.setObject(image, forKey: cacheKey)
        }
        task.resume()
    }
    
    
    func downloadImage(from urlString: String, completed: @escaping(UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self,
                    error == nil,
                    let response = response as? HTTPURLResponse, response.statusCode == 200,
                    let data = data,
                    let image = UIImage(data: data) else {
                        completed(nil)
                        return
            }
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
    }
}

