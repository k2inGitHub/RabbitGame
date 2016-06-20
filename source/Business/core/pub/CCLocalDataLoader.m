//
//  BookLoader.m
//  BookReader
//
//  Created by terababy on 10-8-26.
//  Copyright 2010 terababy. All rights reserved.
//

#import "CCLocalDataLoader.h"

@implementation CCLocalDataLoader

@synthesize dictionary;
@synthesize top;
@synthesize current;

static CCLocalDataLoader *sharedLoader = nil;

// Init
+ (CCLocalDataLoader *) sharedLoader
{
	@synchronized(self)     {
		if (!sharedLoader)
			sharedLoader = [[CCLocalDataLoader alloc] init];
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

- (id)init {
	if (self == [super init]) {
		current = 0;
	}
	return self;
}

- (NSString *)stringForKey:(NSString *)key {
	NSObject *value = [dictionary valueForKey:key];
	return (NSString *)value;
}

- (NSUInteger)uintForKey:(NSString *)key  defaultValue:(NSUInteger)defaultValue {
	NSNumber *value = (NSNumber *)[dictionary objectForKey:key];
	if (value == nil) {
		return defaultValue;
	}
	NSUInteger len = [value unsignedIntegerValue];
	return len;
}

- (NSUInteger)uintForKey:(NSString *)key {
	NSNumber *value = (NSNumber *)[dictionary objectForKey:key];
	if (value == nil) {
		return 0;
	}
	NSUInteger len = [value unsignedIntegerValue];
	return len;
}

- (void)setObjectNoWrite:(id)anObject forKey:(id)aKey {
	[dictionary setObject:anObject forKey:aKey];
}

- (void)setObject:(id)anObject forKey:(id)aKey {
	[dictionary setObject:anObject forKey:aKey];
	[self writePreference];
}

- (void)load:(NSString*)appname {
    if (loaded) {
        return;
    }
    loaded = TRUE;
    
	NSString *applicationDocumentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	NSString *indexFilePath = [applicationDocumentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.idx", appname]];
	storeUrl = [NSURL fileURLWithPath:indexFilePath];
	[storeUrl retain];
	dictionary = [NSMutableDictionary dictionaryWithCapacity:10];
	[dictionary retain];
	if ([[NSFileManager defaultManager] fileExistsAtPath:indexFilePath]) {
		// 用户文档目录内索引文件存在
		NSDictionary *mydictionary = [NSDictionary dictionaryWithContentsOfURL:storeUrl];
		[dictionary addEntriesFromDictionary:mydictionary];
	}
}

- (void)setUIntValue:(NSUInteger)value forKey:(NSString*)key
{
	[dictionary setObject:[NSNumber numberWithUnsignedInteger:value] forKey:key];
	[self writePreference];
}

- (int)intForKey:(NSString *)key {
	NSNumber *value = (NSNumber *)[dictionary objectForKey:key];
	if (value == nil) {
		return 0;
	}
	int len = [value intValue];
	return len;
}

- (void)setIntValue:(int)value forKey:(NSString*)key
{
	[dictionary setObject:[NSNumber numberWithInteger:value] forKey:key];
	[self writePreference];
}

- (BOOL)boolForKey:(NSString *)key {
	NSNumber *value = (NSNumber *)[dictionary objectForKey:key];
	if (value == nil) {
		return FALSE;
	}
	return (BOOL)[value boolValue];
}

- (void)setBoolValue:(BOOL)value forKey:(NSString*)key
{
	[dictionary setObject:[NSNumber numberWithBool:value] forKey:key];
	[self writePreference];
}

- (void)writePreference {
	[dictionary writeToURL:storeUrl atomically:TRUE];
}

- (void)setTop:(NSUInteger)v {
	if (v > self.top) {
		top = v;
		[dictionary setObject:[NSNumber numberWithUnsignedInteger:v] forKey:@"top"];
		[self writePreference];
	}
}

- (NSUInteger)top {
	NSNumber *value2 = (NSNumber *)[dictionary valueForKey:@"top"];
	if (value2 == nil) {
		return 0;
	}
	NSUInteger len = [value2 unsignedIntegerValue];
	return len;
}

@end
