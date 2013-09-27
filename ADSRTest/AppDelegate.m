//
//  AppDelegate.m
//  ADSRTest
//
//  Created by Paolo Boschini on 9/16/13.
//  Copyright (c) 2013 Paolo Boschini. All rights reserved.
//

// TODO: method for giving the range of values i.e. 0..100 or 0..200

#import "AppDelegate.h"
#import "ADSR.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    ADSR *adsr = [[ADSR alloc] initWithFrame:NSMakeRect(10, 10, 400, 100)
                             withAttackRange:50
                              withDecayRange:60
                            withSustainRange:70
                            withReleaseRange:80
                                   withColor:[NSColor greenColor]
                         withBackgroundColor:[NSColor blackColor]];
    adsr.delegate = self;
    [self.window.contentView addSubview:adsr];
}

- (void)attackUpdatedWithValue:(int)value
{
    NSLog(@"Attack: %d", value);
}

- (void)decayUpdatedWithValue:(int)value
{
    NSLog(@"Decay: %d", value);
}

- (void)sustainUpdatedWithValue:(int)value
{
    NSLog(@"Sustain: %d", value);
}

- (void)releaseUpdatedWithValue:(int)value
{
    NSLog(@"Release: %d", value);
}

@end
