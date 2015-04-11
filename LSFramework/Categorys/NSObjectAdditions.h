//
//  NSObjectAdditions.h
//  LSiPhone
//
//  Created by spaceli on 11-8-2.
//  Copyright 2011年 diandian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LSAdditions) 

- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3;
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
           withObject:(id)p4;

- (id)performSelector:(SEL)selector withObjects:(id)obj1,...;
@end
