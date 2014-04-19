//
//  UIView+SequentialAnimation.h
//

#import <UIKit/UIKit.h>

@interface UIView (SequentialAnimation)

+ (void)animateViews:(NSArray*)views
        withDuration:(double)duration
          animations:(void(^)(UIView*, NSInteger))animationBlock;

+ (void)animateViews:(NSArray*)views
        withDuration:(double)duration
          animations:(void(^)(UIView*, NSInteger))animationBlock
          completion:(void(^)(void))completionBlock;

+ (void)animateViews:(NSArray*)views
        withDuration:(double)duration
          animations:(void(^)(UIView*, NSInteger))animationBlock
      eachCompletion:(void(^)(UIView*, NSInteger))iterationCompletionBlock
          completion:(void(^)(void))completionBlock;

+ (void)animateViews:(NSArray*)views     // Views to animate. Order is preserved.
        withDuration:(double)duration   // Duration for each animation
               delay:(double)delay       // Delay between each animation
          animations:(void(^)(UIView*, NSInteger))animationBlock   // Animation block for each view
      eachCompletion:(void(^)(UIView*, NSInteger))iterationCompletionBlock  // Completion block for each animation
          completion:(void(^)(void))completionBlock  // Completion block run after all animations have finished
             options:(UIViewAnimationOptions)animationOptions; // Options for curves, reversing, repeating, etc.

@end
