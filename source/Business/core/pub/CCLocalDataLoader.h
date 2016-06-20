//
//  LocalScoreLoader.h
//  BookReader
//
//  Created by terababy on 10-8-26.
//  Copyright 2010 terababy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CCLocalDataLoader : NSObject {
	NSUInteger top;
	NSUInteger current;
	NSMutableDictionary * dictionary;
	NSURL *storeUrl;
    BOOL loaded;
}
@property(nonatomic, retain) NSMutableDictionary *dictionary;
@property(nonatomic, assign) NSUInteger top;
@property(nonatomic, assign) NSUInteger current;

+ (CCLocalDataLoader *) sharedLoader;
- (void)load:(NSString*)appname;
- (void)writePreference;

- (void)setUIntValue:(NSUInteger)value forKey:(NSString*)key;
- (NSUInteger)uintForKey:(NSString *)key  defaultValue:(NSUInteger)defaultValue;
- (NSUInteger)uintForKey:(NSString *)key;

- (BOOL)boolForKey:(NSString *)key;
- (void)setBoolValue:(BOOL)value forKey:(NSString*)key;

- (int)intForKey:(NSString *)key;
- (void)setIntValue:(int)value forKey:(NSString*)key;

- (void)setObjectNoWrite:(id)anObject forKey:(id)aKey;
- (NSString *)stringForKey:(NSString *)key;
- (void)setObject:(id)anObject forKey:(id)aKey;
@end
