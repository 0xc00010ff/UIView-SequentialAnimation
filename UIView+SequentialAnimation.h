//
//  UIView+SequentialAnimation.h
//

#import <UIKit/UIKit.h>

@interface UIView (SequentialAnimation)

+ (void)animateViews:(NSArray*)views
        withDuration:(CGFloat)duration
          animations:(void(^)(UIView*, NSInteger))animationBlock;

+ (void)animateViews:(NSArray*)views
        withDuration:(CGFloat)duration
          animations:(void(^)(UIView*, NSInteger))animationBlock
          completion:(void(^)(void))completionBlock;

+ (void)animateViews:(NSArray*)views
        withDuration:(CGFloat)duration
          animations:(void(^)(UIView*, NSInteger))animationBlock
      eachCompletion:(void(^)(UIView*, NSInteger))iterationCompletionBlock
          completion:(void(^)(void))completionBlock;

@end
