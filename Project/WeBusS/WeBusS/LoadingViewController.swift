//
//  LoadingViewController.swift
//  WeBusS
//
//  Created by Hyungkyun You on 2021/06/05.
//

import UIKit

class LoadingViewController: UIViewController, XMLParserDelegate {
    @IBOutlet weak var image: UIImageView!
    
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var routeName = NSMutableString()
    var routeId = NSMutableString()
    var routeTypeName = NSMutableString()
    
    var stationID = NSMutableString()
    var locationX = NSMutableString()
    var locationY = NSMutableString()
    
    var currentCategory : Int = 0
    
    var routeID = NSMutableString()
    var staionName = NSMutableString()
    var stationSeq = NSMutableString()
    
    var plateNo1 = NSMutableString()
    var plateNo2 = NSMutableString()
    var predictTime1 = NSMutableString()
    var predictTime2 = NSMutableString()
    var remainSeatCnt1 = NSMutableString()
    var remainSeatCnt2 = NSMutableString()
    var routeIdArriv = NSMutableString()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.image = UIImage(named: "res/back.png")
        beginXmlFileParsing(category: 2, parameter: "stationId", value: stationID)
        print("Loading Finish!")
    }
    
    func beginXmlFileParsing(category: Int, parameter: String, value: NSMutableString) {
        var path = ""
        path = "http://openapi.gbis.go.kr/ws/rest/busarrivalservice/station?serviceKey=1234567890&stationId=200000078"
        let quaryURL = path + parameter + "=" + String(value)
        
        posts = []
        parser = XMLParser(contentsOf: (URL(string: quaryURL))!)!
        let success:Bool = parser.parse()
        if success {
            print("Loading Parsing Success!")
        } else {
            print("Loading Parsing Failed!")
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        if (elementName as NSString).isEqual(to: "busArrivalList") {
            plateNo1 = NSMutableString()
            plateNo1 = ""
            plateNo2 = NSMutableString()
            plateNo2 = ""
            predictTime1 = NSMutableString()
            predictTime1 = ""
            predictTime2 = NSMutableString()
            predictTime2 = ""
            remainSeatCnt1 = NSMutableString()
            remainSeatCnt1 = ""
            remainSeatCnt2 = NSMutableString()
            remainSeatCnt2 = ""
            routeIdArriv = NSMutableString()
            routeIdArriv = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "plateNo1") {
            plateNo1.append(string)
        } else if element.isEqual(to: "plateNo2") {
            plateNo2.append(string)
        } else if element.isEqual(to: "predictTime1") {
            predictTime1.append(string)
        } else if element.isEqual(to: "predictTime2") {
            predictTime2.append(string)
        } else if element.isEqual(to: "remainSeatCnt1") {
            remainSeatCnt1.append(string)
        } else if element.isEqual(to: "remainSeatCnt2") {
            remainSeatCnt2.append(string)
        } else if element.isEqual(to: "routeIdArriv") {
            routeIdArriv.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI namspaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "busArrivalList") {
            if !plateNo1.isEqual(nil) {
                elements.setObject(plateNo1, forKey: "plateNo1" as NSCopying)
            }
            if !plateNo2.isEqual(nil) {
                elements.setObject(plateNo2, forKey: "plateNo2" as NSCopying)
            }
            if !predictTime1.isEqual(nil) {
                elements.setObject(predictTime1, forKey: "predictTime1" as NSCopying)
            }
            if !predictTime2.isEqual(nil) {
                elements.setObject(predictTime2, forKey: "predictTime2" as NSCopying)
            }
            if !remainSeatCnt1.isEqual(nil) {
                elements.setObject(remainSeatCnt1, forKey: "remainSeatCnt1" as NSCopying)
            }
            if !remainSeatCnt2.isEqual(nil) {
                elements.setObject(remainSeatCnt2, forKey: "remainSeatCnt2" as NSCopying)
            }
            if !routeIdArriv.isEqual(nil) {
                elements.setObject(routeIdArriv, forKey: "routeIdArriv" as NSCopying)
            }
            
            posts.add(elements)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let secondViewController = segue.destination as? BusInfoViewController else {
            return
        }
        
        secondViewController.currentCategory = self.currentCategory
        secondViewController.stationID = self.stationID
        
        if currentCategory == 0 {
            secondViewController.locationX = self.locationX
            secondViewController.locationY = self.locationY
            secondViewController.stationID = self.stationID
        } else if currentCategory == 1 {
            secondViewController.routeID = self.routeID
        }
    }
}
