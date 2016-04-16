//
//  MessageBubbleTableViewCell.m
//  Star
//
//  Created by limingxing on 2/2/16.
//  Copyright © 2016 limingxing. All rights reserved.
//

#import "MessageBubbleTableViewCell.h"

@implementation MessageBubbleTableViewCell
{
    UIImageView *_bubbleImageView;
    UILabel *_messageLabel;
    
    UIImage *_inComingImage;
    UIImage *_inComingHightedImage;
    UIImage *_outGoingImage;
    UIImage *_outGoingHightedImage;
}

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCommonImages];
        [self setupView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initCommonImages
{
    UIImage *maskOutgoing = [UIImage imageNamed:@"BubbleMessage"];
    UIImage *maskIncoming = [UIImage imageWithCGImage:maskOutgoing.CGImage scale:2.f orientation:UIImageOrientationUpMirrored];
    UIEdgeInsets capInsetsIncoming = UIEdgeInsetsMake(17, 26.5, 17.5, 21);
    UIEdgeInsets capInsetsOutgoing = UIEdgeInsetsMake(17, 21, 17.5, 26.5);
    
    _inComingImage = [[self coloredImage:maskIncoming red:229.f/255 green:229.f/255 blue:234.f/255 alpha:1.0] resizableImageWithCapInsets:capInsetsIncoming];
    _inComingHightedImage = [[self coloredImage:maskOutgoing red:206.f/255 green:206.f/255 blue:210.f/255 alpha:1.0] resizableImageWithCapInsets:capInsetsOutgoing];
    
    _outGoingImage = [[self coloredImage:maskOutgoing red:0.05 green:0.47 blue:0.91 alpha:1.0] resizableImageWithCapInsets:capInsetsOutgoing];
    _outGoingHightedImage = [[self coloredImage:maskOutgoing red:32.f/255 green:96.f/255 blue:200.f/255 alpha:1.0] resizableImageWithCapInsets:capInsetsOutgoing];
}

- (void)setupView
{
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, CGRectGetHeight(self.frame))];
    _messageLabel.textColor = [UIColor blackColor];
    _messageLabel.font = [UIFont systemFontOfSize:17.f];
    _messageLabel.numberOfLines = 0;
    _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _messageLabel.userInteractionEnabled = NO;
    
    _bubbleImageView = [[UIImageView alloc] initWithImage:_inComingImage highlightedImage:_inComingHightedImage];
    _bubbleImageView.tag = 8;
    _bubbleImageView.userInteractionEnabled = YES;
    _bubbleImageView.frame = CGRectMake(0, 0, 100, 0);
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:_bubbleImageView];
    [self.contentView addSubview:_messageLabel];
}

- (void)setOutgoingImage
{
    _bubbleImageView.image = _outGoingImage;
    _bubbleImageView.highlightedImage = _outGoingHightedImage;
}

- (void)setIncomingImage
{
    _bubbleImageView.image = _inComingImage;
    _bubbleImageView.highlightedImage = _inComingHightedImage;
}

- (UIImage *)coloredImage:(UIImage *)rawImage red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    CGRect rect = CGRectMake(0, 0, rawImage.size.width, rawImage.size.height);
    UIGraphicsBeginImageContextWithOptions(rawImage.size, NO, rawImage.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [rawImage drawInRect:rect];
    CGContextSetRGBFillColor(context, red, green, blue, alpha);
    CGContextSetBlendMode(context, kCGBlendModeSourceAtop);
    CGContextFillRect(context, rect);
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return retImage;
}

- (CGFloat)cellHeight
{
    return _bubbleImageView.frame.size.height;
}

- (void)setMessageInfo:(NSString *)message isIncoming:(BOOL)inComing
{
    _messageLabel.text = message;
    CGSize size = [_messageLabel.text boundingRectWithSize:CGSizeMake(ScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_messageLabel.font} context:nil].size;
    CGRect msgFrame = _messageLabel.frame;
    CGRect bubbleFrame = _bubbleImageView.frame;
    msgFrame.size.width = size.width;
    msgFrame.size.height = size.height;
    
    bubbleFrame.size.width = size.width + 15;
    bubbleFrame.size.height = size.height + 20;
    
    if (!inComing) {
        msgFrame.origin.x = ScreenWidth-msgFrame.size.width - 10;
        _messageLabel.frame = msgFrame;
        
        bubbleFrame.origin.x = ScreenWidth - size.width - 15;
        _bubbleImageView.frame = bubbleFrame;
        
        [self setOutgoingImage];
    } else {
        msgFrame.origin.x = 15;
        _messageLabel.frame = msgFrame;
        
        bubbleFrame.origin.x = 5;
        _bubbleImageView.frame = bubbleFrame;
        
        [self setIncomingImage];
    }
}

@end
