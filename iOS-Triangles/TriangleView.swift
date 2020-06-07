//
//  TriangleView.swift
//  iOS-Triangles
//
//  Created by Glenn Cole on 6/6/20.
//  Copyright © 2020 Glenn Cole. All rights reserved.
//

import UIKit

class TriangleView: UIView {
    
    let w = 775
    let h = 675
    
    var doReveal = false
    
    func toggleReveal() {
        doReveal = !( doReveal )
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let ctx = UIGraphicsGetCurrentContext() else {
            print( "Could not get current graphics context" )
            return
        }
        
        ctx.setFillColor(red: 1.0, green: 1.0, blue: 0.95, alpha: 1.0 )
        ctx.fill( CGRect(x: 0, y: 0, width: w, height: h))
        
        drawAxes(context: ctx)
        drawTriangles(context: ctx)
    }
    
    func drawAxes( context ctx: CGContext ) {
        
        ctx.setLineWidth( 3.0 )
        ctx.beginPath()
        
        ctx.move(to: CGPoint(x: 0, y: 0))
        ctx.addLine(to: CGPoint(x: w, y: 0))
        
        ctx.move(to: CGPoint(x: 0, y: 0))
        ctx.addLine(to: CGPoint(x: 0, y: h))
        
        ctx.drawPath(using: .stroke)
        
        drawGridLines( context: ctx )
    }
    
    func drawGridLines( context ctx: CGContext ) {
        
        ctx.setLineWidth( 1.0 )
        let dashes: [CGFloat] = [2.0, 2.0]
        ctx.setLineDash(phase: 0.0, lengths: dashes)
        
        ctx.beginPath()
        let dashDistance = 50
        for i in 1 ... Int(max(w,h) / dashDistance ) {
            let iDistance = i * dashDistance
            
            if iDistance <= w {
                ctx.move(to: CGPoint(x: iDistance, y: 0))
                ctx.addLine(to: CGPoint(x: iDistance, y: h))
            }
            
            if iDistance <= h {
                ctx.move(to: CGPoint(x: 0, y: iDistance))
                ctx.addLine(to: CGPoint(x: w, y: iDistance))
            }
        }
        
        ctx.drawPath(using: .stroke)
        ctx.setLineDash(phase: 0.0, lengths: [])
    }
    
    enum WhichTriangle {
        case original
        case rearranged
    }
    
    func drawTriangles( context ctx: CGContext ) {
        
        ctx.scaleBy( x: 50.0, y: 50.0 )
        ctx.translateBy( x: 1.0, y: 1.0 )
        
        ctx.translateBy( x: 0.0, y: 6.0 )
        drawBigTriangle(context: ctx, which: .original )
        
        ctx.translateBy(x: 0.0, y: -6.0 )
        drawBigTriangle(context: ctx, which: .rearranged )
    }

    
    typealias XY = ( x: Int, y: Int )
    typealias RGB = ( red: CGFloat, green: CGFloat, blue: CGFloat )
    
    func drawBigTriangle( context ctx: CGContext, which triangle: WhichTriangle ) {
        
        let t1RGB = RGB(red: 1.0, green: 0.0, blue: 0.0 )
        let t2RGB = RGB(red: 0.0, green: 0.6, blue: 0.2 )
        
        let b1RGB = RGB(red: 1.0, green: 0.5, blue: 0.0 )
        let b2RGB = RGB(red: 0.5, green: 1.0, blue: 0.0 )
        
        let t1Points: [XY] = [ (x:0, y:0), (x:8, y:0), (x:8, y:3) ]
        let t2Points: [XY] = [ (x:0, y:0), (x:5, y:0), (x:5, y:2) ]
        
        let b1Points: [XY] = [ (x:0,y:0), (x:2,y:0), (x:2,y:1), (x:5,y:1), (x:5,y:2), (x:0,y:2) ]
        let b2Points: [XY] = [ (x:0,y:0), (x:5,y:0), (x:5,y:2), (x:2,y:2), (x:2,y:1), (x:0,y:1) ]
        
        let t1Shift: XY
        let t2Shift: XY
        let b1Shift: XY
        let b2Shift: XY
        
        switch triangle {
        case .original:
            t1Shift = (x:0, y:0)
            t2Shift = (x:8, y:3)
            b1Shift = (x:8, y:1)
            b2Shift = (x:8, y:0)
        case .rearranged:
            t1Shift = (x:5, y:2)
            t2Shift = (x:0, y:0)
            b1Shift = (x:5, y:0)
            b2Shift = (x:8, y:0)
        }
        
        ctx.setLineWidth( 0.02 )
        drawFigure(context: ctx, points: t1Points, rgb: t1RGB, shift: t1Shift)
        drawFigure(context: ctx, points: t2Points, rgb: t2RGB, shift: t2Shift)
        drawFigure(context: ctx, points: b1Points, rgb: b1RGB, shift: b1Shift)
        drawFigure(context: ctx, points: b2Points, rgb: b2RGB, shift: b2Shift)
        
        if doReveal {
            ctx.setLineWidth( 0.04 )
            drawHypotenuse( context: ctx )
        }
    }
    
    func drawHypotenuse( context ctx: CGContext ) {
        
        ctx.saveGState()
        
        ctx.beginPath()
        ctx.move(to: CGPoint(x: 0, y: 0))
        ctx.addLine(to: CGPoint(x: 13, y: 5))
        
        ctx.drawPath(using: .stroke)
        
        ctx.restoreGState()
    }
    
    func drawFigure( context ctx: CGContext, points: [XY], rgb: RGB, shift: XY ) {
        
        ctx.saveGState()
        ctx.translateBy(x: CGFloat(shift.x), y: CGFloat(shift.y) )
        
        ctx.beginPath()
        ctx.move(to: CGPoint( x: points[0].x, y: points[0].y))
        for p in points[1...] {
            ctx.addLine(to: CGPoint(x: p.x, y: p.y))
        }
        ctx.closePath()

        ctx.setStrokeColor( red: rgb.red, green: rgb.green, blue: rgb.blue, alpha: 1.0 )
        ctx.setFillColor  ( red: rgb.red, green: rgb.green, blue: rgb.blue, alpha: 0.4 )
        
        ctx.drawPath(using: .fillStroke)
        
        ctx.restoreGState()
    }
}
