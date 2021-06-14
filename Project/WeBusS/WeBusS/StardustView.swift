//
//  StardustView.swift
//  WeBusS
//
//  Created by Hyungkyun You on 2021/06/10.
//

import UIKit

class StardustView: UIView {
    private var emitter: CAEmitterLayer!
    
    override class var layerClass: AnyClass {
        return CAEmitterLayer.self
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init(frame: ")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        emitter = self.layer as! CAEmitterLayer
        emitter.emitterPosition = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        emitter.emitterSize = self.bounds.size
        emitter.renderMode = CAEmitterLayerRenderMode.additive
        emitter.emitterShape = CAEmitterLayerEmitterShape.rectangle
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.superview == nil {
            return
        }
        let texture: UIImage? = UIImage(named: "res/p_snow")
        assert(texture != nil, "particle Image not found")
        
    }

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
