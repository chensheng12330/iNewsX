// TweetTableViewCell.m
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "PostTableViewCell.h"

#import "Post.h"
#import "User.h"

#import "UIImageView+AFNetworking.h"
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
    self.textLabel.textColor = [UIColor darkGrayColor];
    self.detailTextLabel.font = [UIFont systemFontOfSize:DT_SIZE];
    self.detailTextLabel.numberOfLines = 0;
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    self.lbDate = [[UILabel alloc] init];
    [_lbDate setFont:[UIFont systemFontOfSize:9.0f]];
    _lbDate.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3f];
    [_lbDate setTextColor:[UIColor whiteColor]];
    [_lbDate setTextAlignment:NSTextAlignmentCenter];
    //_lbDate.alpha = 0.8f;
    [self addSubview:_lbDate];
    return self;
}

- (void)setPost:(Post *)post {
    _post = post;

    self.textLabel.text = _post.title;
    self.detailTextLabel.text = _post.digest;
    [self.imageView setImageWithURL:[NSURL URLWithString:_post.imgsrc] placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"] isNeed:((AppDelegate*)[UIApplication sharedApplication].delegate).isNeedImage];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.layer.borderWidth = 1.f;
    self.imageView.layer.borderColor = [UIColor grayColor].CGColor;
    
    
    _lbDate.text = [_post.ptime componentsSeparatedByString:@" "].firstObject;
    
    [self setNeedsLayout];
}

+ (CGFloat)heightForCellWithPost:(Post *)post {
    return (CGFloat)fmaxf(70.0f, (float)[self detailTextHeight:post.digest] + 45.0f);
}

+ (CGFloat)detailTextHeight:(NSString *)text {
    CGRect rectToFit = [text boundingRectWithSize:CGSizeMake(([UIScreen mainScreen].bounds.size.width-80), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:DT_SIZE]} context:nil];
    return rectToFit.size.height;
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //float centerY =
    
    CGFloat height = [PostTableViewCell heightForCellWithPost:self.post];
    
    self.imageView.frame = CGRectMake(5.0f, 5.0f, 60.0f, 70.0f);
    self.imageView.centerY = height/2.0f;
    self.textLabel.frame = CGRectMake(70.0f, 6.0f, ([UIScreen mainScreen].bounds.size.width-80), 20.0f);
    
    CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 0.0f, 25.0f);
    CGFloat calculatedHeight = [[self class] detailTextHeight:self.post.digest];
    detailTextLabelFrame.size.height = calculatedHeight;
    self.detailTextLabel.frame = detailTextLabelFrame;
    
    
    ///
    CGRect lbRect = CGRectMake(self.imageView.left, self.imageView.bottom-18.f, self.imageView.width, 18.f);
    [_lbDate setFrame:lbRect];
}

@end
