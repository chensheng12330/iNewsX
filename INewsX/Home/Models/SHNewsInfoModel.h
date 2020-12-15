

#import <Foundation/Foundation.h>

@class User;

/*
 "votecount": 100,
 "docid": "DUT7S56F05118J2I",
 "aheadBody": "素有“中国飞人”之称的苏炳添在第18届亚运会田径男子100米决赛中，以9秒92的成绩打破赛会纪录夺得冠军。谁曾想，这位拥有飞毛腿的中国健将，与短跑结缘竟只是为了逃避留校补课。初中时期，苏炳添和其他处于...",
 "url_3w": "",
 "source": "泛观察",
 "postid": "DUT7S56F05118J2I",
 "ua": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:63.0) Gecko/20100101 Firefox/63.0",
 "priority": 60,
 "title": "逃避留校补课竟逃出了个“亚洲飞人” ——苏炳添",
 "mtime": "2018-10-24 16:37:25",
 "url": "",
 "replyCount": 102,
 "subtitle": "",
 "digest": "素有“中国飞人”之称的苏炳添在第18届亚运会田径男子100米决赛中，以9秒92的成绩打破赛会纪录夺得冠军。谁曾想，这位拥有飞毛腿的中国健将，与短跑结缘竟只是为了",
 "boardid": "dy_wemedia_bbs",
 "imgsrc": "http://dingyue.nosdn.127.net/etQWnLyLaGLslZOdrbJ5dGvNpKLAdTHHtCP040AqBnLtS1540370069920.png",
 "ptime": "2018-10-24 16:36:38",
 "pixel": "533*300",
 "daynum": "17828"
 */

@class SHNewsInfoModel;
@protocol SHNewsInfoModel;
@class SHNewsInfoResponse;

@interface SHNewsBaseResponse : JSONModel

@property (nonatomic, strong) SHNewsInfoResponse<Optional> *data;

@end


@interface SHNewsInfoResponse : JSONModel

@property (nonatomic, strong) NSArray<SHNewsInfoModel,Optional> *tab_list;

@end

@interface SHNewsInfoModel : JSONModel

@property (nonatomic, strong) NSString <Optional>*digest;
@property (nonatomic, strong) NSString <Optional>*title;
@property (nonatomic, strong) NSString <Optional>*docid;
@property (nonatomic, strong) NSString <Optional>*url_3w;
@property (nonatomic, strong) NSString <Optional>*source;
@property (nonatomic, strong) NSString <Optional>*imgsrc;
@property (nonatomic, strong) NSString <Optional>*ptime;

@end
