//
//  UIColorAdditions.m
//  SpaceCatalog
//
//  Created by spaceli on 11-8-31.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UIColorAdditions.h"

@implementation UIColor (value)

- (CGFloat *)RGBA {
    CGFloat *RGBA = malloc(sizeof(CGFloat)*4);
    for (int i=0;i<4;i++) {
        RGBA[i]=0;
    }
    CGColorRef color = [self CGColor];
    unsigned long numComponents = CGColorGetNumberOfComponents(color);
    
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(color);
        RGBA[0] = components[0];
        RGBA[1] = components[1];
        RGBA[2] = components[2];
        RGBA[3] = components[3];
    }
    return RGBA;
}

- (int *)RGBA255 {
    int *RGBA = malloc(sizeof(int)*4);
    for (int i=0;i<4;i++) {
        RGBA[i]=0;
    }
    CGColorRef color = [self CGColor];
    unsigned long numComponents = CGColorGetNumberOfComponents(color);
    
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(color);
        RGBA[0] = components[0]*255;
        RGBA[1] = components[1]*255;
        RGBA[2] = components[2]*255;
        RGBA[3] = components[3]*255;
    }
    return RGBA;
}
@end
