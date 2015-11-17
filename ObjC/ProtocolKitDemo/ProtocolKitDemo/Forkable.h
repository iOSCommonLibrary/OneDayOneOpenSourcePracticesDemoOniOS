//
//  Forkable.h
//  ProtocolKitDemo
//
//  Created by su xinde on 15/11/18.
//  Copyright © 2015年 com.su. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ProtocolKit.h"

@protocol Forkable <NSObject>

@optional
- (void)fork;

@required
- (NSString *)github;

@end

@defs(Forkable)

- (void)fork {
    NSLog(@"Forkable protocol extension: I'm forking (%@).", self.github);
}

- (NSString *)github
{
    return @"This is a required method, concrete class must override me.";
}

@end

@interface ForkableConcrete : NSObject <Forkable>

@end

@implementation ForkableConcrete

- (NSString *)github
{
    return @"https://github.com/suxinde2009";
}

@end