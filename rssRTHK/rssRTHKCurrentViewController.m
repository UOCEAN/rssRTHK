//
//  rssRTHKFirstViewController.m
//  rssRTHK
//
//  Created by Chentou TONG on 19/2/14.
//  Copyright (c) 2014 Chentou TONG. All rights reserved.
//

#import "rssRTHKCurrentViewController.h"
#import "Feed.h"
#import "FeedCell.h"

@interface rssRTHKCurrentViewController () <NSFetchedResultsControllerDelegate>

@end

@implementation rssRTHKCurrentViewController
{
    NSFetchedResultsController *_fetchedResultsController;
    
    NSXMLParser *_parser;
    NSMutableArray *_feeds;
    NSMutableArray *_OldFeeds;
    
    NSMutableDictionary *_item;
    NSMutableString *_title;
    NSMutableString *_link;
    NSMutableString *_description;
    NSMutableString *_pubDate;
    NSString *_element;
    
    BOOL _networkState;
    NSTimer *_timerFeed;
    
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Feed" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"feedDate" ascending:YES];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        
        [fetchRequest setFetchBatchSize:20];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Feed"];
        
        _fetchedResultsController.delegate = self;
    }
    return _fetchedResultsController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self performFetch];
    
    _feeds = [[NSMutableArray alloc] init];
    _OldFeeds = [[NSMutableArray alloc] init];
    // _timerFeed = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(refreshFeed) userInfo:nil repeats:NO];
    
    _networkState = TRUE;
    [self performSelector:@selector(refreshFeed) withObject:nil afterDelay:2.0];
    
}

- (void)refreshFeed
{
    if (_feeds.count == 0) {
        [self feedData];
    } else {
        [self feedData];
    }
}

- (void)feedData
{
    // show HubView
    // HudView *hudView = [HudView hudInView:self.navigationController.view animated:YES];
    // hudView = [HudView hudInView:self.navigationController.view animated:YES];
    // hudView.text =@"RSS Refresh";
    
    if (_networkState) {
        NSURL *url = [NSURL URLWithString:@"http://www.rthk.org.hk/rthk/news/rss/c_expressnews.xml"];
        
        _parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        
        [_parser setDelegate:self];
        [_parser setShouldResolveExternalEntities:NO];
        [_parser parse];
    } else {
        NSLog(@"Network unreachable");
    }
    
}


- (void)performFetch
{
    NSError *error;
    
    if (![self.fetchedResultsController performFetch:&error]) {
        FATAL_CORE_DATA_ERROR(error);
        return;
    }
}

- (void)dealloc
{
    _fetchedResultsController.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    FeedCell *feedcell = (FeedCell *)cell;
    Feed *feed = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([feed.feedTitle length] > 0) {
        feedcell.feedTitleLabel.text = feed.feedTitle;
    } else {
        feedcell.feedTitleLabel.text = @"(No News)";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Feed"];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"*** controllerWillChangeContent");
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            NSLog(@"*** NSFetchedResultsChangeInsert (object)");
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            NSLog(@"*** NSFetchedResultsChangeDelete (object)");
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            NSLog(@"*** NSFetchedResultsChangeUpdate (object)");
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            NSLog(@"*** NSFetchedResultsChangeMove (object)");
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            NSLog(@"*** NSFetchedResultsChangeInsert (section)");
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            NSLog(@"*** NSFetchedResultsChangeDelete (section)");
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"*** controllerDidChangeContent");
    [self.tableView endUpdates];
}


#pragma mark - NSXMLParser Delegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    _element = elementName;
    
    if ([_element isEqualToString:@"item"]) {
        _item    = [[NSMutableDictionary alloc] init];
        _title   = [[NSMutableString alloc] init];
        _link    = [[NSMutableString alloc] init];
        _description = [[NSMutableString alloc] init];
        _pubDate = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([_element isEqualToString:@"title"]) {
        [_title appendString:string];
    } else if ([_element isEqualToString:@"link"]) {
        [_link appendString:string];
    } else if ([_element isEqualToString:@"description"]) {
        NSString *foo = string;
        NSString *bar = [foo stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        [_description appendString:bar];
    } else if ([_element isEqualToString:@"pubDate"]) {
        NSString *foo = string;
        NSString *bar = [foo stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        [_pubDate appendString:bar];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        [_item setObject:_title forKey:@"title"];
        [_item setObject:_link forKey:@"link"];
        [_item setObject:_description forKey:@"description"];
        [_item setObject:_pubDate forKey:@"pubDate"];
        [_feeds addObject:[_item copy]];
        
        
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    // finish loading feed
    // NSLog(@"no of feeds: %lu", _feeds.count);
    
    // NSMutableDictionary *item;
    // item = [[NSMutableDictionary alloc] init];
    
    if (_OldFeeds.count !=0) {
        NSMutableDictionary *laItem;
        laItem = [[NSMutableDictionary alloc] init];
        laItem = [_OldFeeds firstObject];
        
        NSString *lastFirstPubDate = [laItem objectForKey:@"pubDate"];
        NSString *thisFirstPubDate = [[_feeds firstObject] objectForKey:@"pubDate"];
        NSString *thisPubDate;
        
        if ([lastFirstPubDate isEqualToString:thisFirstPubDate]) {
            NSLog(@"feed nil change");
        } else {
            NSLog(@"feed updated");
            
            
            NSUInteger count = 0;
            for (id object in _feeds)
            {
                count++;
                thisPubDate = [object objectForKey:@"pubDate"];
                NSLog(@"count: %lu, lastPubDate: %@, thisPubDate: %@", count, lastFirstPubDate, thisPubDate);
                
                if ([lastFirstPubDate isEqualToString:thisPubDate]) {
                    NSLog(@"feed found");
                    break;
                } else {
                    [_OldFeeds insertObject:object atIndex:0];
                    [self UpdateSQLite:_OldFeeds atIndex:_OldFeeds.count-1];
                }
            };
        }
    } else {
        for (id object in _feeds)
        {
            [_OldFeeds addObject:[object copy]];
            [self UpdateSQLite:_OldFeeds atIndex:_OldFeeds.count-1];
        };
        [self.tableView reloadData];
        NSLog(@"first");
        return;
    };
    [self.tableView reloadData];
    
}

- (void)UpdateSQLite:(NSMutableArray *)rxFeed atIndex:(NSUInteger)index
{
    Feed *feed = [NSEntityDescription insertNewObjectForEntityForName:@"Feed" inManagedObjectContext:self.managedObjectContext];
    feed.feedTitle = [[rxFeed objectAtIndex:index] objectForKey:@"title"];
    feed.feedDescription = [[rxFeed objectAtIndex:index] objectForKey:@"description"];
    feed.feedPubDate = [[rxFeed objectAtIndex:index] objectForKey:@"pubDate"];
    feed.feedLink = [[rxFeed objectAtIndex:index] objectForKey:@"link"];
    feed.feedDate = [NSDate date];
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error: %@", error);
        abort();
    }
}


@end
