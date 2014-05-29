//
//  Table.h
//  InternetAppBh
//
//  Created by Admin on 08.05.14.
//  Copyright (c) 2014 x25. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Table : UITableViewController
{
    NSArray *arrData;
    NSMutableData *rssData;
    NSMutableArray *news;
    NSString * currentElement;
    NSMutableString *currentTitle;
    NSMutableString *pubDate;

}
@property (strong, nonatomic) NSMutableData *rssData;
@property(strong, nonatomic) NSArray* arrData;
@property(strong, nonatomic) NSMutableArray *news;
@property(strong, nonatomic) NSString * currentElement;
@property(strong, nonatomic) NSMutableString *currentTitle;
@property(strong, nonatomic) NSMutableString *pubDate;
@end
