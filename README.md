UIView-SequentialAnimation
==========================

### Category on UIView that schedules sequential animations for an array of views. 

#### Methods:
``` objective-c
+ (void)animateViews:(NSArray*)views
        withDuration:(double)duration
          animations:(void(^)(UIView*, NSInteger))animationBlock;
```
``` objective-c

+ (void)animateViews:(NSArray*)views
        withDuration:(double)duration
          animations:(void(^)(UIView*, NSInteger))animationBlock
          completion:(void(^)(void))completionBlock;
```
``` objective-c
+ (void)animateViews:(NSArray*)views
        withDuration:(double)duration
          animations:(void(^)(UIView*, NSInteger))animationBlock
      eachCompletion:(void(^)(UIView*, NSInteger))iterationCompletionBlock
          completion:(void(^)(void))completionBlock;
```
``` objective-c
+ (void)animateViews:(NSArray*)views  
        withDuration:(double)duration  
               delay:(double)delay      
          animations:(void(^)(UIView*, NSInteger))animationBlock
      eachCompletion:(void(^)(UIView*, NSInteger))iterationCompletionBlock
          completion:(void(^)(void))completionBlock 
             options:(UIViewAnimationOptions)animationOptions;
```

#### Breaking down the parameters:

`animateViews:(NSArray*)views`
The views that will be animated. The order of the views is the order in which the animations will occur. 

`withDuration:(double)duration` 
The duration of each individual view animation.

`delay:(double)delay`
The delay between each individual animation. A negative value will have the next animation fire before the previous is completed, and a negative number with a value that equals the `duration` will cause all animations to happen synchronously.

`animations:(void(^)(UIView* view, NSInteger iteration))animationBlock`
The animations to be performed on each view. Use the supplied `view` parameter for all animations. `iteration` is the current index of the view being animated.

`eachCompletion:(void(^)(UIView*, NSInteger))iterationCompletionBlock`
A block that is called at the end of each individual animation's completion. Not animated by default. 

`completion:(void(^)(void))completionBlock`
A block that is called only after all animations have completed. 

`options:(UIViewAnimationOptions)animationOptions`
UIViewAnimationOptions for speed curves, autoreversing, and so on. 


#### Example:
##### 'Pop' (inflate/deflate) a set of views, except for the last view, which will shrink and stay shrunken.
             
``` objective-c
    [UIView animateViews:arrayOfViews
            withDuration:0.25
                   delay:-0.1
              animations:^(UIView * view, NSInteger iteration) {
                  // Enlarge the views's layer
                  CGFloat scaleDelta = (iteration == [arrayOfViews count]-1) 0.5f : 1.5f;
                  CATransform3D scaleTransform = CATransform3DMakeScale(scaleDelta, scaleDelta, 1.0);
                  view.layer.transform = scaleTransform;
              }
          eachCompletion:^(UIView * view, NSInteger iteration) {
              // Return the view to it's original size
              if (iteration != ([arrayOfViews count]-1))
              {
                  [UIView animateWithDuration:duration animations:^{
                      CATransform3D scaleTransform = CATransform3DIdentity;
                      view.layer.transform = scaleTransform;
                  }];
              }
          } completion:^{
                NSLog(@"Wow. So animation. Very abstraction.");
            } options:UIViewAnimationOptionCurveEaseOut];
```
             
