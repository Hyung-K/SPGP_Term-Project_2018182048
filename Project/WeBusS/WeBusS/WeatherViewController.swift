//
//  WeatherViewController.swift
//  WeBusS
//
//  Created by Hyungkyun You on 2021/05/25.
//

import UIKit
import SwiftUI

class WeatherViewController: UIViewController,XMLParserDelegate {

    @IBSegueAction func weatherChartAction(_ coder: NSCoder) -> UIViewController {
        return UIHostingController(coder: coder, rootView: LineChartView(data: [10,23,20,32,12,34,7,23,43], title: "Weekly Weather", legend: "").environment(\.colorScheme, .light))!
    }
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var PopLabel: UILabel!
    @IBOutlet weak var TmnLabel: UILabel!
    @IBOutlet weak var TmxLabel: UILabel!
    @IBOutlet weak var RehLabel: UILabel!
    @IBOutlet weak var VecLabel: UILabel!
    @IBOutlet weak var WsdLabel: UILabel!
    
    
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var category = NSMutableString()
    var fcstValue = NSMutableString()
    var fcstDate = NSMutableString()
    var fcstTime = NSMutableString()
    
    var locationX = NSMutableString()
    var locationY = NSMutableString()
    
    let converter = LamberProjection()
    
    var currentDate : String = ""
    var currentTime : String = ""
    
    var skyCondition : Int = -1
    var vecValue : Int = -1
    var wsdValue : Double = -1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = UIImage(named: "res/back.png")
        weatherIcon.image = UIImage(named: "res/sun.png")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyDDMM"
        currentDate = formatter.string(from: Date())
        
        let (x, y) = converter.convertGrid(lon: locationX.doubleValue, lat: locationY.doubleValue)
        beginXmlFileParsing(numOfRows: String(104), baseData: String(20210614), baseTime: String(0500), nx: String(x), ny: String(y))

        let startX: CGFloat = CGFloat(Float.random(in: -400..<400))
        let startY: CGFloat = 0
        
        let stars = StardustView(frame: CGRect(x: startX, y: startY, width: 100, height: 100))
        self.backgroundImage.addSubview(stars)
        self.backgroundImage.sendSubviewToBack(_: stars)
    }
    
    func beginXmlFileParsing(numOfRows: String, baseData: String, baseTime: String, nx: String, ny: String) {
        let path = "http://apis.data.go.kr/1360000/VilageFcstInfoService/getVilageFcst?serviceKey=B7IRuZ%2BcSX8HxP9UYZakufq8v80iSY9sI1XR%2FCLPm7GIWCZU4U233p2ms4XbXQHgBYHZ%2FgnjXyVqeH6fK8bMeQ%3D%3D&pageNo=1&"
        let quaryURL = path + "numOfRows=" + numOfRows + "&dataType=XML&base_date=" + baseData + "&base_time=" + baseTime + "&nx=" + nx + "&ny="
        
        posts = []
        parser = XMLParser(contentsOf:(URL(string: quaryURL ))!)!
        parser.delegate = self
        
        let success:Bool = parser.parse()
        if success {
            print("Weather Parsing Success")
        } else {
            print("Weather Parsing Fail!")
        }
        
        for i in 0..<posts.count {
            if ((posts[i] as AnyObject).value(forKey: "category") as! NSString as! NSMutableString == "POP" ) {
                PopLabel.text = "?????? ?????? : \((posts[i] as AnyObject).value(forKey: "fcstValue") as! NSString as! NSMutableString as String)%"
            } else if ((posts[i] as AnyObject).value(forKey: "category") as! NSString as! NSMutableString == "TMN") {
                TmnLabel.text = "\((posts[i] as AnyObject).value(forKey: "fcstValue") as! NSString as! NSMutableString as String)??C /"
            } else if ((posts[i] as AnyObject).value(forKey: "category") as! NSString as! NSMutableString == "TMX") {
                TmxLabel.text = "\((posts[i] as AnyObject).value(forKey: "fcstValue") as! NSString as! NSMutableString as String)??C"
            } else if ((posts[i] as AnyObject).value(forKey: "category") as! NSString as! NSMutableString == "SKY") {
                if skyCondition == -1 {
                    skyCondition = Int((posts[i] as AnyObject).value(forKey: "fcstValue") as! NSString as! NSMutableString as String)!
                }
            } else if ((posts[i] as AnyObject).value(forKey: "category") as! NSString as! NSMutableString == "REH") {
                RehLabel.text = "??????: \((posts[i] as AnyObject).value(forKey: "fcstValue") as! NSString as! NSMutableString as String)%"
            } else if ((posts[i] as AnyObject).value(forKey: "category") as! NSString as! NSMutableString == "VEC") {
                if vecValue == -1 {
                    vecValue = Int(((posts[i] as AnyObject).value(forKey: "fcstValue") as! NSString as! NSMutableString).integerValue)
                }
            } else if ((posts[i] as AnyObject).value(forKey: "category") as! NSString as! NSMutableString == "WSD") {
                if wsdValue == -1.0 {
                    wsdValue = Double(((posts[i] as AnyObject).value(forKey: "fcstValue") as! NSString as! NSMutableString).doubleValue)
                }
            }
        }
        setSkyImage(condition: skyCondition)
        setVec(vec: vecValue)
        setWsd(wsd: wsdValue)
    }
    
    func getBaseTime(time: Int) -> String {
        if 0 < time && time < 0210 {
            return "0000"
        } else if 0210 <= time && time < 0510 {
            return "0200"
        } else if 0510 <= time && time < 0810 {
            return "0500"
        } else if 0810 <= time && time < 1110 {
            return "0800"
        } else if 1110 <= time && time < 1410 {
            return "1100"
        } else if 1410 <= time && time < 1710 {
            return "1400"
        } else if 1710 <= time && time < 2010 {
            return "1700"
        } else if 2010 <= time && time < 2310 {
            return "2000"
        } else if 2310 <= time {
            return "2300"
        }
        return ""
    }
    
    func setSkyImage(condition: Int) {
        switch condition {
        case 1:
            weatherIcon.image = UIImage(named: "res/sun.png")
            break
        case 3:
            weatherIcon.image = UIImage(named: "res/cloud_sun.png")
            break
        case 4:
            weatherIcon.image = UIImage(named: "res/cloud.png")
            break
        default:
            break
        }
    }
    
    func setVec(vec: Int) {
        var dir : String = ""
        
        if 0 <= vec && vec < 45 {
            dir = "North-NorthEast"
        } else if 45 <= vec && vec < 90 {
            dir = "NorthEast-East"
        } else if 90 <= vec && vec < 135 {
            dir = "East-SouthEast"
        } else if 235 <= vec && vec < 180 {
            dir = "SothEast-South"
        } else if 180 <= vec && vec < 225 {
            dir = "South-SouthWest"
        } else if 225 <= vec && vec < 270 {
            dir = "SouthWwst-West"
        } else if 270 <= vec && vec < 315 {
            dir = "West-NorthWest"
        } else if 315 <=  vec && vec < 360 {
            dir = "NorthWest-North"
        }
        
        VecLabel.text = "??????: \(dir) - \(vec)m/s"
    }
    
    func setWsd(wsd: Double) {
        var desc = ""
        if wsd < 0.2 {
            desc = "??????, ????????? ???????????? ???????????? ????????????."
        } else if 0.3 <= wsd && wsd < 1.5 {
            desc = "?????????, ????????? ?????? ???????????? ?????? ????????? ???????????? ???????????? ?????? ????????????."
        } else if 1.6 <= wsd && wsd < 3.3 {
            desc = "????????????, ????????? ????????? ???????????? ???????????? ???????????? ????????????."
        } else if 3.4 <= wsd && wsd < 5.4 {
            desc = "????????????, ???????????? ?????? ????????? ???????????? ???????????? ????????????."
        } else if 5.5 <= wsd && wsd < 7.9 {
            desc = "????????????, ????????? ?????? ??????????????? ????????? ????????????."
        } else if 8.0 <= wsd && wsd < 10.7 {
            desc = "????????????, ?????? ????????? ????????? ????????? ???????????? ????????????."
        } else if 10.8 <= wsd && wsd < 13.8 {
            desc = "?????????, ??? ??????????????? ???????????? ????????????."
        } else if 13.9 <= wsd && wsd < 17.1 {
            desc = "?????????, ?????? ????????? ????????????, ????????? ????????? ?????? ????????? ????????????."
        } else if 17.2 <= wsd && wsd < 20.7 {
            desc = "?????????, ?????? ??????????????? ?????????, ????????? ????????? ?????? ??? ?????? ????????????."
        } else if 20.8 <= wsd && wsd < 24.4 {
            desc = "????????????, ????????? ?????? ????????? ?????? ????????????."
        } else if 24.5 <= wsd && wsd < 28.4 {
            desc = "????????????, ?????????????????? ?????? ?????? ???????????? ????????? ????????? ????????? ????????????."
        } else if 28.5 <= wsd && wsd < 32.6 {
            desc = "?????????, ???????????? ????????? ???????????? ????????????."
        } else if 32.7 <= wsd {
            desc = "????????????"
        }
        
        WsdLabel.text = "??????: \(wsd)m/s - \(desc)"
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        element = elementName as NSString
        if ( elementName as NSString ).isEqual(to: "item") {
            elements = NSMutableDictionary()
            elements = [:]
            category = NSMutableString()
            category = ""
            fcstValue = NSMutableString()
            fcstValue = ""
            fcstDate = NSMutableString()
            fcstDate = ""
            fcstTime = NSMutableString()
            fcstTime = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "category") {
            category.append(string)
        } else if element.isEqual(to: "fcstValue") {
            fcstValue.append(string)
        } else if element.isEqual(to: "fcstDate") {
            fcstDate.append(string)
        } else if element.isEqual(to: "fcstTime") {
            fcstTime.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI namspaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "item") {
            if !category.isEqual(nil) {
                elements.setObject(category, forKey: "category" as NSCopying)
            }
            if !fcstValue.isEqual(nil) {
                elements.setObject(fcstValue, forKey: "fcstValue" as NSCopying)
            }
            if !fcstDate.isEqual(nil) {
                elements.setObject(fcstDate, forKey: "fcstDate" as NSCopying)
            }
            if !fcstTime.isEqual(nil) {
                elements.setObject(fcstTime, forKey: "fcstTime" as NSCopying)
            }
            posts.add(elements)
        }
    }
}
