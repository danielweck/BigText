#import "BigTextWindow.h"

@interface BigTextWindow () {
	NSPoint initialLocation;
}
@end

@implementation BigTextWindow

- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {

	self = [super initWithContentRect:contentRect styleMask:NSWindowStyleMaskBorderless backing:NSBackingStoreBuffered defer:NO];
    if (self != nil) {
        self.alphaValue = 1.0;
        [self setOpaque:NO];
		self.backgroundColor = [NSColor clearColor];
    }
    return self;
}

- (BOOL)canBecomeKeyWindow {
    return YES;
}

- (void)mouseDown:(NSEvent *)theEvent {
    initialLocation = theEvent.locationInWindow;
}

- (void)mouseDragged:(NSEvent *)theEvent {
    NSRect windowFrame = self.frame;
    NSPoint newOrigin = windowFrame.origin;
	
    NSPoint currentLocation = theEvent.locationInWindow;

    newOrigin.x += (currentLocation.x - initialLocation.x);
    newOrigin.y += (currentLocation.y - initialLocation.y);
	
    [self setFrameOrigin:newOrigin];
}

- (void)keyDown:(NSEvent *)e {
	[self orderOut:nil];
}

@end
