//
//  UIView+SequentialAnimation.m
//

#import "UIView+SequentialAnimation.h"

@implementation UIView (SequentialAnimation)

+ (void)animateViews:(NSArray *)views
        withDuration:(CGFloat)duration
          animations:(void (^)(UIView *, NSInteger))animationBlock
{
    [self animateViews:views
          withDuration:duration
            animations:animationBlock
            completion:nil];
}

+ (void)animateViews:(NSArray*)views
                    withDuration:(CGFloat)duration
                      animations:(void(^)(UIView*, NSInteger))animationBlock
                      completion:(void(^)(void))completionBlock
{
    [self animateViews:views
          withDuration:duration
            animations:animationBlock
        eachCompletion:nil
            completion:completionBlock];
}

+ (void)animateViews:(NSArray*)views
        withDuration:(CGFloat)duration
          animations:(void(^)(UIView*, NSInteger))animationBlock
      eachCompletion:(void(^)(UIView*, NSInteger))iterationCompletionBlock
          completion:(void(^)(void))completionBlock
{
    NSInteger currentIndex = 0;
    CGFloat completionTime = 0.0f; // delay time until animations are complete
    if (duration)
    {
        /* Iteratively perform the animationBlock on the subviews,
         spacing apart the start time of each animation by increments of the the specified duration */
        CGFloat currentAnimationStartDelay = 0.0f;
        for (UIView *view in views)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                         (int64_t)(currentAnimationStartDelay * NSEC_PER_SEC)),
                           dispatch_get_main_queue(), ^{
                               [UIView animateWithDuration:duration
                                                animations:^{
                                                    if (animationBlock)
                                                    {
                                                        animationBlock(view, currentIndex);
                                                    }
                                                }
                                                completion:^(BOOL finished) {
                                                    if (finished && iterationCompletionBlock)
                                                    {
                                                        iterationCompletionBlock(view, currentIndex);
                                                    }
                                                }];
                           });
            currentAnimationStartDelay += duration;
            currentIndex++;
        }
        
        if (completionBlock)
        {
            // call the completion block when all animations are done
            completionTime = currentAnimationStartDelay;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                         (int64_t)(completionTime * NSEC_PER_SEC)),
                           dispatch_get_main_queue(),
                           completionBlock);
        }
    }
    else // perform the view manipulation synchronously to avoid overhead of GCD scheduling
    {
        for (UIView* view in views)
        {
            if (animationBlock) { animationBlock(view, currentIndex); }
            if (iterationCompletionBlock) { iterationCompletionBlock(view, currentIndex); }
            currentIndex++;
        }
        if (completionBlock) completionBlock();
    }
}

@end
