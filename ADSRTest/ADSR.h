//
//  ADSR.h
//  Evo
//
//  Created by Paolo Boschini on 1/23/13.
//  Copyright (c) 2013 Paolo Boschini. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class ADSRControlPoint;

@protocol ADSRProtocol <NSObject>

- (void)attackUpdatedWithValue:(int)value;
- (void)decayUpdatedWithValue:(int)value;
- (void)sustainUpdatedWithValue:(int)value;
- (void)releaseUpdatedWithValue:(int)value;

@end

@interface ADSR : NSView

@property ADSRControlPoint *attackPoint;
@property ADSRControlPoint *decayPoint;
@property ADSRControlPoint *sustainPoint;
@property ADSRControlPoint *releasePoint;

@property (weak) id <ADSRProtocol> delegate;

- (id)initWithFrame:(NSRect)frame
    withAttackRange:(int)attackRange
     withDecayRange:(int)decayRange
   withSustainRange:(int)sustainRange
   withReleaseRange:(int)releaseRange
          withColor:(NSColor*)aColor
withBackgroundColor:(NSColor*)aBackgroundColor;

@end
