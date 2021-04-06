import Foundation

class Bindable<T> {
    
    var value: T? {
        didSet { observer?(value) }
    }
    
    
    private var observer: ((T?) -> ())?
    
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}
