#import "BigTextAppDelegate.h"
#import "BigTextView.h"

@interface BigTextAppDelegate () {
	BOOL launchedAsService;
}
@end

@implementation BigTextAppDelegate

- (void)bigText:(NSPasteboard *)pboard userData:(NSString *)userData error:(NSString **)error {
	launchedAsService = YES;

	if (![pboard canReadObjectForClasses:@[[NSString class]] options:@{}]) {
		*error = NSLocalizedString(@"Error: not able to obtain user-selected text.",
								   @"pboard did not provide string object.");
		return;
	}

	NSString *str = [pboard stringForType:NSPasteboardTypeString];
	[_textWindow.contentView setBigText:str];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
	NSString *str = [standardDefaults stringForKey:@"s"];
	if (str) {
		launchedAsService = YES;
		[_textWindow.contentView setBigText:str];
		[NSApp activateIgnoringOtherApps:YES];
	}

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(bigTextDone:)
												 name:NSWindowDidResignKeyNotification
											   object:_textWindow];
	NSApp.servicesProvider = self;
	[NSTimer scheduledTimerWithTimeInterval:1.0 target:self
								   selector:@selector(showHelpWindow:)
								   userInfo:nil repeats:NO];
}

- (void)showHelpWindow:(NSTimer *)t {
    if (launchedAsService) {
        return;
    }

	[_textWindow.contentView setBigText:@"This is a sample text with a line break...\n...and some more text following :)"];
	[_helpWindow center];
	[_helpWindow makeKeyAndOrderFront:nil];
	[NSApp activateIgnoringOtherApps:YES];
}

- (void)bigTextDone:(NSNotification *)n {
    if (launchedAsService) {
        [NSApp terminate:nil];
    }
}


@end
