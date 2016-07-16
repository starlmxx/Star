//
//  RobotViewController.m
//  Star
//
//  Created by limingxing on 1/9/16.
//  Copyright © 2016 limingxing. All rights reserved.
//

#import "RobotViewController.h"
#import "MessageBubbleTableViewCell.h"
#import "MessageSentDateTableViewCell.h"
#import <Parse/Parse.h>
#import "StudyViewController.h"
#import "AFNetworking.h"


static CGFloat messageFontSize  = 17;
static CGFloat toolBarMinHeight = 44;

@interface RobotViewController ()<UITextViewDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UILabel *_welComeLabel;
    
    UIView *_keyboardView;
    UITextView *textView;
    UIButton *sendButton;
    
    NSMutableArray *_messagesArray;
    NSMutableDictionary *_cacheCellSize;
    BOOL         _bIsKeyboardShow;       ///< 标示键盘是否在显示
    CGFloat      _keyboardChangeHeight;  ///< 键盘高度变化值
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RobotViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _messagesArray = [[NSMutableArray alloc] init];
    [self initData];
    [self setupView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setupView
{
    self.title = @"星星";
    [self initTableView];
    [self initBottomView];
    
}

- (void)initBottomView
{
    _keyboardView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - toolBarMinHeight+0.5, ScreenWidth, toolBarMinHeight-0.5)];
    _keyboardView.backgroundColor = [UIColor colorWithWhite:250.f/255 alpha:1.0];
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(8, 7.5, ScreenWidth-10-60, 28)];
    //textView.backgroundColor = [UIColor colorWithWhite:250.f/255 alpha:1.0];
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:messageFontSize];
    textView.layer.borderColor = [UIColor colorWithRed:200.f/255 green:200.f/255 blue:205.f/255 alpha:1.0].CGColor;
    textView.layer.borderWidth = 0.5;
    textView.layer.cornerRadius = 5;
    textView.scrollsToTop = false;
    textView.textContainerInset = UIEdgeInsetsMake(4, 3, 3, 3);
    [_keyboardView addSubview:textView];
    
    sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    sendButton.frame = CGRectMake(CGRectGetWidth(_keyboardView.frame)-60, 6, 60, 31);
    sendButton.enabled = YES;
    sendButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor colorWithRed:142.f/255 green:142.f/255 blue:147.f/255 alpha:1.0] forState:UIControlStateHighlighted];
    [sendButton setTitleColor:[UIColor colorWithRed:0.05 green:0.47 blue:0.91 alpha:1.0] forState:UIControlStateNormal];
    sendButton.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    [sendButton addTarget:self action:@selector(onSendMsgButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_keyboardView addSubview:sendButton];
    
    [self.view addSubview:_keyboardView];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAllKeyboard)];
    tapGR.delegate = self;
    [self.view addGestureRecognizer:tapGR];
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - toolBarMinHeight)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    //self.tableView.estimatedRowHeight = 44;
    //self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 43.5, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
}

- (void)initData
{
    _cacheCellSize = [[NSMutableDictionary alloc] init];
    
    PFQuery *query = [[PFQuery alloc] initWithClassName:@"Messages"];
    [query orderByAscending:@"sentDate"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        //        BOOL inComing = objects ;
        //        NSString *text = objects[@"text"];
        //        NSDate *sendDate = objects["sentDate"];
        for (PFObject *object in objects) {
            
            
            NSLog(@"incoming: %@\n", object[@"incoming"]);
            NSLog(@"text: %@\n", object[@"text"]);
            NSLog(@"sentDate: %@\n", object[@"sentDate"]);
        }
        
        _messagesArray = [NSMutableArray arrayWithArray:objects];
        [self.tableView reloadData];
    }];
}

#pragma mark - Common Methods

- (void)tableViewScrollToBottomAnimated:(BOOL)animated
{
    //NSInteger sections = _messagesArray.count;
    //NSInteger rows = _messagesArray[sections-1].count;
}

- (void)getResponseFromTuling:(NSString *)msg
{
    NSDictionary *parameterDict = @{@"key":TULING_API_KEY, @"info":msg, @"userid":TULING_USER_ID};
    
    NSURL *URL = [NSURL URLWithString:TULING_API_URL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:parameterDict progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        
        PFObject *response = [PFObject objectWithClassName:@"Message" dictionary:@{@"incoming":@"1", @"text": responseDict[@"text"], @"sentDate":[NSDate date]}];
        
        [_messagesArray addObject:response];
        [self.tableView reloadData];
        NSInteger sections = [self.tableView numberOfSections];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:sections-1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - UITextViewDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}


#pragma mark - UIGestureRecognizerDelegate

- (void)hideAllKeyboard
{
    [textView resignFirstResponder];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _messagesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *pfObject = [_messagesArray objectAtIndex:indexPath.section];
    
    if (indexPath.row == 0) {
        NSString *cellIdentifier = NSStringFromClass([MessageSentDateTableViewCell class]);
        MessageSentDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[MessageSentDateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        NSDate *date = pfObject[@"sentDate"];
        [cell setSentDate:[date description]];
        
        return cell;
    } else {
        NSString *cellIdentifier = NSStringFromClass([MessageBubbleTableViewCell class]);
        MessageBubbleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[MessageBubbleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        NSString *text = pfObject[@"text"];
        BOOL inComing = [pfObject[@"incoming"] boolValue];
    
        [cell setMessageInfo:text isIncoming:inComing];
        NSLog(@"================text =  %@, inComing ===== %d, cellHeight : %.2f", text, inComing, [cell cellHeight]);
        NSString *key = [pfObject objectId];
        if (key == nil) {
            key = pfObject[@"text"];
        }
        [_cacheCellSize setObject:[NSNumber numberWithFloat:[cell cellHeight]] forKey:key];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    id cell = [tableView cellForRowAtIndexPath:indexPath];
//    if ([cell isKindOfClass:[MessageBubbleTableViewCell class]]) {
//        return [cell cellHeight] > 44 ? [cell cellHeight] : 44;
//    }
    if (indexPath.row == 0) {
        return 44;
    }
    
    PFObject *object = [_messagesArray objectAtIndex:indexPath.section];
    CGFloat cellHeght = [[_cacheCellSize objectForKey:object.objectId] floatValue];
    return cellHeght;
}

#pragma mark - Notification

- (void)keyboardWillShow:(NSNotification *)notification
{
    if (!_bIsKeyboardShow) {
        _bIsKeyboardShow = YES;
        NSDictionary *keyboardInfo = notification.userInfo;
        CGRect keyboardBounds = [keyboardInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        _keyboardChangeHeight = keyboardBounds.size.height;
        
        CGRect frame = _tableView.frame;
        frame.origin.y -= _keyboardChangeHeight;
        _tableView.frame = frame;
        
        // 已经在底部时不滚动
        if ([_messagesArray count] > 0 && _tableView.contentSize.height > _tableView.bounds.size.height + _tableView.contentOffset.y)
        {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:1 inSection:[_messagesArray count]-1];
            [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        /*
         Reduce the size of the text view so that it's not obscured by the keyboard.
         Animate the resize so that it's in sync with the appearance of the keyboard.
         */
        
        // transform the UIViewAnimationCurve to a UIViewAnimationOptions mask
        UIViewAnimationCurve animationCurve = [keyboardInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
        UIViewAnimationOptions animationOptions = UIViewAnimationOptionBeginFromCurrentState;
        if (animationCurve == UIViewAnimationCurveEaseIn) {
            animationOptions |= UIViewAnimationOptionCurveEaseIn;
        }
        else if (animationCurve == UIViewAnimationCurveEaseInOut) {
            animationOptions |= UIViewAnimationOptionCurveEaseInOut;
        }
        else if (animationCurve == UIViewAnimationCurveEaseOut) {
            animationOptions |= UIViewAnimationOptionCurveEaseOut;
        }
        else if (animationCurve == UIViewAnimationCurveLinear) {
            animationOptions |= UIViewAnimationOptionCurveLinear;
        }
        
        
        NSTimeInterval animationDuration = [[keyboardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        [UIView animateWithDuration:animationDuration
                              delay:0
                            options:animationOptions
                         animations:^{
                             _keyboardView.transform = CGAffineTransformMakeTranslation(0, -_keyboardChangeHeight);
                         }
                         completion:nil];
        
        // now that the frame has changed, move to the selection or point of edit
        NSRange selectedRange = textView.selectedRange;
        [textView scrollRangeToVisible:selectedRange];
    }
}

- (void)keyboardWillHide:(NSNotification *)notificaton
{
    if (_bIsKeyboardShow) {
        _bIsKeyboardShow = NO;
        
        CGRect frame = _tableView.frame;
        frame.origin.y += _keyboardChangeHeight;
        _tableView.frame = frame;
        
        _keyboardView.transform = CGAffineTransformIdentity;
    }
}

#pragma mark - Event Handler

- (void)onSendMsgButtonPressed:(id)sender
{
    StudyViewController *studyVC = [[StudyViewController alloc] init];
    [self.navigationController pushViewController:studyVC animated:YES];
    
//    [self getResponseFromTuling:textView.text];
//    
//    PFObject *response = [PFObject objectWithClassName:@"Message" dictionary:@{@"incoming":@"0", @"text": textView.text, @"sentDate":[NSDate date]}];
//    response.objectId = [NSString stringWithFormat:@"%@%@", [textView.text substringToIndex:2], [[NSDate date] description]];
//    
//    [_messagesArray addObject:response];
//    [self.tableView reloadData];
    
//    NSInteger sections = [self.tableView numberOfSections];
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:sections-1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


@end
