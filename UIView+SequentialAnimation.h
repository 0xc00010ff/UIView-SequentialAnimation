//
//  UIView+SequentialAnimation.h
//
//  No copyright. Destroy and defame as necessary. 
//

#import <UIKit/UIKit.h>

@interface UIView (SequentialAnimation)

+ (void)sequentiallyAnimateViews:(NSArray*)views
                    withDuration:(CGFloat)duration
                      animations:(void(^)(UIView*))animationBlock;

@end
