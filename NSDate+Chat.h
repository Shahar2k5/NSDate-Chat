//
//  NSDate+Chat.h
//  Pelebit
//
//  Created by Shahar Barsheshet on 26/10/2015.
//  Copyright © 2015 PeleBit. All rights reserved.
//

#define stringWithFormat(format, ...) \
    [NSString stringWithFormat:format, ##__VA_ARGS__]

#import <Foundation/Foundation.h>

@interface NSDate (Chat)
- (NSString*)chatDate;
- (NSString*)chatDateWithOrdinal:(BOOL)useOrdinal monthLength:(int)minLength;

@end
