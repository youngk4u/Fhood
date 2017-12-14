//
//  OAuthUtil.h
//  FhoodTEst
//
//  Created by admin on 12/14/17.
//  Copyright © 2017 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CoinbaseCompletionBlock)(id response, NSError *error);

@interface OAuthUtil : NSObject

+ (NSString *)URLEncodedStringFromString:(NSString *)string;
+ (void)doOAuthPostToPath:(NSString *)path
               withParams:(NSDictionary *)params
               completion:(CoinbaseCompletionBlock)completion;
@end
