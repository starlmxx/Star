//
//  MessageSentDateTableViewCell.m
//  Star
//
//  Created by limingxing on 2/2/16.
//  Copyright © 2016 limingxing. All rights reserved.
//

#import "MessageSentDateTableViewCell.h"

@implementation MessageSentDateTableViewCell
{
    UILabel *_sentDateLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _sentDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _sentDateLabel.backgroundColor = [UIColor clearColor];
    _sentDateLabel.font = [UIFont systemFontOfSize:10.f];
    _sentDateLabel.textAlignment = NSTextAlignmentCenter;
    _sentDateLabel.textColor = [UIColor colorWithRed:142.f/255 green:142.f/255 blue:147.f/255 alpha:1.0];
    
    _sentDateLabel.frame = CGRectMake(0, 13, ScreenWidth, CGRectGetHeight(self.frame) - 13 - 4.5);
    
    [self.contentView addSubview:_sentDateLabel];
}

- (void)setSentDate:(NSString *)sentDate
{
    _sentDateLabel.text = sentDate;
}

@end
