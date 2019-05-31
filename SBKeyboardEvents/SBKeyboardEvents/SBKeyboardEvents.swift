// MARK: - KeyboardEventListener

public protocol KeyboardEventListener: class {
    
    func keyboardWillAppear()
    func keyboardDidAppear()
    func keyboardWillHide()
    func keyboardDidHide()
    func keyboardWillChangeFrame(_ frame: CGRect)
    func keyboardDidChangeFrame(_ frame: CGRect)
    func animateForKeyboardFrame(_ frame: CGRect)
    func animateForKeyboardHeight(_ height: CGFloat)
}

public extension KeyboardEventListener {
    
    func keyboardWillAppear() {}
    func keyboardDidAppear() {}
    func keyboardWillHide() {}
    func keyboardDidHide() {}
    func keyboardWillChangeFrame(_ frame: CGRect) {}
    func keyboardDidChangeFrame(_ frame: CGRect) {}
    func animateForKeyboardFrame(_ frame: CGRect) {}
    func animateForKeyboardHeight(_ height: CGFloat) {}
}

public class SBKeyboardEvents: NSObject {
    
    // MARK: - Public API
    
    public class func addListener(_ listener: KeyboardEventListener) {
        self.sharedInstance.addListener(listener)
    }
    
    public class func removeListener(_ listener: KeyboardEventListener) {
        self.sharedInstance.removeListener(listener)
    }
    
    public class func removeAllListeners() {
        self.sharedInstance.removeAllListeners()
    }
    
    public class func isKeyboardVisible() -> Bool {
        return self.sharedInstance.isKeyboardVisibleFlag
    }
    
    // MARK: - Singleton (Private)
    
    static let sharedInstance = SBKeyboardEvents()
    private var wrappedListeners = [SBKeyboardListenerWeakWrapper]()
    private var isKeyboardVisibleFlag = false
    
    var listeners: [KeyboardEventListener] {
        
        removeDeallocatedListeners()
        
        var unwrappedListeners = [KeyboardEventListener]()
        for wrapper in self.wrappedListeners {
            if let listener = wrapper.listener {
                unwrappedListeners.append(listener)
            }
        }
        return unwrappedListeners
    }
    
    // MARK: - Init
    
    override init() {
        
        super.init()
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self,
                                       selector: #selector(SBKeyboardEvents.keyboardWillShow),
                                       name: UIResponder.keyboardWillShowNotification,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(SBKeyboardEvents.keyboardDidShow),
                                       name: UIResponder.keyboardDidShowNotification,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(SBKeyboardEvents.keyboardWillHide),
                                       name: UIResponder.keyboardWillHideNotification,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(SBKeyboardEvents.keyboardDidHide),
                                       name: UIResponder.keyboardDidHideNotification,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(SBKeyboardEvents.keyboardWillChangeFrame),
                                       name: UIResponder.keyboardWillChangeFrameNotification,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(SBKeyboardEvents.keyboardDidChangeFrame),
                                       name: UIResponder.keyboardDidChangeFrameNotification,
                                       object: nil)
    }
    
    // MARK: - Manage Listeners
    
    func addListener(_ listener: KeyboardEventListener) {
        
        let wrapper = SBKeyboardListenerWeakWrapper(listener: listener)
        self.wrappedListeners.append(wrapper)
    }
    
    func removeListener(_ listener: KeyboardEventListener) {

        self.wrappedListeners = self.wrappedListeners.filter {
            
            guard let aListener = $0.listener else { return false }
            return aListener !== listener
        }
    }
    
    func removeAllListeners() {
       self.wrappedListeners.removeAll()
    }
    
    private func removeDeallocatedListeners() {
        self.wrappedListeners = self.wrappedListeners.filter { $0.listener != nil }
    }
    
    // MARK: - Keyboard Notifications
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        
        isKeyboardVisibleFlag = true
        
        for listener in self.listeners {
            listener.keyboardWillAppear()
        }
        
        let duration = notification.duration()
        let animationCurve = notification.animationCurve()
        let frame = notification.endFrame()
        
        doAnimationCallback(duration: duration, animationCurve: animationCurve, frame: frame)
    }
    
    @objc private func keyboardDidShow(_ notification: Notification) {
        
        for listener in self.listeners {
            listener.keyboardDidAppear()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        
        isKeyboardVisibleFlag = false
        
        for listener in self.listeners {
            listener.keyboardWillHide()
        }
        
        let duration = notification.duration()
        let animationCurve = notification.animationCurve()
        let frame = notification.endFrame()
        
        doAnimationCallback(duration: duration, animationCurve: animationCurve, frame: frame, height: 0)
    }
    
    @objc private func keyboardDidHide(_ notification: Notification) {
        
        for listener in self.listeners {
            listener.keyboardDidHide()
        }
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        
        if !self.isKeyboardVisibleFlag {
            return
        }
        
        if listeners.count == 0 {
            return
        }
        
        let endFrame = notification.endFrame()
        let animationCurve = notification.animationCurve()
        let duration = notification.duration()

        for listener in self.listeners {
            listener.keyboardWillChangeFrame(endFrame)
        }

        doAnimationCallback(duration: duration, animationCurve: animationCurve, frame: endFrame)
        
    }
    
    @objc private func keyboardDidChangeFrame(_ notification: Notification) {
        
        for listener in self.listeners {
            listener.keyboardDidChangeFrame(notification.endFrame())
        }
    }
    
    private func doAnimationCallback(duration: Double,
                                     animationCurve: UInt,
                                     frame: CGRect,
                                     height: CGFloat? = nil) {
        
        let options = UIView.AnimationOptions(rawValue: UInt(animationCurve << 16))
        
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            
            for listener in self.listeners {
                listener.animateForKeyboardFrame(frame)
                listener.animateForKeyboardHeight( height ?? UIScreen.main.bounds.size.height - frame.origin.y )
            }
            
            }, completion: nil)
    }
    
}

// MARK: - Supporting classes / extensions

struct SBKeyboardListenerWeakWrapper {
    weak var listener: KeyboardEventListener?
    
    init(listener: KeyboardEventListener) {
        self.listener = listener
    }
}

// swiftlint:disable force_cast
extension Notification {
    
    func startFrame() -> CGRect {
        let dictionary = userInfo! as Dictionary
        let startFrame = (dictionary[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        return startFrame
    }
    
    func endFrame() -> CGRect {
        let dictionary = userInfo! as Dictionary
        let endFrame = (dictionary[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        return endFrame
    }
    
    func duration() -> Double {
        let dictionary = userInfo! as Dictionary
        let duration = (dictionary[UIResponder.keyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue
        return duration!
    }
    
    func animationCurve() -> UInt {
        let dictionary = userInfo! as Dictionary
        let animationCurve = (dictionary[UIResponder.keyboardAnimationCurveUserInfoKey]! as AnyObject).uintValue
        return animationCurve!
    }
    
}
// swiftlint:enable force_cast
