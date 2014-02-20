//
//  rssRTHKFirstViewController.h
//  rssRTHK
//
//  Created by Chentou TONG on 19/2/14.
//  Copyright (c) 2014 Chentou TONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rssRTHKCurrentViewController : UITableViewController <NSXMLParserDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
