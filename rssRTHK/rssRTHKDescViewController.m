//
//  rssRTHKDescViewController.m
//  rssRTHK
//
//  Created by Chentou TONG on 21/2/14.
//  Copyright (c) 2014 Chentou TONG. All rights reserved.
//

#import "rssRTHKDescViewController.h"

@interface rssRTHKDescViewController ()

@end

@implementation rssRTHKDescViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.descText.text = [self.descShow stringByAppendingString:self.pubDateShow];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
  
}

- (IBAction)btnDone:(id)sender
{
  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
