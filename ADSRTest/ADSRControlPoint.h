//
//  ADSRControlPoint.h
//  Evo
//
//  Created by Paolo Boschini on 1/29/13.
//  Copyright (c) 2013 Paolo Boschini. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class ADSR;

enum ADSRcontrolPointNames
{
    ATTACK,
    DECAY,
    SUSTAIN,
    RELEASE
};

@interface ADSRControlPoint : NSView

@property int tag;
@property int pixelRange;
@property int valueRange;
@property int currentPixelPosition;

- (id)initWithFrame:(NSRect)frame
          withColor:(NSColor*)aColor;

@end
