//
//  Extension.swift
//  Emisorasunidas
//
//  Created by Dulal Hossain on 8/14/17.
//  Copyright © 2017 DL. All rights reserved.
//

import Foundation
import Alamofire
import Kingfisher
import Bond
import ReactiveKit

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date)) años"   }
        if months(from: date)  > 0 { return "\(months(from: date)) meses"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date)) semanas"   }
        if days(from: date)    > 0 { return "\(days(from: date)) días"    }
        if hours(from: date)   > 0 { return "\(hours(from: date)) horas"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date)) minutos" }
        if seconds(from: date) > 0 { return "\(seconds(from: date)) segundos" }
        return ""
    }
    func toDateString(format:String) -> String
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = format
        
       // dateFormatter.dateStyle = .medium
        
        //Parse into NSDate
        let dateFromString : String = dateFormatter.string(from: self)
        //Return Parsed Date
        return dateFromString
    }
    
    func formattedTime() -> String
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
       // dateFormatter.dateFormat = "dd/MM/YYYY"
        dateFormatter.dateFormat = "MM/dd/YYYY"

        
        // dateFormatter.dateStyle = .MediumStyle
        
        //Parse into NSDate
        let dateFromString : String = dateFormatter.string(from:self)
        
        //Return Parsed Date
        return dateFromString
    }
    
}





extension Data{
    func base64encode() -> String {
        let data = self.base64EncodedData(options: NSData.Base64EncodingOptions(rawValue: 0))
        let string = String(data: data, encoding: .utf8)!
        return string
            .replacingOccurrences(of: "+", with: "-", options: NSString.CompareOptions(rawValue: 0), range: nil)
            .replacingOccurrences(of: "/", with: "_", options: NSString.CompareOptions(rawValue: 0), range: nil)
            .replacingOccurrences(of: "=", with: "", options: NSString.CompareOptions(rawValue: 0), range: nil)
    }
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

extension String {
    func color () -> UIColor {
        var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func base64decode() -> Data? {
        let rem = self.characters.count % 4
        
        var ending = ""
        if rem > 0 {
            let amount = 4 - rem
            ending = String(repeating: "=", count: amount)
        }
        
        let base64 = self.replacingOccurrences(of: "-", with: "+", options: NSString.CompareOptions(rawValue: 0), range: nil)
            .replacingOccurrences(of: "_", with: "/", options: NSString.CompareOptions(rawValue: 0), range: nil) + ending
        
        return Data(base64Encoded: base64, options: NSData.Base64DecodingOptions(rawValue: 0))
    }
    func getImage() -> UIImage {
        
        if let dataDecoded : Data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            if let decodedimage = UIImage(data: dataDecoded){
                return decodedimage
            }
        }
        
        return UIImage()
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    func toDateTime() -> Date
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        //Parse into NSDate
        
        let dateFromString :Date = dateFormatter.date(from: self)!
        //Return Parsed Date
        return dateFromString
    }
    
    func formattedDateTime(format:String) -> Date
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = format
        
        //Parse into NSDate
        
        let dateFromString :Date = dateFormatter.date(from: self)!
        //Return Parsed Date
        return dateFromString
    }
    
    func toProtuguesDayOfWeek(format: String) -> String
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = format
        
        //Parse into NSDate
        
        let dateFromString :Date = dateFormatter.date(from: self)!
        //Return Parsed Date
        let df = DateFormatter()
        //df.dateFormat = format
        df.dateFormat = "EEEE"
        df.locale = Locale(identifier: "pt")
        
        let strDate = df.string(from: dateFromString)
        return strDate
    }
    func toProtuguesDate(format: String) -> String
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = format
        
        //Parse into NSDate
        
        let dateFromString :Date = dateFormatter.date(from: self)!
        //Return Parsed Date
        let df = DateFormatter()
        df.dateFormat = "EEEE: MMM dd, yyyy"
       // df.dateStyle = dateStyle
        df.locale = Locale(identifier: "pt")
        
        let strDate = df.string(from: dateFromString)
        return strDate
    }
    
    func toDate(format: String) -> Date
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = format
        
        //Parse into NSDate
        
        let dateFromString :Date = dateFormatter.date(from: self)!
        //Return Parsed Date
        return dateFromString
    }
    func serverTimetoDateString() -> String
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
     //   dateFormatter.dateFormat = format
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        //Parse into NSDate
        
        let dateFromString :Date = dateFormatter.date(from: self)!
        //Return Parsed Date
        let df = DateFormatter()
        df.dateFormat = "dd MMM yyyy"
        // df.dateStyle = dateStyle
        
        let strDate = df.string(from: dateFromString)
        return strDate
    }
    func asURL()->URL? {
        if let url = URL(string: self) {
            return url
        }
        return nil
    }
    
    func asImageResource()->Resource? {
        let str = self
        if let url = URL(string: str) {
            return url
        }
        return nil
    }
    
    func asResource()->Resource? {
        return asURL()
    }
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    func trimForURL() -> String?
    {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: " ").inverted)
    }
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension UIButton{
    func call(_ phone: String) {
        let url:URL = URL(string: "tel://\(phone)")!
        if UIApplication.shared.canOpenURL(url){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
                // Fallback on earlier versions
            }
        }
    }
    func decorateButtonRound() {
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
    func decorateButtonCardAndRound() {
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
    func decorateButtonRound(_ cornerRadius: Int) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
    func decorateButtonRound(_ cornerRadius: Int, borderWidth: CGFloat) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
    func decorateButton() {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
    func makeCircle() {
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.layer.borderWidth = 0
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
    func decorateButtonRound(_ cornerRadius: Int, borderWidth: CGFloat ,borderColor: String) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = UIColor(borderColor).cgColor
        
    }

}
/*
extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
}
*/
extension UIImage{
    func getImageStr() -> String {
        let imageData:Data = self.jpegData(compressionQuality:0.9)!
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        print(strBase64)
        return strBase64
    }
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func getJpeg(_ quality: JPEGQuality) -> UIImage? {
        return UIImage(data: self.jpegData(compressionQuality: quality.rawValue)!)
    }
}

//

extension UIImageView {
    
    func makeCircle() {
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.layer.borderWidth = 0
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.gray.cgColor
        self.contentMode = .scaleAspectFill
    }
}

extension UIView {
    func makeCard() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.3
    }
    
    func setShade() {
        self.layer.cornerRadius = 0
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.2
    }
    
    func makeCardRadius_2() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.3
    }
    
    func underlined(borderColor color: UIColor) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0,
                                  y: self.frame.height - 1,
                                  width: self.frame.width,
                                  height: 1.0)
        bottomLine.backgroundColor = color.cgColor
        self.layer.addSublayer(bottomLine)
    }
    
    func removeUnderline() {
        for sub in self.layer.sublayers! {
            sub.removeFromSuperlayer()
        }
    }
    
    func removeBorders() {
        self.layer.borderWidth = 0.0
    }
    
    func makeRound(_ cornerRadius: Int, borderWidth width: CGFloat, borderColor color: UIColor) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath

        self.layer.mask = mask
    }
    
    func makeCircular(borderWidth width: CGFloat, borderColor color: UIColor) {
        self.layer.cornerRadius = 0.5 * self.bounds.height
        self.layer.borderWidth = width
        self.clipsToBounds = true
        self.layer.borderColor = color.cgColor
    }
    
    func setAccessibilityIdentifier(usingName name: String) {
        self.accessibilityIdentifier = name
    }
}

extension UITableView {
    var selectedRow: Signal<Int, NoError> {
        // swiftlint:disable line_length
        return reactive.delegate.signal(for: #selector(UITableViewDelegate.tableView(_:didSelectRowAt:))) { (subject: PublishSubject<Int, NoError>, _: UITableView, indexPath: NSIndexPath) in
            subject.next(indexPath.row)
        }
        // swiftlint:enable line_length
    }
    
    func removeEmptyCells() {
         self.tableFooterView = UIView(frame: .zero)
    }
}




extension UITextField {
    
    func makeCircle() {
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.layer.borderWidth = 1.0
        self.clipsToBounds = true
    }
    
    func makeRound() {
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setCustomTextRect() {
        self.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0)
    }
    
    func setPlaceholder(withText text: String, usingColor color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: text,
                                                        attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}

extension UITextView {
    func setCustomTextRect(withTopPadding padding: CGFloat) {
        self.textContainerInset = UIEdgeInsets(top: padding, left: 10, bottom: 0, right: 10)
    }
    
    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}

extension UILabel {
    func makeRound() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
    }
}


extension UIScrollView {
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view: UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(
                CGRect(x: 0, y: childStartPoint.y, width: 1, height: self.frame.height),
                animated: animated)
        }
    }
    
    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
    
    // Bonus: Scroll to bottom
    func scrollToBottom(animated: Bool) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if bottomOffset.y > 0 {
            setContentOffset(bottomOffset, animated: animated)
        }
    }
}

extension UIApplication {
    class func topViewController(
        controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UIViewController {
    
    func preloadView() {
        _ = view
    }
}

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

