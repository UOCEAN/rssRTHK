//
//  Feed.h
//  rssRTHK
//
//  Created by Chentou TONG on 19/2/14.
//  Copyright (c) 2014 Chentou TONG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Feed : NSManagedObject

@property (nonatomic, retain) NSString * feedTitle;
@property (nonatomic, retain) NSString * feedLink;
@property (nonatomic, retain) NSString * feedDescription;
@property (nonatomic, retain) NSString * feedPubDate;
@property (nonatomic, retain) NSDate * feedDate;

@end
