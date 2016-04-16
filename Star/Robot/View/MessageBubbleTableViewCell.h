//
//  MessageBubbleTableViewCell.h
//  Star
//
//  Created by limingxing on 2/2/16.
//  Copyright © 2016 limingxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageBubbleTableViewCell : UITableViewCell

- (CGFloat)cellHeight;
- (void)setMessageInfo:(NSString *)message isIncoming:(BOOL)inComing;

@end
