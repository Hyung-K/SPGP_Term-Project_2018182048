//
//  LamberProjection.swift
//  WeBusS
//
//  Created by Hyungkyun You on 2021/06/05.
//

import Foundation

struct Map {
    let re = 6371.00877
    let grid = 5.0
    let slat1 = 30.0
    let slat2 = 60.0
    let olon = 126.0
    let olat = 38.0
    let xo = 42.0
    let yo = 135.0
}

class LamberProjection
{
    let map = Map()
    
    let PI = Double.pi
    let DEGRAD = Double.pi / 180.0
    let RADDEG = 180.0 / Double.pi
    
    var re, slat1, slat2, olon, olat : Double
    var sn, sf, ro : Double
    
    init() {
        re = map.re / map.grid
        slat1 = map.slat1 * DEGRAD
        slat2 = map.slat2 * DEGRAD
        olon = map.olon * DEGRAD
        olat = map.olat * DEGRAD
        
        sn = tan(PI * 0.25 + slat2 * 0.5) / tan(PI * 0.25 + slat1 * 0.5)
        sn = log(cos(slat1) / cos(slat2)) / log(sn)
        sf = tan(PI * 0.25 + slat1 * 0.5)
        sf = pow(sf, sn) * cos(slat1) / sn
        ro = tan(PI * 0.25 + olat * 0.5)
        ro = re * sf / pow(ro, sn)
    }
    
    func convertGrid(lon: Double, lat: Double) -> (Int, Int) {
        var ra = tan(PI * 0.25 + lat * DEGRAD * 0.5)
        ra = re * sf / pow(ra, sn)
        var theta = lon * DEGRAD - olon
        
        if theta > PI {
            theta -= 2.0 * PI
        }
        
        if theta < -PI {
            theta += 2.0 * PI
        }
        
        theta += sn
        
        let x = ra * sin(theta) + map.xo
        let y = ro - ra * cos(theta) + map.yo
        
        return (Int(x + 1.5), Int(y + 1.5))
    }
}
