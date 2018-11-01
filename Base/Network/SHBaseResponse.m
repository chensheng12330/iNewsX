//
//  SHBaseResponse.m
//  INewsX
//
//  Created by sherwin.chen on 2018/10/20.
//  Copyright © 2018 sherwin.chen. All rights reserved.
//

#import "SHBaseResponse.h"

@implementation SHBaseResponse

- (BOOL)OKStatus
{
    if (self.status==NULL || self.status.length<1 || ![self.status isEqualToString:@"0"] ) {
        return NO;
    }
    
    return YES;
}

@end


@implementation SHBaseResponseEX

@end
