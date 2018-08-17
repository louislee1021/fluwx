#import <fluwx/FluwxPlugin.h>
#import "FluwxMethods.h"
#import "WXApi.h"
#import "StringUtil.h"
#import "../../../../../../ios/Classes/handler/FluwxShareHandler.h"
#import "FluwxShareHandler.h"
#import "FluwxShareHandler.h"


@implementation FluwxPlugin

BOOL isWeChatRegistered = NO;


+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
            methodChannelWithName:@"fluwx"
                  binaryMessenger:[registrar messenger]];
    FluwxPlugin *instance = [[FluwxPlugin alloc] initWithRegistrar:registrar];
    [registrar addMethodCallDelegate:instance channel:channel];


}

-(instancetype) initWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    self = [super init];
    if (self) {
        _fluwxShareHandler = [[FluwxShareHandler alloc] initWithRegistrar:registrar];
    }

    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {

    if ([initWeChat isEqualToString:call.method]) {
        [self initWeChatIfNeeded:call result:result];
    } if ([call.method hasPrefix:@"share"]) {
        [_fluwxShareHandler handleShare:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }





}


- (void)initWeChatIfNeeded:(FlutterMethodCall *)call result:(FlutterResult)result {
    if (isWeChatRegistered) {
        result(@YES);
        return;
    }

    NSString *appId = call.arguments;
    NSLog(appId);
    if ([StringUtil isBlank:appId]) {
        result([FlutterError errorWithCode:@"invalid app id" message:@"are you sure your app id is correct ? " details:appId]);
        return;
    }


    isWeChatRegistered = [WXApi registerApp:appId];
    result(@YES);
}


@end