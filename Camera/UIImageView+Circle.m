//
//  UIImageView+Circle.m
//  Camera
//
//  Created by Eduardo Sierra on 11/5/13.
//  Copyright (c) 2013 Sierra. All rights reserved.
//

#import "UIImageView+Circle.h"
#import "ESViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation UIImageView (Circle)

+ (UIImageView *)circleImageView:(CGRect)frame;
{
    
    UIImageView *circle = [[UIImageView alloc] initWithFrame:frame];
    circle.layer.cornerRadius = 150.f;
    circle.clipsToBounds = YES;
    
    return circle;
    
}

@end
