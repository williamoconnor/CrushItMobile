//
//  JSONConverter.h
// CrushIt
//
//  Created by William O'Connor on 7/15/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONConverter : NSObject

+ (NSString *)convertNSMutableDictionaryToJSON:(NSMutableDictionary *)dictionary;
+ (NSString*)convertNSDictionaryToJSON:(NSDictionary *)dictionary;
+ (NSDictionary*)convertNSDataToNSDictionary:(NSData *)data;
+ (NSMutableDictionary *)convertJSONToNSDictionary:(NSString *)json;

@end
