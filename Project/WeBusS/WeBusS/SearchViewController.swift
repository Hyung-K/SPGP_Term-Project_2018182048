//
//  SearchViewController.swift
//  WeBusS
//
//  Created by Hyungkyun You on 2021/05/14.
//

import UIKit

class SearchViewController: UIViewController, XMLParserDelegate {
    
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var name = NSMutableString()
    
    @IBOutlet weak var categoryChooseControl: UISegmentedControl!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableViewList: UITableView!
    
    @IBAction func categoryChooseAction(_ sender: Any) {
    }
    @IBAction func micButtonAction(_ sender: Any) {
    }
    @IBAction func searchBuutonAction(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func beginXMLFileParsing() {
        posts = []
        parser = XMLParser(contentsOf: (URL(string: "https://openapi.gg.go.kr/BusStation?ServiceKey=6b722c447ca0430db1c15b6c0a08c4dd" ))!)!
        parser.delegate = self
        
        let success:Bool = parser.parse()
        if success {
            print("XML Parsing Success!")
        } else {
            print("XML Parsing Fail!!")
        }
        
        tableViewList!.reloadData()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        
        if (elementName as NSString).isEqual(to: "row") {
            elements = NSMutableDictionary()
            elements = [:]
            name = NSMutableString()
            name = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "STATION_NM_INFO") {
            name.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "row") {
            if !name.isEqual( nil) {
                elements.setObject(name, forKey: "STATION_NM_INFO" as NSCopying)
            }
            posts.add(elements)
        }
    }
    
}
