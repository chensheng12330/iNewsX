//
//  SHBaseResponse.h
//  INewsX
//
//  Created by sherwin.chen on 2018/10/20.
//  Copyright © 2018 sherwin.chen. All rights reserved.
//

@interface SHBaseResponse : JSONModel

@property (nonatomic, copy)  NSString <Optional>*status;
@property (nonatomic, copy)  NSString <Optional>*message;

/**  是否是成功的状态码  */
- (BOOL)OKStatus;

@end


@interface SHBaseResponseEX : SHBaseResponse

@property (nonatomic, copy)  NSDictionary <Optional>*data;

@end
