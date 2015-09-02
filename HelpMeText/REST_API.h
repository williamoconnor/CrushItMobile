//
//  REST_API.h
// CrushIt
//
//  Created by William O'Connor on 7/15/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONConverter.h"

@interface REST_API : NSObject

+ (NSDictionary*)getPath:(NSString*)resource;
+ (NSDictionary *)postPath:(NSString*)resource data:(NSString*)dataString;
+ (NSDictionary *)putPath:(NSString*)resource data:(NSString*)dataString;
+ (bool)testConnection:(NSString*)resource;


@end

