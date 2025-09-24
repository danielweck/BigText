#import "BigTextView.h"

#define MIN_FONT_SIZE 100
#define MAX_FONT_SIZE 200

#define WINDOW_MARGIN 20

#define HORIZONTAL_PADDING 100

@interface BigTextView () {
	NSString *bigTextString;
    CGFloat bigTextFontSize;
    CGFloat bigTextHeight;
}
@end

@implementation BigTextView

- (void)drawRect:(NSRect)dirtyRect {
	NSRect selfRect = self.bounds;
	
    [[NSColor clearColor] set];
    NSRectFill(self.bounds);
	NSBezierPath* bezierPath = [NSBezierPath bezierPath];
	[bezierPath appendBezierPathWithRoundedRect:selfRect xRadius:WINDOW_MARGIN yRadius:WINDOW_MARGIN];
    [[[NSColor blackColor] colorWithAlphaComponent:0.85] set];
	[bezierPath fill];
	
	NSMutableParagraphStyle *paragraphStyle;
	paragraphStyle = [[[NSMutableParagraphStyle alloc] init] autorelease];
	paragraphStyle.alignment = NSTextAlignmentCenter;
	
	NSShadow *shadow = [[[NSShadow alloc] init] autorelease];
	shadow.shadowBlurRadius = 5;
	shadow.shadowOffset = NSMakeSize(5, -5);
	
	NSDictionary *atts = @{NSFontAttributeName: [NSFont boldSystemFontOfSize:bigTextFontSize],
						  NSForegroundColorAttributeName: [NSColor whiteColor],
						  NSShadowAttributeName: shadow,
						  NSParagraphStyleAttributeName: paragraphStyle};
	
    selfRect.origin.y -= (selfRect.size.height - bigTextHeight) / 2;
	
	[bigTextString drawWithRect:selfRect
						options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics
					 attributes:atts];
}

- (void)setBigText:(NSString *)str {
	[bigTextString release];

	str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	bigTextString = [str retain];
	
	NSUInteger maxNumberOfLineCharacters = 1;
	for (NSString *lineStr in [str componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]) {
		if (lineStr.length > maxNumberOfLineCharacters)
			maxNumberOfLineCharacters = lineStr.length;
	}
	NSRect mainScreenRect = [NSScreen mainScreen].visibleFrame;
    CGFloat mainScreenWidth = mainScreenRect.size.width;
	CGFloat mainScreenHeight = mainScreenRect.size.height;

    CGFloat widthAvailableForTextLine = mainScreenWidth - 2 * HORIZONTAL_PADDING - 2 * WINDOW_MARGIN;

	CGFloat widthPerCharacter = widthAvailableForTextLine / maxNumberOfLineCharacters;

	if (widthPerCharacter > MAX_FONT_SIZE) {
		bigTextFontSize = MAX_FONT_SIZE;
	} else {
		if (widthPerCharacter < MIN_FONT_SIZE) {
			widthPerCharacter = MIN_FONT_SIZE;
		} else {
			widthPerCharacter = floor(widthPerCharacter);
		}
		NSMutableDictionary *atts = [[NSMutableDictionary alloc] init];
		atts[NSFontAttributeName] = [NSFont boldSystemFontOfSize:widthPerCharacter];
		
		bigTextFontSize = widthPerCharacter;
		CGFloat textWidth = [bigTextString sizeWithAttributes:atts].width;
		
		while (textWidth < widthAvailableForTextLine) {
			bigTextFontSize = widthPerCharacter;
			atts[NSFontAttributeName] = [NSFont boldSystemFontOfSize:++widthPerCharacter];
			textWidth = [bigTextString sizeWithAttributes:atts].width;
		}
		[atts release];
	}
	
	NSRect strRect = [bigTextString boundingRectWithSize:NSMakeSize(widthAvailableForTextLine, mainScreenHeight)
									 options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
								  attributes:@{NSFontAttributeName:[NSFont boldSystemFontOfSize:bigTextFontSize]}];
    bigTextHeight = strRect.size.height;

    NSSize windSize = strRect.size;
    windSize.width = mainScreenWidth - 2 * WINDOW_MARGIN;
    windSize.height = mainScreenHeight - 2 * WINDOW_MARGIN;
	NSWindow *selfWindow = self.window;
	NSRect windRect = selfWindow.frame;
	windRect.size = windSize;
    windRect.origin.x = mainScreenRect.origin.x + WINDOW_MARGIN;
    windRect.origin.y = mainScreenRect.origin.y + WINDOW_MARGIN;
	[selfWindow setFrame:NSIntegralRect(windRect) display:YES];
	[selfWindow makeKeyAndOrderFront:nil];
}

@end
