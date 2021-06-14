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
    var routeTypeName = NSMutableString()
    
    var stationID = NSMutableString()
    var locationX = NSMutableString()
    var locationY = NSMutableString()
    
    var currentCategory : Int = 0
    
    // category == 0
    var plateNo1 = NSMutableString()
    var plateNo2 = NSMutableString()
    var predictTime1 = NSMutableString()
    var predictTime2 = NSMutableString()
    var remainSeatCnt1 = NSMutableString()
    var remainSeatCnt2 = NSMutableString()
    var routeIdArriv = NSMutableString()
    
    var routeIDArriv = NSMutableString()
    var locationNo1 = NSMutableString()
    var locationNo2 = NSMutableString()
    var stationIdArrive = NSMutableString()

    // category == 1
    var routeID = NSMutableString()
    var stationSeq = NSMutableString()
    var plateNo = NSMutableString()
    var plateType = NSMutableString()
    var remainSeatCnt = NSMutableString()
    var stationId = NSMutableString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.image = UIImage(named: "res/back.png")
        if currentCategory == 0 {
            beginXmlFileParsing(category: 0, parameter: "stationID", value: stationID)
        } else if currentCategory == 1 {
            beginXmlFileParsing(category: 1, parameter: "routeID", value: routeID)
        }
        print("Loading Finish!")
    }
    
    func beginXmlFileParsing(category: Int, parameter: String, value: NSMutableString) {
        var path = ""
        
        if category == 0 {
            path = "http://openapi.gbis.go.kr/ws/rest/busarrivalservice/station?serviceKey=1234567890&stationId=200000078"
        } else if category == 1 {
            path = "http://openapi.gbis.go.kr/ws/rest/buslocationservice?serviceKey=1234567890&stationId=200000078"
        }
        
        let quaryURL = path + parameter + "=" + String(value)
        
        posts = []
        parser = XMLParser(contentsOf: (URL(string: quaryURL))!)!
        parser.delegate = self
        
        let success:Bool = parser.parse()
        if success {
            print("Loading Parsing Success!")
        } else {
            print("Loading Parsing Failed!")
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "busArrivalList") {
            elements = NSMutableDictionary()
            elements = [:]
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
            routeIDArriv = NSMutableString()
            routeIDArriv = ""
            locationNo1 = NSMutableString()
            locationNo1 = ""
            locationNo2 = NSMutableString()
            locationNo2 = ""
            stationIdArrive = NSMutableString()
            stationIdArrive = ""
        } else if (elementName as NSString).isEqual(to: "busLocationList") {
            elements = NSMutableDictionary()
            elements = [:]
            stationSeq = NSMutableString()
            stationSeq = ""
            plateNo = NSMutableString()
            plateNo = ""
            plateType = NSMutableString()
            plateType = ""
            remainSeatCnt = NSMutableString()
            remainSeatCnt = ""
            stationId = NSMutableString()
            stationId = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentCategory == 0 {
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
            } else if element.isEqual(to: "routeId") {
                routeIdArriv.append(string)
            } else if element.isEqual(to: "locationNo1") {
                locationNo1.append(string)
            } else if element.isEqual(to: "locationNo2") {
                locationNo2.append(string)
            } else if element.isEqual(to: "stationId") {
                stationIdArrive.append(string)
            }
        } else if currentCategory == 1 {
            if element.isEqual(to: "stationSeq"){
                stationSeq.append(string)
            }
            else if element.isEqual(to: "plateNo"){
                plateNo.append(string)
            }
            else if element.isEqual(to: "plateType"){
                plateType.append(string)
            }
            else if element.isEqual(to: "remainSeatCnt"){
                remainSeatCnt.append(string)
            }
            else if element.isEqual(to: "stationID"){
                stationId.append(string)
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI namspaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "busArrivalList") {
            if !plateNo1.isEqual(nil) {
                elements.setObject(plateNo1, forKey: "plateNo1" as NSCopying)
                print(plateNo1)
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
                elements.setObject(routeIdArriv, forKey: "routeId" as NSCopying)
            }
            if !locationNo1.isEqual(nil) {
                elements.setObject(locationNo1, forKey: "locationNo1" as NSCopying)
            }
            if !locationNo2.isEqual(nil) {
                elements.setObject(locationNo2, forKey: "locationNo2" as NSCopying)
            }
            if !stationIdArrive.isEqual(nil) {
                elements.setObject(stationIdArrive, forKey: "stationId" as NSCopying)
            }
            
            posts.add(elements)
        } else if (elementName as NSString).isEqual(to: "busLocationList") {
            if !stationSeq.isEqual(nil) {
                elements.setObject(stationSeq, forKey: "stationSeq" as NSCopying)
            }
            if !plateNo.isEqual(nil) {
                elements.setObject(plateNo, forKey: "plateNo" as NSCopying)
            }
            if !plateType.isEqual(nil) {
                elements.setObject(plateType, forKey: "plateType" as NSCopying)
            }
            if !remainSeatCnt.isEqual(nil) {
                elements.setObject(remainSeatCnt, forKey: "remainSeatCnt" as NSCopying)
            }
            if !stationId.isEqual(nil) {
                elements.setObject(stationId, forKey: "stationId" as NSCopying)
            }
            posts.add(elements)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let secondViewController = segue.destination as? BusInfoViewController else {
            return
        }
        
        secondViewController.currentCategory = self.currentCategory
//        secondViewController.stationIDPre = self.stationID
        
        if currentCategory == 0 {
            secondViewController.locationX = self.locationX
            secondViewController.locationY = self.locationY
            
            secondViewController.postsArriv = self.posts
            secondViewController.elements = self.elements
            secondViewController.element = self.element
            
            secondViewController.stationIDPre = self.stationID
            secondViewController.routeIdArrive = self.routeIdArriv
        } else if currentCategory == 1 {
            secondViewController.routeID = self.routeID
            secondViewController.stationSeqPre = self.stationSeq
            secondViewController.plateNo = self.plateNo
            secondViewController.plateType = self.plateType
            secondViewController.remainSeatCnt = self.remainSeatCnt
            secondViewController.stationIDPre = self.stationId
            secondViewController.postsBusLocation = self.posts
        }
    }
}
