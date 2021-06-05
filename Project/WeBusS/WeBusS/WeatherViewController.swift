//
//  WeatherViewController.swift
//  WeBusS
//
//  Created by Hyungkyun You on 2021/05/25.
//

import UIKit

class WeatherViewController: UIViewController,XMLParserDelegate {

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var category = NSMutableString()
    var locationX = NSMutableString()
    var locationY = NSMutableString()
    
    let converter = LamberProjection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = UIImage(named: "res/back.png")
        weatherIcon.image = UIImage(named: "res/sun.png")
        
        let (x,y) = converter.convertGrid(lon: locationX.doubleValue, lat: locationY.doubleValue)
        beginXmlFileParsing(numOfRows: String(104), baseData: String(20200611), baseTime: String(0200), nx: String(x), ny: String(y))


    }
    
    func beginXmlFileParsing(numOfRows: String, baseData: String, baseTime: String, nx: String, ny: String) {
        let path = "http://apis.data.go.kr/1360000/VilageFcstInfoService/getVilageFcst?serviceKey=cOXFXk2qE%2FhuIiYcsMQ4gv032heBUTwuP%2FDQwW0TskxrWGtrdVC6bJPNmJ2CbVcFq6P1eirV9X5d5fql75eeRg%3D%3D&pageNo=1&"
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
        
        // listTableView!.reloadData()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        element = elementName as NSString
        if ( elementName as NSString ).isEqual(to: "item") {
            elements = NSMutableDictionary()
            elements = [:]
            category = NSMutableString()
            category = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "category") {
            category.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI namspaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "item") {
            if !category.isEqual(nil) {
                elements.setObject(category, forKey: "category" as NSCopying)
            }
            posts.add(elements)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let secondViewController = segue.destination as? BusInfoViewController else {
            return
        }
    }
}
