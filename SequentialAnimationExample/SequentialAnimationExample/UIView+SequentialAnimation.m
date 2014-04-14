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
    [self animateViews:views
          withDuration:duration
                 delay:0
            animations:animationBlock
        eachCompletion:iterationCompletionBlock
            completion:completionBlock
               options:0];
}

+ (void)animateViews:(NSArray*)views
        withDuration:(CGFloat)duration
               delay:(double)delay
          animations:(void(^)(UIView*, NSInteger))animationBlock
      eachCompletion:(void(^)(UIView*, NSInteger))iterationCompletionBlock
          completion:(void(^)(void))completionBlock
             options:(UIViewAnimationOptions)animationOptions
{
    NSInteger currentIndex = 0;
    CGFloat completionTime = 0.0;; // delay time until animations are complete
    if (duration)
    {
        /* Iteratively perform the animationBlock on the subviews,
         spacing apart the start time of each animation by increments of the the specified duration */
        double currentAnimationStartDelay = 0.0;
        double discrepancy = 0.0; // Keeps track of time lost by scheduling. Helps with large amounts of views.
        for (UIView *view in views)
        {
            double time = CACurrentMediaTime();
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                         (int64_t)((currentAnimationStartDelay) * NSEC_PER_SEC)),
                           dispatch_get_main_queue(), ^{
                               [UIView animateWithDuration:duration
                                                     delay:0
                                                   options:animationOptions
                                                animations:^{
                                                    if (animationBlock)
                                                    {
                                                        animationBlock(view, currentIndex);
                                                    }
                                                } completion:^(BOOL finished) {
                                                    if (finished && iterationCompletionBlock)
                                                    {
                                                        iterationCompletionBlock(view, currentIndex);
                                                    }
                                                }];
                           });
            if (currentIndex == [views count]-1) { delay = 0; } // do not delay the callback if this is the last iteration
            currentAnimationStartDelay += duration + delay + discrepancy;
            currentIndex++;
            discrepancy += CACurrentMediaTime() - time;
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
