//
//  ADSRControlPoint.m
//  Evo
//
//  Created by Paolo Boschini on 1/29/13.
//  Copyright (c) 2013 Paolo Boschini. All rights reserved.
//

#import "ADSRControlPoint.h"
#import "ADSR.h"

@interface ADSRControlPoint ()
{
    ADSR *adsr;
    int mouseDown, decayStart;
    int currentValue;
    NSColor *color;
}
@end

@implementation ADSRControlPoint

- (id)initWithFrame:(NSRect)frame withColor:(NSColor*)aColor
{
    self = [super initWithFrame:frame];
    if (self) {
        color = aColor;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSBezierPath *fillCircle;
    NSRect rect;

    int i = 0;
    for (i = 0; i < 2; ++i) {
        rect = NSMakeRect(i, i, self.frame.size.width - i*2, self.frame.size.height - i*2);
        fillCircle = [NSBezierPath bezierPathWithOvalInRect: rect];
        [[color colorWithAlphaComponent:0.5 + i/10] setFill];
        [fillCircle fill];
    }

    rect = NSMakeRect(i, i, self.frame.size.width - i*2, self.frame.size.height - i*2);
    fillCircle = [NSBezierPath bezierPathWithOvalInRect: rect];
    [color setFill];
    [fillCircle fill];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    adsr = (ADSR*)[self superview];
    NSPoint event_location = [theEvent locationInWindow];
    NSPoint local_point = [[self superview] convertPoint:event_location fromView:nil];
    decayStart = adsr.decayPoint.frame.origin.x;
    mouseDown = local_point.x;
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    adsr = (ADSR*)[self superview];
    NSPoint event_location = [theEvent locationInWindow];
    NSPoint local_point = [[self superview] convertPoint:event_location fromView:nil];
    NSPoint origin = self.frame.origin;
    int x = local_point.x;
    int y = local_point.y;

    int width = self.frame.size.width;
    int height = self.frame.size.height;

    switch (self.tag)
    {
        case ATTACK:
            origin.x = x - width/2;

            if (x <= width/2)
            {
                origin.x = 0;
            }

            if (x >= self.pixelRange + width/2)
            {
                origin.x = self.pixelRange;
            }

            [self setFrameOrigin:origin];

            if (origin.x == 0)
            {
                currentValue = 0;
            }
            else
            {
                currentValue = (origin.x / self.pixelRange) * self.valueRange;
            }

            [adsr.delegate attackUpdatedWithValue:currentValue];
            self.currentPixelPosition = origin.x;
            
            // update decay
            NSPoint decayOrigin = adsr.decayPoint.frame.origin;
            decayOrigin.x = origin.x + (decayStart - mouseDown) + width/2;
            [adsr.decayPoint setFrameOrigin: decayOrigin];
            break;

        case DECAY:
            origin.x = x - width/2;

            if (x <= adsr.attackPoint.frame.origin.x + width/2)
            {
                origin.x = adsr.attackPoint.frame.origin.x;
            }
            if (x >= adsr.attackPoint.frame.origin.x + self.pixelRange + width/2)
            {
                origin.x = adsr.attackPoint.frame.origin.x + self.pixelRange;
            }
            
            [self setFrameOrigin:origin];

            float absoluteXDecay = origin.x - adsr.attackPoint.currentPixelPosition;
            
            currentValue = ((absoluteXDecay / self.pixelRange) * self.valueRange);
            [adsr.delegate decayUpdatedWithValue:currentValue];
            break;
        
        case SUSTAIN:
            origin.y = y - width/6;

            if (y <= width/6)
            {
                origin.y = 0;
            }
            
            if (y >= adsr.frame.size.height - height + width/6)
            {
                origin.y = adsr.frame.size.height - height;
            }
            
            [self setFrameOrigin:origin];
            
            currentValue = (origin.y / (adsr.frame.size.height - width)) * self.valueRange;
            [adsr.delegate sustainUpdatedWithValue:currentValue];
            
            // update decay
            decayOrigin = adsr.decayPoint.frame.origin;
            decayOrigin.y = origin.y;
            [adsr.decayPoint setFrameOrigin: decayOrigin];
            break;
        
        case RELEASE:
            origin.x = x - width/2;
            
            if (x <= adsr.attackPoint.pixelRange + adsr.decayPoint.pixelRange + adsr.sustainPoint.pixelRange + width/2)
            {
                origin.x = adsr.attackPoint.pixelRange + adsr.decayPoint.pixelRange + adsr.sustainPoint.pixelRange;
            }

            if (x >= adsr.frame.size.width - width/2)
            {
                origin.x = adsr.frame.size.width - width;
            }

            [self setFrameOrigin:origin];

            float absoluteXRelease = origin.x - adsr.attackPoint.pixelRange - adsr.decayPoint.pixelRange - adsr.sustainPoint.pixelRange;
            
            currentValue = ((absoluteXRelease / self.pixelRange) * self.valueRange);
            
            [adsr.delegate releaseUpdatedWithValue:currentValue];
            break;
        default:
            break;
    }
    [[self superview] setNeedsDisplay:YES];
}

- (BOOL)mouseDownCanMoveWindow
{
    return NO;
}

@end