import Foundation

func JSONStringify(value: [String: AnyObject], prettyPrinted: Bool = false) -> String {
    var options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : nil
    if NSJSONSerialization.isValidJSONObject(value) {
        if let data = NSJSONSerialization.dataWithJSONObject(value, options: options, error: nil) {
            if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                return string
            }
        }
    }
    return ""
}

func JSONParseDictionary(jsonString: String) -> [String: AnyObject] {
    if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
        if let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil)  as? [String: AnyObject] {
            return dictionary
        }
    }
    return [String: AnyObject]()
}