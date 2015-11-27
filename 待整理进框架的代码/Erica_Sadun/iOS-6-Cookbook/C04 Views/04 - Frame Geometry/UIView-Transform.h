/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (Transform)
@property (readonly) CGFloat rotation;
@property (readonly) CGFloat xscale;
@property (readonly) CGFloat yscale;
@property (readonly) CGFloat tx;
@property (readonly) CGFloat ty;

@property (readonly) CGRect originalFrame;
@property (readonly) CGPoint transformedTopLeft;
@property (readonly) CGPoint transformedTopRight;
@property (readonly) CGPoint transformedBottomLeft;
@property (readonly) CGPoint transformedBottomRight;

- (CGPoint) pointInTransformedView: (CGPoint) pointInParentCoordinates;
- (BOOL) intersectsView: (UIView *) aView;
@end
