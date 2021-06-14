//
//  ParticleView.swift
//  WeBusS
//
//  Created by Hyungkyun You on 2021/06/10.
//

import UIKit

class ParticleView: UIView {
    private var emitter: CAEmitterLayer!
    
    override class var layerClass: AnyClass {
        return CAEmitterLayer.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init(frame: ")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        emitter = self.layer as! CAEmitterLayer
        emitter.emitterPosition = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        emitter.emitterSize = self.bounds.size
        emitter.renderMode = CAEmitterLayerRenderMode.additive
        emitter.emitterShape = CAEmitterLayerEmitterShape.rectangle
    }
    
    func didMoveToSuperview(weather: String) {
        super.didMoveToSuperview()
        if self.superview == nil {
            return
        }
        let texture_snow: UIImage? = UIImage(named: "p_snow")
        assert(texture_snow != nil, "snow image not found")
        
        let texture_rain: UIImage? = UIImage(named: "p_rain")
        assert(texture_rain != nil, "rain image not found")
        
        let texture_sun: UIImage? = UIImage(named: "p_sun")
        assert(texture_sun != nil, "sun image not found")
        
        let texture_cloud: UIImage? = UIImage(named: "p_cloud")
        assert(texture_cloud != nil, "cloud image not found")
        
        let emitterCell = CAEmitterCell()
        
        emitterCell.name = "cell"
        switch weather {
        case "snow":
            emitterCell.contents = texture_snow?.cgImage
        case "rain" :
            emitterCell.contents = texture_rain?.cgImage
        case "sun" :
            emitterCell.contents = texture_sun?.cgImage
        case "cloud" :
            emitterCell.contents = texture_cloud?.cgImage
        default:
            emitterCell.contents = texture_sun?.cgImage
        }
        
        emitterCell.birthRate = 100
        emitterCell.lifetime = 2.0
        emitterCell.velocity = 50
        emitterCell.velocityRange = 10
        emitterCell.scaleRange = 0.0
        emitterCell.scaleSpeed = 0.0
        emitterCell.emissionRange = 0.0
        emitter.emitterCells = [emitterCell]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.removeFromSuperview()
        })
    }
    
}
