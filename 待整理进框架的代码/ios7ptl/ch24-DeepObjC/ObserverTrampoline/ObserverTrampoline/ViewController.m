//
//  ViewController.m
//  ObserverTrampoline
//
//  Created by Rob Napier on 9/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "RNObserverManager.h"

@protocol MyProtocol <NSObject>

- (void)doSomething;

- (void)doSomethingWithArgs:(NSString *)arg;

- (void)doSomethingWithArgs:(NSString *)arg1
                       arg2:(NSString *)arg2;

@end

@interface MyClass : NSObject <MyProtocol>
@end

@implementation MyClass

- (void)doSomething {
  NSLog(@"doSomething :%@", self);
}

- (void)doSomethingWithArgs:(NSString *)arg {
     NSLog(@"doSomethingWithArgs :%@, %@", self, arg);
}

- (void)doSomethingWithArgs:(NSString *)arg1
                       arg2:(NSString *)arg2 {
    NSLog(@"doSomethingWithArgs :%@, %@, %@", self, arg1, arg2);
}

@end

@implementation ViewController
@synthesize observerManager=trampoline_;

- (void)viewDidLoad {
  [super viewDidLoad];
  NSSet *observers = [NSSet setWithObjects:[MyClass new], 
                      [MyClass new], nil];

  self.observerManager = [[RNObserverManager alloc] 
                          initWithProtocol:@protocol(MyProtocol) 
                          observers:observers];
    
    MyClass *instance1 = [MyClass new];
    [self.observerManager addObserver:instance1];
    
  
  [self.observerManager doSomething];
    
    [self.observerManager doSomethingWithArgs:@"arg1"];
    
    [self.observerManager doSomethingWithArgs:@"arg1" arg2:@"arg2"];
    
    [self.observerManager removeObserver:instance1];
    
    [self.observerManager doSomethingWithArgs:@"instance1 remove"];
    
}

@end
