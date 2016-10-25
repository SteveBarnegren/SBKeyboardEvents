
public protocol SBKeyboardEventsListener : class{
    
    func keyboardWillAppear()
    func keyboardDidAppear()
    func keyboardWillHide()
    func keyboardDidHide()
    func keyboardWillChangeFrame(frame: CGRect)
    func keyboardDidChangeFrame(frame: CGRect)
    func animateForKeyboardFrame(frame: CGRect)
    func animateForKeyboardHeight(height: CGFloat)
}

public extension SBKeyboardEventsListener{
   
    func keyboardWillAppear() {}
    func keyboardDidAppear() {}
    func keyboardWillHide() {}
    func keyboardDidHide() {}
    func keyboardWillChangeFrame(frame: CGRect) {}
    func keyboardDidChangeFrame(frame: CGRect) {}
    func animateForKeyboardFrame(frame: CGRect) {}
    func animateForKeyboardHeight(height: CGFloat) {}
}

extension NSNotification{
    
    func endFrame() -> CGRect {
        let dictionary = userInfo! as Dictionary;
        let endFrame = (dictionary[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        return endFrame
    }
    
    func duration() -> Double {
        let dictionary = userInfo! as Dictionary;
        let duration = dictionary[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        return duration
    }
    
    func animationCurve() -> UInt {
        let dictionary = userInfo! as Dictionary;
        let animationCurve = dictionary[UIKeyboardAnimationCurveUserInfoKey]!.unsignedIntegerValue
        return animationCurve
    }

}

public class SBKeyboardEvents: NSObject {
    
    // MARK -  ***** Public API *****
    public class func addListener(listener: SBKeyboardEventsListener){
        self.sharedInstance.addListener(listener)
    }
    
    public class func removeListener(listener: SBKeyboardEventsListener){
        self.sharedInstance.removeListener(listener)
    }
    
    public class func removeAllListeners(){
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
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        notificationCenter.addObserver(self,
                                       selector: #selector(SBKeyboardEvents.keyboardWillShow),
                                       name: UIKeyboardWillShowNotification,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(SBKeyboardEvents.keyboardDidShow),
                                       name: UIKeyboardDidShowNotification,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(SBKeyboardEvents.keyboardWillHide),
                                       name: UIKeyboardWillHideNotification,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(SBKeyboardEvents.keyboardDidHide),
                                       name: UIKeyboardDidHideNotification,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(SBKeyboardEvents.keyboardWillChangeFrame),
                                       name: UIKeyboardWillChangeFrameNotification,
                                       object: nil)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(SBKeyboardEvents.keyboardDidChangeFrame),
                                       name: UIKeyboardDidChangeFrameNotification,
                                       object: nil)

        
    }
    
    // MARK - Manage Listeners
    
    func addListener(listener: SBKeyboardEventsListener){
        
        let wrapper = SBKeyboardListenerWeakWrapper(listener: listener)
        self.wrappedListeners.append(wrapper)
    }
    
    func removeListener(listener: SBKeyboardEventsListener){
        
        self.wrappedListeners.filter{ $0.listener !== listener }
    }
    
    func removeAllListeners(){
       self.wrappedListeners.removeAll()
    }
    
    func removeDeallocatedListeners() {
        self.wrappedListeners = self.wrappedListeners.filter{ $0.listener != nil }
    }
    
    // MARK - Keyboard Notifications
    
    func keyboardWillShow(notification: NSNotification){
        
        for listener in self.listeners{
            listener.keyboardWillAppear()
        }
    }
    
    func keyboardDidShow(notification: NSNotification){
        
        for listener in self.listeners{
            listener.keyboardDidAppear()
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        
        for listener in self.listeners{
            listener.keyboardWillHide()
        }
    }
    
    func keyboardDidHide(notification: NSNotification){
        
        for listener in self.listeners{
            listener.keyboardDidHide()
        }
    }
    
    func keyboardWillChangeFrame(notification: NSNotification){
        
        let endFrame = notification.endFrame()
        let animationCurve = notification.animationCurve()
        let duration = notification.duration()

        for listener in self.listeners{
            listener.keyboardWillChangeFrame(endFrame)
        }
        
        if self.listeners.count > 0{
            
            let options = UIViewAnimationOptions(rawValue: UInt(animationCurve << 16))
            
            let height: CGFloat = UIScreen.mainScreen().bounds.size.height - endFrame.origin.y
            
            UIView.animateWithDuration(duration, delay: 0, options: options, animations: { 
                
                for listener in self.listeners{
                    listener.animateForKeyboardFrame(endFrame)
                    listener.animateForKeyboardHeight(height)
                }
                
            }, completion: nil)
        }
    
    }
    
    func keyboardDidChangeFrame(notification: NSNotification){
        
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


