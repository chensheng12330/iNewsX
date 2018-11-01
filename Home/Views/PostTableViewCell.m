
#import "PostTableViewCell.h"

#import "User.h"

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIView+Extension.h"
#import "AppDelegate.h"

#define DT_SIZE 15.f
#define TT_SIZE 12.f

@interface PostTableViewCell ()
@property (nonatomic,strong) UILabel *lbDate; //日期
@end

@implementation PostTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.textLabel.textColor = UIColorWithHEX(0x5050f3);
    self.detailTextLabel.font = [UIFont systemFontOfSize:DT_SIZE];
    self.detailTextLabel.numberOfLines = 0;
    //self.detailTextLabel.textColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.5];
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    self.lbDate = [[UILabel alloc] init];
    [_lbDate setFont:[UIFont systemFontOfSize:9.0f]];
    _lbDate.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3f];
    [_lbDate setTextColor:[UIColor whiteColor]];
    [_lbDate setTextAlignment:NSTextAlignmentCenter];
    //_lbDate.alpha = 0.8f;
    [self addSubview:_lbDate];

    UILabel *line =  [[UILabel alloc] init];
    line.backgroundColor = [COM randColorWithAlpha:0.55f];;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(5);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    return self;
}

- (void)setNewsModel:(SHNewsInfoModel *)post {
    _newsModel = post;

    self.textLabel.text = _newsModel.title;
    self.detailTextLabel.text = _newsModel.digest;


    if (COM.appDelegate.isNeedImage) {
        [self.imageView setImageWithURL:[NSURL URLWithString:_newsModel.imgsrc] placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
    }
    else {
        [self.imageView setImage:[UIImage imageNamed:@"profile-image-placeholder"]];
    }


    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.layer.borderWidth = 1.f;
    self.imageView.layer.borderColor = [UIColor grayColor].CGColor;
    
    _lbDate.text = [_newsModel.ptime componentsSeparatedByString:@" "].firstObject;
    
    [self setNeedsLayout];
}

+ (CGFloat)heightForCellWithPost:(SHNewsInfoModel *)newsModel
{
    return (CGFloat)fmaxf(70.0f, (float)[self detailTextHeight:newsModel.digest] + 45.0f);
}

+ (CGFloat)detailTextHeight:(NSString *)text {
    CGRect rectToFit = [text boundingRectWithSize:CGSizeMake(([UIScreen mainScreen].bounds.size.width-80), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:DT_SIZE]} context:nil];
    return rectToFit.size.height;
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //float centerY =
    
    CGFloat height = [PostTableViewCell heightForCellWithPost:self.newsModel];
    
    self.imageView.frame = CGRectMake(5.0f, 5.0f, 60.0f, 70.0f);
    self.imageView.centerY = height/2.0f;
    self.textLabel.frame = CGRectMake(70.0f, 6.0f, ([UIScreen mainScreen].bounds.size.width-80), 20.0f);
    
    CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 0.0f, 25.0f);
    CGFloat calculatedHeight = [[self class] detailTextHeight:self.newsModel.digest];
    detailTextLabelFrame.size.height = calculatedHeight;
    self.detailTextLabel.frame = detailTextLabelFrame;
    
    
    ///
    CGRect lbRect = CGRectMake(self.imageView.left, self.imageView.bottom-18.f, self.imageView.width, 18.f);
    [_lbDate setFrame:lbRect];
}

@end
