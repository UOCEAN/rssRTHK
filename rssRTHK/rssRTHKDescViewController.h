//
//  rssRTHKDescViewController.h
//  rssRTHK
//
//  Created by Chentou TONG on 21/2/14.
//  Copyright (c) 2014 Chentou TONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rssRTHKDescViewController : UITableViewController

- (IBAction)btnDone:(id)sender;

@property (nonatomic, weak) IBOutlet UITextView *descText;

@property (nonatomic, strong) NSString *descShow;
@property (nonatomic, strong) NSString *pubDateShow;

@end
