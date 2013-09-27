ADSR
====

Customizable ADSR Controller

![alt tag](https://raw.github.com/paoloboschini/ADSR/master/screen.png)

Features
========

* Cusomizable appearance
* Cusomizable value range

Basic Usage
========

See example project for a demo.

```objectivec
// create an ADSR, set custom value range independent from ADSR frame width
ADSR *adsr = [[ADSR alloc] initWithFrame:NSMakeRect(10, 10, 400, 100)
                         withAttackRange:50
                          withDecayRange:60
                        withSustainRange:70
                        withReleaseRange:80
                               withColor:[NSColor greenColor]
                     withBackgroundColor:[NSColor blackColor]];

// Set the ADSR's delegate (must conform to ADSRProtocol and implement four update methods...)
adsr.delegate = self;
    
// Add ADSR to window
[self.window.contentView addSubview:adsr];

...

// called upon attack update
- (void)attackUpdatedWithValue:(int)value
{
    NSLog(@"Attack: %d", value);
}

// called upon decay update
- (void)decayUpdatedWithValue:(int)value
{
    NSLog(@"Decay: %d", value);
}

// called upon sustain update
- (void)sustainUpdatedWithValue:(int)value
{
    NSLog(@"Sustain: %d", value);
}

// called upon release update
- (void)releaseUpdatedWithValue:(int)value
{
    NSLog(@"Release: %d", value);
}

```
