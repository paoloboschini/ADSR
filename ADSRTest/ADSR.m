//
//  ADSR.m
//  Evo
//
//  Created by Paolo Boschini on 1/23/13.
//  Copyright (c) 2013 Paolo Boschini. All rights reserved.
//

#import "ADSR.h"
#import "ADSRControlPoint.h"

@interface NSView (Center)
- (NSPoint)center;
@end

@implementation NSView (Center)
- (NSPoint)center
{
    return NSMakePoint(self.frame.origin.x + self.frame.size.width/2,
                       self.frame.origin.y + self.frame.size.width/2);
}
@end

const double POINT_SIZE = 12;

@interface ADSR ()
{
    NSPoint p0, p1, p2, p3, p4;
    NSBezierPath *line;
    NSColor *color;
}
@end

@implementation ADSR

- (id)initWithFrame:(NSRect)frame
    withAttackRange:(int)attackRange
     withDecayRange:(int)decayRange
   withSustainRange:(int)sustainRange
   withReleaseRange:(int)releaseRange
          withColor:(NSColor*)aColor
withBackgroundColor:(NSColor *)aBackgroundColor
{
    self = [super initWithFrame:frame];
    if (self)
    {
        color = aColor;
        
        NSRect rect = NSMakeRect(0, 0, POINT_SIZE, POINT_SIZE);
        int width = self.frame.size.width - POINT_SIZE;
        int height = self.frame.size.height;

        int attackPixelRange = width * 0.3;
        int decayPixelRange = width * 0.3;
        int sustainPixelRange = width * 0.1;
        int releasePixelRange = width * 0.3;
        int discardedPixels = self.frame.size.width - POINT_SIZE - attackPixelRange - decayPixelRange - sustainPixelRange - releasePixelRange;
        
        rect.origin.x = 0;
        rect.origin.y = height - POINT_SIZE;
        self.attackPoint = [[ADSRControlPoint alloc] initWithFrame:rect withColor:color];
        self.attackPoint.tag = 0;
        self.attackPoint.pixelRange = attackPixelRange;
        self.attackPoint.valueRange = attackRange;
        [self addSubview:self.attackPoint];

        rect.origin.x = decayPixelRange;
        rect.origin.y = height - POINT_SIZE;
        self.decayPoint = [[ADSRControlPoint alloc] initWithFrame:rect withColor:color];
        self.decayPoint.tag = 1;
        self.decayPoint.pixelRange = decayPixelRange;
        self.decayPoint.valueRange = decayRange;
        [self addSubview:self.decayPoint];

        rect.origin.x = attackPixelRange + decayPixelRange + sustainPixelRange;
        rect.origin.y = height - POINT_SIZE;
        self.sustainPoint = [[ADSRControlPoint alloc] initWithFrame:rect withColor:color];
        self.sustainPoint.tag = 2;
        self.sustainPoint.pixelRange = sustainPixelRange;
        self.sustainPoint.valueRange = sustainRange;
        [self addSubview:self.sustainPoint];

        rect.origin.x = attackPixelRange + decayPixelRange + sustainPixelRange + releasePixelRange + discardedPixels;
        rect.origin.y = 0;
        self.releasePoint = [[ADSRControlPoint alloc] initWithFrame:rect withColor:color];
        self.releasePoint.tag = 3;
        self.releasePoint.pixelRange = releasePixelRange + discardedPixels;
        self.releasePoint.valueRange = releaseRange;
        [self addSubview:self.releasePoint];
        
        [self setWantsLayer:YES];
        self.layer.backgroundColor = aBackgroundColor.CGColor;
        
        p0 = NSMakePoint(POINT_SIZE/2, POINT_SIZE/2);
        line = [NSBezierPath bezierPath];
    }
    return self;
}

- (void)drawRect:(NSRect)rect
{
    p1 = self.attackPoint.center;
    p2 = self.decayPoint.center;
    p3 = self.sustainPoint.center;
    p4 = self.releasePoint.center;
    
    // Clear line
    [line removeAllPoints];
    
    // Constructing the path
    [line moveToPoint:p0];

    if (p1.x == POINT_SIZE/2)
        [line lineToPoint:p1];
    else
        [line curveToPoint:p1
             controlPoint1:NSMakePoint(p1.x/3, self.frame.size.height * 0.8)
             controlPoint2:p1];

    [line curveToPoint:p2
         controlPoint1:NSMakePoint(p1.x+((p2.x-p1.x)/3), p2.y)
         controlPoint2:p2];
    
    [line lineToPoint:p3];

    if (p3.y == POINT_SIZE/2)
        [line lineToPoint:p4];
    else
        [line curveToPoint:p4
             controlPoint1:NSMakePoint(p3.x+((p4.x-p3.x)/4), p3.y/4)
             controlPoint2:p4];

    // fill area
    [[color colorWithAlphaComponent:0.5] set];
    [line fill];

    // draw the path
    [color set];
    [line setLineWidth:2];
    [line stroke];
}

@end