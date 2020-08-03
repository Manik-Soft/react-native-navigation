#import "ReactNativeNavigation.h"

#import <React/RCTUIManager.h>

#import "RNNBridgeManager.h"
#import "RNNSplashScreen.h"
#import "RNNLayoutManager.h"
#import "RNNTurboModule.h"
@interface ReactNativeNavigation()

@property (nonatomic, strong) RNNBridgeManager *bridgeManager;
@property (nonatomic, strong) UIWindow *mainWindow;

@end

@implementation ReactNativeNavigation

# pragma mark - public API


+ (RNNTurboModule *)createTurboModule {
    return [[ReactNativeNavigation sharedInstance] createTurboModule];
}

+ (void)bootstrapWithlaunchOptions:(NSDictionary *)launchOptions {
	[[ReactNativeNavigation sharedInstance] bootstrapWithDelegate:nil launchOptions:launchOptions];
}

+ (void)bootstrapWithDelegate:(id<RCTBridgeDelegate>)bridgeDelegate launchOptions:(NSDictionary *)launchOptions {
    [[ReactNativeNavigation sharedInstance] bootstrapWithDelegate:bridgeDelegate launchOptions:launchOptions];
}

+ (void)registerExternalComponent:(NSString *)name callback:(RNNExternalViewCreator)callback {
	[[ReactNativeNavigation sharedInstance].bridgeManager registerExternalComponent:name callback:callback];
}

+ (NSArray<id<RCTBridgeModule>> *)extraModulesForBridge:(RCTBridge *)bridge {
    return [[ReactNativeNavigation sharedInstance].bridgeManager extraModulesForBridge:bridge];
}

+ (RCTBridge *)getBridge {
	return [[ReactNativeNavigation sharedInstance].bridgeManager bridge];
}

+ (id)getEventEmitter {
    return [[ReactNativeNavigation sharedInstance].bridgeManager eventEmitter];
}

+ (UIViewController *)findViewController:(NSString *)componentId {
    return [RNNLayoutManager findComponentForId:componentId];
}


# pragma mark - instance

+ (instancetype) sharedInstance {
	static ReactNativeNavigation *instance = nil;
	static dispatch_once_t onceToken = 0;
	dispatch_once(&onceToken,^{
		if (instance == nil) {
			instance = [[ReactNativeNavigation alloc] init];
		}
	});
	
	return instance;
}

- (void)bootstrapWithDelegate:(id<RCTBridgeDelegate>)bridgeDelegate launchOptions:(NSDictionary *)launchOptions {
	_mainWindow = [self initializeKeyWindow];
	
	self.bridgeManager = [[RNNBridgeManager alloc] initWithlaunchOptions:launchOptions andBridgeDelegate:bridgeDelegate mainWindow:_mainWindow];
    [self.bridgeManager initializeBridge];
	[RNNSplashScreen showOnWindow:_mainWindow];
}

- (RNNTurboModule *)createTurboModule {
    return [[RNNTurboModule alloc] initWithBridge:[ReactNativeNavigation getBridge] mainWindow:_mainWindow];
}

- (UIWindow *)initializeKeyWindow {
	UIWindow* keyWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	UIApplication.sharedApplication.delegate.window = keyWindow;
	return keyWindow;
}

@end