//
//  OAuthUtil.m
//  FhoodTEst
//
//  Created by admin on 12/14/17.
//  Copyright © 2017 admin. All rights reserved.
//


#import "OAuthUtil.h"

NSString *const CoinbaseErrorDomain = @"CoinbaseErrorDomain";

typedef NS_ENUM(NSInteger, CoinbaseErrorCode) {
    CoinbaseOAuthError,
    CoinbaseServerErrorUnknown,
    CoinbaseServerErrorWithMessage
};

@implementation OAuthUtil

+ (NSString *)URLEncodedStringFromString:(NSString *)string
{
    static CFStringRef charset = CFSTR("!@#$%&*()+'\";:=,/?[] ");
    CFStringRef str = (__bridge CFStringRef)string;
    CFStringEncoding encoding = kCFStringEncodingUTF8;
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, str, NULL, charset, encoding));
}

+ (void)doOAuthPostToPath:(NSString *)path
               withParams:(NSDictionary *)params
               completion:(CoinbaseCompletionBlock)completion {
    
    NSURL *base = [NSURL URLWithString:@"oauth/" relativeToURL:[NSURL URLWithString:@"https://api.coinbase.com/"]];
    NSURL *url = [[NSURL URLWithString:path relativeToURL:base] absoluteURL];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // Create POST data (OAuth APIs only accept standard URL-format data, not JSON)
    NSMutableArray *components = [NSMutableArray new];
    NSString *encodedKey, *encodedValue;
    for (NSString *key in params) {
        encodedKey = [OAuthUtil URLEncodedStringFromString:key];
        encodedValue = [OAuthUtil URLEncodedStringFromString:[params objectForKey:key]];
        [components addObject:[NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue]];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSError *error = nil;
    NSData *data = [[components componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding];
    if (error) {
        completion(nil, error);
        return;
    }
    NSURLSessionUploadTask *task;
    task = [session uploadTaskWithRequest:request
                                 fromData:data
                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                            if (!error) {
                                NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                                NSDictionary *parsedBody = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                if (!error) {
                                    if ([parsedBody objectForKey:@"error"] || [httpResponse statusCode] > 300) {
                                        NSString *authentication = @"";
                                        if ([parsedBody objectForKey:@"2fa_authentication"] != nil) {
                                            authentication = [parsedBody objectForKey:@"2fa_authentication"];
                                        }
                                        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: [parsedBody objectForKey:@"error"], NSLocalizedRecoverySuggestionErrorKey: authentication };
                                        
                                        error = [NSError errorWithDomain:CoinbaseErrorDomain
                                                                    code:CoinbaseOAuthError
                                                                userInfo:userInfo];
                                    } else {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            completion(parsedBody, nil);
                                        });
                                        return;
                                    }
                                }
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completion(nil, error);
                            });
                        }];
    [task resume];
}

@end
