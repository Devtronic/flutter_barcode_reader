import UIKit

class ScannerOverlay: UIView
{
    let cornerRadius : CGFloat = 30
    let cornerSize : CGFloat = 60
    
    var line = UIView()
    
    var scanLineRect : CGRect
    {
        let scanRect : CGRect = self.scanRect()
        let rect : CGRect = frame
        return CGRect(x: scanRect.origin.x, y: rect.size.height / 2, width: scanRect.size.width, height: 1)
    }
    
    func scanRect() -> CGRect
    {
        let rect: CGRect = frame
        let heightMultiplier: CGFloat = 3.0 / 4.0 // 4:3 aspect ratio
        let w: CGFloat = min(rect.width,rect.height) * 0.8
        let h: CGFloat = w * heightMultiplier
        let x: CGFloat = (rect.width / 2) - (w / 2)
        let y: CGFloat = (rect.height / 2) - (h / 2)
        let ret = CGRect(x:x,y:y,width:w,height:h)
        return ret
    }
    
    func startAnimating()
    {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.fromValue = NSNumber(value: 0.0)
        flash.toValue = NSNumber(value: 1.0)
        flash.duration = 0.25
        flash.autoreverses = true
        flash.repeatCount = Float.greatestFiniteMagnitude
        line.layer.add(flash, forKey: "flashAnimation")
    }
    
    func stopAnimating()
    {
        layer.removeAnimation(forKey: "flashAnimation")
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
        setup()
    }
    
    private func setup()
    {
        backgroundColor = .clear
        
        line.backgroundColor = UIColor.red
        line.translatesAutoresizingMaskIntoConstraints = false
        addSubview(line)
    }
    
    override func draw(_ rect: CGRect)
    {
//        let context = UIGraphicsGetCurrentContext()
        
//        let overlayColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.55)
        
//        context?.setFillColor(overlayColor.cgColor)
//        context?.fill(bounds)
        
        // make a hole for the scanner
        let holeRect: CGRect = scanRect()
        let holeRectIntersection: CGRect = holeRect.intersection(rect)
//        UIColor.clear.setFill()
        
        //        let roundedHole = UIBezierPath(roundedRect: holeRectIntersection, cornerRadius: 15.0)
        //        roundedHole.fill()
        //UIRectFill(holeRectIntersection);
        
        // draw a horizontal line over the middle
        let lineRect: CGRect = scanLineRect
        line.frame = lineRect
        
        let cornerspath = UIBezierPath(roundedRect: holeRectIntersection, cornerRadius: cornerRadius)
        cornerspath.lineWidth = 3
        UIColor.white.setStroke()
        cornerspath.stroke()
        
        
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: holeRect.origin.x+cornerSize, y: holeRect.origin.y))
        path.addLine(to: CGPoint(x:holeRect.origin.x+holeRect.width-cornerSize, y: holeRect.origin.y))
        
        path.move(to: CGPoint(x: holeRect.origin.x+cornerSize, y: holeRect.origin.y+holeRect.height))
        path.addLine(to: CGPoint(x:holeRect.origin.x+holeRect.width-cornerSize, y: holeRect.origin.y+holeRect.height))
        
        path.move(to: CGPoint(x: holeRect.origin.x, y: holeRect.origin.y+cornerSize))
        path.addLine(to: CGPoint(x:holeRect.origin.x, y: holeRect.origin.y+holeRect.height-cornerSize))
        
        path.move(to: CGPoint(x: holeRect.origin.x+holeRect.width, y: holeRect.origin.y+cornerSize))
        path.addLine(to: CGPoint(x:holeRect.origin.x+holeRect.width, y: holeRect.origin.y+holeRect.height-cornerSize))
        
        path.lineWidth = 3
//        UIColor.clear.setStroke()
        path.stroke(with:.clear,alpha:1)
    }
}
