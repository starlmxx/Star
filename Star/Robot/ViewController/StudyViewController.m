//
//  StudyViewController.m
//  Star
//
//  Created by limingxing on 2/28/16.
//  Copyright © 2016 limingxing. All rights reserved.
//

#import "StudyViewController.h"

@interface StudyViewController ()
{
    UIImageView *_carImageView;
    UIImageView *_leftTireImageView;
    UIImageView *_rightTireImageView;
}
@end

@implementation StudyViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self setupView];
    
    _carImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth, ScreenHeight/2-20, 150, 100)];
    _carImageView.image = [UIImage imageNamed:@"red_car"];
    [self.view addSubview:_carImageView];
    
    [self moveCarAnimation];
    
    _leftTireImageView = [[UIImageView alloc] initWithFrame:CGRectMake(27, 54, 20, 20)];
    _leftTireImageView.image = [UIImage imageNamed:@"new_tire"];
    [self setRoundImageView:_leftTireImageView];
    [_carImageView addSubview:_leftTireImageView];
    
    _rightTireImageView = [[UIImageView alloc] initWithFrame:CGRectMake(109, 54, 20, 20)];
    _rightTireImageView.image = [UIImage imageNamed:@"new_tire"];
    [self setRoundImageView:_rightTireImageView];
    [_carImageView addSubview:_rightTireImageView];
    
    [self startAnimation];
}

- (void)setRoundImageView:(UIImageView *)rawImageView
{
    UIGraphicsBeginImageContextWithOptions(rawImageView.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, rawImageView.bounds);
    CGContextClip(ctx);
    
    [rawImageView.image drawInRect:rawImageView.bounds];
    
    UIImage *desImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext ();
    
    rawImageView.image = desImage;
    UIGraphicsEndImageContext();
}

- (void)startAnimation
{
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         _leftTireImageView.transform = CGAffineTransformRotate(_leftTireImageView.transform, -M_PI_2);
                         _rightTireImageView.transform = CGAffineTransformRotate(_rightTireImageView.transform, -M_PI_2);
                     } completion:^(BOOL finished) {
                         if (finished) {
                             [self startAnimation];
                         }
                     }];
}

- (void)moveCarAnimation
{
    [UIView animateWithDuration:1.0
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         _carImageView.transform = CGAffineTransformMakeTranslation((-ScreenWidth)/2, 0);
                     } completion:^(BOOL finished) {
                         if (finished) {
                             [UIView animateWithDuration:1.5
                                                   delay:0.5
                                                 options:UIViewAnimationOptionCurveLinear
                                              animations:^{
                                                  _carImageView.transform = CGAffineTransformMakeTranslation(-ScreenWidth-150, 0);
                                              } completion:^(BOOL finished) {
                                                  if (finished) {
                                                      _carImageView.transform = CGAffineTransformMakeTranslation(ScreenWidth+150, 0);
                                                      [self moveCarAnimation];
                                                  }
                                              }];
                         }
                     }];
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor clearColor];
    
    // 画矩形
//    CAShapeLayer *layer = [CAShapeLayer layer];
//    layer.frame = CGRectMake(110, 100, 150, 100);
//    layer.backgroundColor = [UIColor blackColor].CGColor;
//    [self.view.layer addSublayer:layer];
    
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(110, 100, 150, 100)];
//    CAShapeLayer *layer = [CAShapeLayer layer];
//    layer.path = path.CGPath;
//    layer.fillColor = [UIColor blackColor].CGColor;
//    layer.strokeColor = [UIColor redColor].CGColor;
//    [self.view.layer addSublayer:layer];
    
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(110, 100, 150, 100) cornerRadius:50];
//    CAShapeLayer *layer = [CAShapeLayer layer];
//    layer.path = path.CGPath;
//    layer.fillColor = [UIColor clearColor].CGColor;
//    layer.strokeColor = [UIColor blackColor].CGColor;
    
//    CGFloat redius = 60.0f;
//    CGFloat startAngle = 0.0;
//    CGFloat endAngle = (CGFloat)(M_PI * 1.5);
//    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.view.center radius:redius startAngle:startAngle endAngle:endAngle clockwise:YES];
//    CAShapeLayer *layer = [CAShapeLayer layer];
//    layer.path = path.CGPath;
//    layer.fillColor = [UIColor clearColor].CGColor;
//    layer.strokeColor = [UIColor blackColor].CGColor;
    
    
    CGPoint startPoint = CGPointMake(50, 300);
    CGPoint endPoint = CGPointMake(300, 300);
    CGPoint controlPoint = CGPointMake(170, 200);
    CGPoint controlPoint2 = CGPointMake(180, 400);
    
    CAShapeLayer *layer1 = [CAShapeLayer layer];
    layer1.frame = CGRectMake(startPoint.x, startPoint.y, 5, 5);
    layer1.backgroundColor = [UIColor redColor].CGColor;
    
    CAShapeLayer *layer2 = [CAShapeLayer layer];
    layer2.frame = CGRectMake(endPoint.x, endPoint.y, 5, 5);
    layer2.backgroundColor = [UIColor redColor].CGColor;
    
    CAShapeLayer *layer3 = [CAShapeLayer layer];
    layer3.frame = CGRectMake(controlPoint.x, controlPoint.y, 5, 5);
    layer3.backgroundColor = [UIColor redColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    [path moveToPoint:startPoint];
//    [path addQuadCurveToPoint:endPoint controlPoint:controlPoint];
    [path addCurveToPoint:endPoint controlPoint1:controlPoint controlPoint2:controlPoint2];
    
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor blackColor].CGColor;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = 2;
    [layer addAnimation:animation forKey:@""];
    
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
//    animation.fromValue = @0.5;
//    animation.toValue = @0;
//    animation.duration = 2.f;
//    
//    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    animation2.fromValue = @0.5;
//    animation2.toValue = @1;
//    animation2.duration = 2;
//    
//    [layer addAnimation:animation forKey:@""];
//    [layer addAnimation:animation2 forKey:@""];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    animation2.fromValue = @1;
    animation2.toValue = @10;
    animation2.duration = 2;
    [layer addAnimation:animation2 forKey:@""];
    
    [self.view.layer addSublayer:layer];
    [self.view.layer addSublayer:layer1];
    [self.view.layer addSublayer:layer2];
    [self.view.layer addSublayer:layer3];
    
    
    
}

@end
