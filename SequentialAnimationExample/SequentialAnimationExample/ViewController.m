//
//  ViewController.m
//  SequentialAnimationExample
//
//  Created by ----- --- on 3/29/14.
//  Copyright (c) 2014 Association Business Computer Application Brian Cox. All rights reserved.
//

#import "ViewController.h"
#import "UIView+SequentialAnimation.h"

#define kNumberOfBlocks 8

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tap;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self setupBlockViews];
}

- (IBAction)viewTapped:(UITapGestureRecognizer *)sender
{
    [self animateBlockViews];
}

- (void)setupBlockViews
{
    CGFloat blockViewPadding = 10.0f;
    CGFloat blockViewWidth = ([UIScreen mainScreen].bounds.size.width - ((kNumberOfBlocks+1) * blockViewPadding))
                                                            / kNumberOfBlocks;
    
    for (NSInteger i = 0; i <= kNumberOfBlocks; i++)
    {
        UIView* view = [[UIView alloc] init];
        CGRect viewFrame;
        // create view shape
        viewFrame.size = CGSizeMake(blockViewWidth, blockViewWidth);
        // create position
        CGFloat x = blockViewPadding + i*(blockViewPadding + blockViewWidth);
        CGFloat y = self.view.center.y - (view.bounds.size.height / 2);
        viewFrame.origin = CGPointMake(x, y);
        view.frame = viewFrame;
        // background color
        view.backgroundColor = [UIColor grayColor];
        
        [self.view addSubview:view];
    }
}

- (void)animateBlockViews
{
    NSArray* views = self.view.subviews;
    CGFloat duration = 0.15f;
    UIColor* randomColor = [self randomColor];
    
    [UIView animateViews:views
            withDuration:duration
                   delay:-0.05
              animations:^(UIView *view, NSInteger iteration) {
                  CGRect frame = view.frame;
                  frame.origin.y = self.view.center.y - (view.bounds.size.height / 2) - 100;
                  view.frame = frame;
                  view.backgroundColor = randomColor;
              }
          eachCompletion:^(UIView *view, NSInteger iteration) {
              [UIView animateWithDuration:duration animations:^{
                  CGRect frame = view.frame;
                  frame.origin.y = self.view.center.y - (view.bounds.size.height / 2);
                  view.frame = frame;
              }];
          }
              completion:nil
                 options:UIViewAnimationOptionCurveEaseOut];
}

- (UIColor*)randomColor
{
    UIColor* color = [UIColor colorWithRed:[self randomInteger]/255.0
                                     green:[self randomInteger]/255.0
                                      blue:[self randomInteger]/255.0
                                     alpha:1.0f];
    return color;
}

- (NSInteger)randomInteger
{
    return arc4random_uniform(256);
}

@end
