//
//  MFile.h
//  mySOS
//
//  Created by Marco Velluto on 08/02/13.
//  Copyright (c) 2013 algos. All rights reserved.
//
///*** Creare un file String chiamato File.strings

#import <Foundation/Foundation.h>

static NSString * const KEY_EMAIL = @"email";
static NSString * const KEY_SMS = @"sms";

@interface MFile : NSObject

+ (void)writeWithObject:(NSObject *)obj andKey:(NSString *)key;
+ (void)writeDictionary:(NSDictionary *)dic;

+ (NSDictionary *)dictionaryWithString:(NSString *)name;
@end
