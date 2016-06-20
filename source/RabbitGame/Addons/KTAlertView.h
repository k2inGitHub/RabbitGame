//
//  KTAlertView.h
//  Unity-iPhone
//
//  Created by 宋扬 on 15/10/27.
//
//

#import <Foundation/Foundation.h>

@interface KTAlertView : NSObject<UIAlertViewDelegate>

- (void)showAlertView: (NSString *) title tag:(int)tag message: (NSString*) msg okTitle:(NSString*) b1 noTitle:(NSString *)b2;
+ (id)sharedInstance;
@end
