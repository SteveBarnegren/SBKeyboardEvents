
public protocol SBKeyboardEventsListener : class{
    
    func keyboardWillAppear()
    func keyboardDidAppear()
    func keyboardWillHide()
    func keyboardDidHide()
    func keyboardWillChangeFrame(_ frame: CGRect)
    func keyboardDidChangeFrame(_ frame: CGRect)
    func animateForKeyboardFrame(_ frame: CGRect)
    func animateForKeyboardHeight(_ height: CGFloat)
}

public extension SBKeyboardEventsListener{
   
    func keyboardWillAppear() {}
    func keyboardDidAppear() {}
    func keyboardWillHide() {}
    func keyboardDidHide() {}
    func keyboardWillChangeFrame(_ frame: CGRect) {}
    func keyboardDidChangeFrame(_ frame: CGRect) {}
    func animateForKeyboardFrame(_ frame: CGRect) {}
    func animateForKeyboardHeight(_ height: CGFloat) {}
}

extension Notification{
    
    func endFrame() -> CGRect {
        let dictionary = userInfo! as Dictionary;
        let endFrame = (dictionary[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        return endFrame
    }
    
    func duration() -> Double {
        let dictionary = userInfo! as Dictionary;
        let duration = (dictionary[UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue
        return duration!
    }
    
    func animationCurve() -> UInt {
        let dictionary = userInfo! as Dictionary;
        let animationCurve = (dictionary[UIKeyboardAnimationCurveUserInfoKey]! as AnyObject).uintValue
        return animationCurve!
    }

}

open class SBKeyboardEvents: NSObject {
    
    // MARK -  ***** Public API *****
    open class func addListener(_ listener: SBKeyboardEventsListener){
        self.sharedInstance.addListener(listener)
    }
    
    open class func removeListener(_ listener: SBKeyboardEventsListener){
        self.sharedInstance.removeListener(listener)
    }
    
    open class func removeAllListeners(){
        self.sharedInstance.removeAllListeners()
    }
    
    // MARK - ***** Private singleton *****
    static let sharedInstance = SBKeyboardEvents()
    var wrappedListeners = [SBKeyboardListenerWeakWrapper]()
    
    var listeners: [SBKeyboardEventsListener] {
        
        removeDeallocatedListeners()
        
        var unwrappedListeners = [SBKeyboardEventsListener]()
        for wrapper in self.wrappedListeners {
            if let listener = wrapper.listener {
                unwrappedListeners.append(listener)
            }
        }
        return unwrappedListeners
    }
    
    
    // MARK - Init

    override init() {
        
        super.init()
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self,
                                       selector: #selector(SBKeyboardEvents.keyboardWillShow),
                                       name: NSNotification.Name.UIKeyboardWillShow,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(SBKeyboardEvents.keyboardDidShow),
                                       name: NSNotification.Name.UIKeyboardDidShow,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(SBKeyboardEvents.keyboardWillHide),
                                       name: NSNotification.Name.UIKeyboardWillHide,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(SBKeyboardEvents.keyboardDidHide),
                                       name: NSNotification.Name.UIKeyboardDidHide,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(SBKeyboardEvents.keyboardWillChangeFrame),
                                       name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(SBKeyboardEvents.keyboardDidChangeFrame),
                                       name: NSNotification.Name.UIKeyboardDidChangeFrame,
                                       object: nil)

        
    }
    
    // MARK - Manage Listeners
    
    func addListener(_ listener: SBKeyboardEventsListener){
        
        let wrapper = SBKeyboardListenerWeakWrapper(listener: listener)
        self.wrappedListeners.append(wrapper)
    }
    
    func removeListener(_ listener: SBKeyboardEventsListener){
        
        self.wrappedListeners.filter{ $0.listener !== listener }
    }
    
    func removeAllListeners(){
       self.wrappedListeners.removeAll()
    }
    
    func removeDeallocatedListeners() {
        self.wrappedListeners = self.wrappedListeners.filter{ $0.listener != nil }
    }
    
    // MARK - Keyboard Notifications
    
    func keyboardWillShow(_ notification: Notification){
        
        for listener in self.listeners{
            listener.keyboardWillAppear()
        }
    }
    
    func keyboardDidShow(_ notification: Notification){
        
        for listener in self.listeners{
            listener.keyboardDidAppear()
        }
    }
    
    func keyboardWillHide(_ notification: Notification){
        
        for listener in self.listeners{
            listener.keyboardWillHide()
        }
    }
    
    func keyboardDidHide(_ notification: Notification){
        
        for listener in self.listeners{
            listener.keyboardDidHide()
        }
    }
    
    func keyboardWillChangeFrame(_ notification: Notification){
        
        let endFrame = notification.endFrame()
        let animationCurve = notification.animationCurve()
        let duration = notification.duration()

        for listener in self.listeners{
            listener.keyboardWillChangeFrame(endFrame)
        }
        
        if self.listeners.count > 0{
            
            let options = UIViewAnimationOptions(rawValue: UInt(animationCurve << 16))
            
            let height: CGFloat = UIScreen.main.bounds.size.height - endFrame.origin.y
            
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: { 
                
                for listener in self.listeners{
                    listener.animateForKeyboardFrame(endFrame)
                    listener.animateForKeyboardHeight(height)
                }
                
            }, completion: nil)
        }
    
    }
    
    func keyboardDidChangeFrame(_ notification: Notification){
        
        for listener in self.listeners{
            listener.keyboardDidChangeFrame(notification.endFrame())
        }
    }
    
}

class SBKeyboardListenerWeakWrapper {
    weak var listener: SBKeyboardEventsListener?
    
    init(listener: SBKeyboardEventsListener){
        self.listener = listener;
    }
}


