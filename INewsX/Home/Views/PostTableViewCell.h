

#import <UIKit/UIKit.h>
#import "SHNewsInfoModel.h"

@interface PostTableViewCell : UITableViewCell

@property (nonatomic, strong) SHNewsInfoModel *newsModel;

+ (CGFloat)heightForCellWithPost:(SHNewsInfoModel *)newsModel;

@end
