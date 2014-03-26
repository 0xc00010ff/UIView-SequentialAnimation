//
//  UIView+SequentialAnimation.m
//
//  No copyright. Destroy and defame as necessary.
//

#import "UIView+SequentialAnimation.h"

@implementation UIView (SequentialAnimation)

+ (void)sequentiallyAnimateViews:(NSArray *)views
                    withDuration:(CGFloat)duration
                      animations:(void (^)(UIView *))animationBlock
{
    CGFloat startTime = 0.0f;
    
    for (UIView *view in views)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(startTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:duration animations:^{
                animationBlock(view);
            }];
        });
        startTime += duration;
    }
}

@end
