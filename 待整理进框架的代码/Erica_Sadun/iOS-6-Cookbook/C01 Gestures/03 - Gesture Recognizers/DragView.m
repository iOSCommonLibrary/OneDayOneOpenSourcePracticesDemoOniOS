/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import "DragView.h"
#import "UIView-Transform.h"

@implementation DragView
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	// Promote the touched view
	[self.superview bringSubviewToFront:self];

	// initialize translation offsets
	tx = self.transform.tx;
	ty = self.transform.ty;
    scale = self.scaleX;
    theta = self.rotation;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	if (touch.tapCount == 3)
	{
		// Reset geometry upon triple-tap
		self.transform = CGAffineTransformIdentity;
		tx = 0.0f; ty = 0.0f; scale = 1.0f;	theta = 0.0f;
	}
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self touchesEnded:touches withEvent:event];
}

- (void) updateTransformWithOffset: (CGPoint) translation
{
	// Create a blended transform representing translation, rotation, and scaling
	self.transform = CGAffineTransformMakeTranslation(translation.x + tx, translation.y + ty);
	self.transform = CGAffineTransformRotate(self.transform, theta);
    
    // Guard against scaling too low, by limiting the scale factor
    if (scale > 0.5f)
        self.transform = CGAffineTransformScale(self.transform, scale, scale);
    else
        self.transform = CGAffineTransformScale(self.transform, 0.5f, 0.5f);
}

- (void) handlePan: (UIPanGestureRecognizer *) uigr
{
	CGPoint translation = [uigr translationInView:self.superview];
	[self updateTransformWithOffset:translation];
}

- (void) handleRotation: (UIRotationGestureRecognizer *) uigr
{
	theta = uigr.rotation;
	[self updateTransformWithOffset:CGPointZero];
}

- (void) handlePinch: (UIPinchGestureRecognizer *) uigr
{
	scale = uigr.scale;
	[self updateTransformWithOffset:CGPointZero];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return YES;
}


- (id) initWithImage:(UIImage *)image
{
	// Initialize and set as touchable
	if (!(self = [super initWithImage:image])) return self;
	
	self.userInteractionEnabled = YES;
	
	// Reset geometry to identities
	self.transform = CGAffineTransformIdentity;
	tx = 0.0f; ty = 0.0f; scale = 1.0f;	theta = 0.0f;

	// Add gesture recognizer suite
	UIRotationGestureRecognizer *rot = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
	UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
	UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
	self.gestureRecognizers = @[rot, pinch, pan];
	for (UIGestureRecognizer *recognizer in self.gestureRecognizers) recognizer.delegate = self;
	
	return self;
}
@end
