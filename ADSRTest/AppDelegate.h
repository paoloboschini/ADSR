//
//  AppDelegate.h
//  ADSRTest
//
//  Created by Paolo Boschini on 9/16/13.
//  Copyright (c) 2013 Paolo Boschini. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ADSR.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, ADSRProtocol>

@property (assign) IBOutlet NSWindow *window;

@end
