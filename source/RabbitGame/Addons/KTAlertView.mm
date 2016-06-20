//
//  KTAlertView.m
//  Unity-iPhone
//
//  Created by 宋扬 on 15/10/27.
//
//

#import "KTAlertView.h"
#include "cocos2d.h"

@implementation KTAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
//    UnitySendMessage("PopupManager", "_onAlertViewClick", [KTUtils NSStringToChar:[NSString stringWithFormat:@"%d,%d", alertView.tag, buttonIndex]]);
    
//    __NotificationCenter::getInstance()->postNotification("onAlertViewClick", __Array::create(__Integer::create(alertView.tag), __Integer::create(buttonIndex), nil));
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"onAlertViewClick" object:nil userInfo:@{@""}];
}

- (void)showAlertView: (NSString *) title tag:(int)tag message: (NSString*) msg okTitle:(NSString*) b1 noTitle:(NSString *)b2{
    
    NSLog(@"b1 = %@, b2 = %@", b1, b2);
    
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.tag = tag;
    [alert setTitle:title];
    [alert setMessage:msg];
    [alert setDelegate: [KTAlertView sharedInstance]];
    if (b2 != nil && b2.length > 0) {
        [alert addButtonWithTitle:b2];
    }
    [alert addButtonWithTitle:b1];
    [alert show];
}

+ (id)sharedInstance
{
    static KTAlertView *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedInstance == nil) {
            sharedInstance = [[KTAlertView alloc] init];
        }
    });
    return sharedInstance;
}

//extern "C" {
//    
//    void _ShowAlertView(char* title, int tag, char* message, char* b1, char* b2) {
//        [KTAlertView showAlertView:[KTUtils charToNSString:title] tag:tag message:[KTUtils charToNSString:message] okTitle:[KTUtils charToNSString:b1] noTitle:[KTUtils charToNSString:b2]];
//    }
//}
@end


