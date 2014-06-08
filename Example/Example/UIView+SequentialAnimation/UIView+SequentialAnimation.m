//
//  UIView+SequentialAnimation.m
//

#import "UIView+SequentialAnimation.h"

@implementation UIView (SequentialAnimation)

+ (void)animateViews:(NSArray *)views
        withDuration:(double)duration
          animations:(void (^)(UIView *, NSInteger))animationBlock
{
    [self animateViews:views
          withDuration:duration
            animations:animationBlock
            completion:nil];
}

+ (void)animateViews:(NSArray*)views
        withDuration:(double)duration
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
        withDuration:(double)duration
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
        withDuration:(double)duration
               delay:(double)delay
          animations:(void(^)(UIView*, NSInteger))animationBlock
      eachCompletion:(void(^)(UIView*, NSInteger))iterationCompletionBlock
          completion:(void(^)(void))completionBlock
             options:(UIViewAnimationOptions)animationOptions
{
    NSInteger currentIndex = 0;
    if (duration)
    {
        /* Iteratively perform the animationBlock on the subviews,
         spacing apart the start time of each animation by increments of the the specified duration */
        double currentAnimationStartDelay = 0.0;
        double discrepancy = 0.0; // Keeps track of time lost by scheduling. Helps with large amounts of views.
        for (UIView *view in views)
        {
            double time = CACurrentMediaTime();
            dispatch_critical(currentAnimationStartDelay, ^{
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
            dispatch_critical(currentAnimationStartDelay, completionBlock);
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

#pragma mark - dispatch_critical -
// Utility to enforce strict animation start time
void dispatch_critical(double delayInSeconds, dispatch_block_t executionBlock)
{
    if (!executionBlock) { return; }
    
    int leeway = 0; // prevent GCD from scheduling blocks when convenient
    dispatch_queue_t queue = dispatch_queue_create("_dispatch_critical_q_", 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer)
    {
        dispatch_source_set_timer(timer,
                                  dispatch_walltime(DISPATCH_TIME_NOW,
                                                    NSEC_PER_SEC * delayInSeconds),
                                  DISPATCH_TIME_FOREVER, leeway);
        dispatch_source_set_event_handler(timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                executionBlock();
                dispatch_source_cancel(timer);
            });
        });
        dispatch_resume(timer);
    }
}

@end