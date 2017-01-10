
import UIKit

@IBDesignable class BorderButton : UIButton{
	
	@IBInspectable var cornerRadius:CGFloat=0.0
	@IBInspectable var borderColor:UIColor=UIColor.clear
	@IBInspectable var borderWidth:CGFloat=0.0
	
	override func draw(_ rect: CGRect) {
		self.layer.cornerRadius = cornerRadius;
		self.layer.borderColor = borderColor.cgColor
		self.layer.borderWidth = borderWidth;
		super.draw(rect)
	}
}
