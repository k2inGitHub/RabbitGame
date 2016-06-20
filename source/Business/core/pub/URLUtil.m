//
//  AppStore.m
//  SuperCoaster
//
//  Created by terababy on 10-11-22.
//  Copyright 2010 terababy. All rights reserved.
//

#import "URLUtil.h"
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#import <MessageUI/MessageUI.h>
#endif
#import "CCFileUtils.h"

//#import <CoreTelephony/CTTelephonyNetworkInfo.h>
//#import <CoreTelephony/CTCarrier.h>


#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
@interface MailController : NSObject <MFMailComposeViewControllerDelegate>

- (void)mail:(NSString*)recipient subject:(NSString*)subject body:(NSString*)body image:(UIImage*)image imageType:(NSString*)type;

@end

@implementation MailController

//- (void)loadView {
//	UIView *root = [[UIView alloc] initWithFrame:CGRectZero];
//	self.view = root;
//	[root release];
//}

- (void)mail:(NSString*)recipient subject:(NSString*)subject body:(NSString*)body imageData:(NSData*)image imageType:(NSString*)type{
	
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:subject];
    
    if (recipient) {
        NSArray *toRecipients = [NSArray arrayWithObject:recipient]; 
        //NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil]; 
        //NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"]; 
        
        [picker setToRecipients:toRecipients];
        //[picker setCcRecipients:ccRecipients];	
        //[picker setBccRecipients:bccRecipients];
    }
    
    // Attach an image to the email
    if (image) {
        if ([type isEqualToString:@"png"]) {
            [picker addAttachmentData:image mimeType:@"image/jpg" fileName:@"screenshot"];
        } else if ([type isEqualToString:@"jpg"]) {
            [picker addAttachmentData:image mimeType:@"image/png" fileName:@"screenshot"];
        }
    }
    
    [picker setMessageBody:body isHTML:NO];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentModalViewController:picker animated:YES];
    [picker release];
}

- (void)mail:(NSString*)recipient subject:(NSString*)subject body:(NSString*)body image:(UIImage*)image imageType:(NSString*)type{
    NSData *data = nil;
    if ([type isEqualToString:@"png"]) {
        data = UIImagePNGRepresentation(image); 
    } else if ([type isEqualToString:@"jpg"]) {
        data = UIImageJPEGRepresentation(image, 1.0f); 
    } 
    [self mail:recipient subject:subject body:body imageData:data imageType:type];
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	NSString *message;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			message = @"Result: canceled";
			break;
		case MFMailComposeResultSaved:
			message = @"Result: saved";
			break;
		case MFMailComposeResultSent:
			message = @"Result: sent";
			break;
		case MFMailComposeResultFailed:
			message = @"Result: failed";
			break;
		default:
			message = @"Result: not sent";
			break;
	}
	[[UIApplication sharedApplication].keyWindow.rootViewController dismissModalViewControllerAnimated:YES];
}

- (void) dealloc
{
    
	[super dealloc];
}
@end
#endif




@implementation URLUtil

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
+(void)launchURL:(NSString*)url
{
	NSURL *appStoreUrl = [NSURL URLWithString:url];
	[[UIApplication sharedApplication] openURL:appStoreUrl];
}

//+(NSString*)getCountryCode
//{
//	NSLocale *locale = [NSLocale currentLocale];
//	NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
//	
////	NSString *countryName = [locale displayNameForKey: NSLocaleCountryCode
////												value: countryCode];
//	return countryCode;
//	
//}
//
//+(NSString*)getCountryCodeByCarrier
//{
//	CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
//	CTCarrier *carrier = [netInfo subscriberCellularProvider];
//	NSString *mcc = [carrier mobileCountryCode];
//	return mcc;
//}

+(void)launchAppstore:(NSString*)appid
{
	NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/app/id%@", appid];
	NSURL *appStoreUrl = [NSURL URLWithString:url];
	[[UIApplication sharedApplication] openURL:appStoreUrl];
}

+(void)launchGoogleMap:(NSString*) addressText
{
	// Create your query ...
	//NSString* searchQuery = @"1 Infinite Loop, Cupertino, CA 95014";
	
	// Be careful to always URL encode things like spaces and other symbols that aren't URL friendly
	NSString *searchQuery =  [addressText stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	
	// Now create the URL string ...
	NSString* urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", searchQuery];
	
	// An the final magic ... openURL!
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

+(void)launchAppleMail:(NSString*)address
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@", address]]];
}

+ (NSString *)urlEncodeValue:(NSString *)str
{  
    NSString *result = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, (CFStringRef)@":/?#[]@!$&’()*+,;=", kCFStringEncodingUTF8);
    return [result autorelease];
}

+(void)sendTwitterMsg:(NSString*)message appID:(NSString*)appID
{
	NSString *message2 = [NSString stringWithFormat:@"%@ http://itunes.apple.com/app/id%@", message, appID];
    NSString *stringURL = [NSString stringWithFormat:@"twitter://post?message=%@", [URLUtil urlEncodeValue:message2]];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringURL]];
}

+(void)sendFacebookMsg:(NSString*)message
{
    NSString *stringURL = [NSString stringWithFormat:@"fb://post/%@", [URLUtil urlEncodeValue:message]];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringURL]];
}

+(void)launchPhone:(NSString*)phoneNo
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNo]]];
}

+(void)launchSMS:(NSString*)phoneNo
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", phoneNo]]];
}

static URLUtil *sharedLoader = nil;

+ (URLUtil *) sharedInstance
{
	@synchronized(self)     {
		if (!sharedLoader)
			sharedLoader = [[URLUtil alloc] init];
	}
	return sharedLoader;
}

+ (id) alloc
{
	@synchronized(self)     {
		NSAssert(sharedLoader == nil, @"Attempted to allocate a second instance of a singleton.");
		return [super alloc];
	}
	return nil;
}

+(void)launchAppleMailInApp:(UIView*)view recipient:(NSString*)recipient subject:(NSString*)subject body:(NSString*)body image:(UIImage*)image imageType:(NSString*)type
{		
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
            MailController* controller = [[MailController alloc] init];
            [controller mail:recipient subject:subject body:body image:image imageType:type];
		}
		else
		{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"系统未设置邮箱，现在是否进行设置？" delegate:[URLUtil sharedInstance] cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
            [alert release];
		}
	}
	else
	{
        [URLUtil launchAppleMail:recipient];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	switch (buttonIndex) {
		case 0:
		{
			break;
		}
		case 1:
		{
            [URLUtil launchAppleMail:nil];
			break;
		}
		default:
			break;
	}
}
#endif

NSString *currentLanguage;

+(NSString*)getCurrentLanguage
{
    if (currentLanguage) {
        return currentLanguage;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
    
    //NSLog(@"Current Locale: %@", [[NSLocale currentLocale] localeIdentifier]);
}

+(NSString*)getLocaleImageName:(NSString *)imageName
{
	NSString *texturePath = [NSString stringWithString:imageName];
    NSString *pathExtension = [texturePath pathExtension];
	texturePath = [texturePath stringByDeletingPathExtension];
    NSString *newPath = [NSString stringWithFormat:@"%@-%@", texturePath, [URLUtil getCurrentLanguage]];
	newPath = [newPath stringByAppendingPathExtension:pathExtension];
    
	NSString *fullpath = [CCFileUtils fullPathFromRelativePath: newPath ];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:fullpath]) {
        return newPath;
    }
    return imageName;
}
@end