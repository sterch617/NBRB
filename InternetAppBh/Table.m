//
//  Table.m
//  InternetAppBh
//
//  Created by Admin on 08.05.14.
//  Copyright (c) 2014 x25. All rights reserved.
//

#import "Table.h"
#import "ViewController.h"
@interface Table ()

@end

@implementation Table
@synthesize news;
@synthesize currentElement;
@synthesize currentTitle;
@synthesize pubDate;
@synthesize arrData;
@synthesize rssData;
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
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
#pragma mark - Date to String

    NSDate *dateToday =[NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd/yyyy"];
    NSString *currDate = [format stringFromDate:dateToday]; //Дата в формате НБРБ ММ/ДД/ГГГГ
    
    
    
    NSString *url =@"http://www.nbrb.by/Services/XmlExRates.aspx?ondate="; //Первая часть строки от адреса
    NSString *curUrl=[NSString stringWithFormat:@"%@%@",url,currDate]; //Прибавляем корректную дату к строке    
    
    
    NSURL *urlNB = [NSURL URLWithString:curUrl];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:urlNB cachePolicy:NSURLRequestUseProtocolCachePolicy                   timeoutInterval:60.0];
    NSURLConnection *theConection =[[NSURLConnection alloc]initWithRequest:theRequest delegate:self];
    if (theConection) {
        self.rssData=[NSMutableData data];
    }
    else {
        NSLog(@"Connection Feiled");
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - TabbleView of XML

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [rssData appendData:data];
    
}


-(void)connectionDidFinishLoading: (NSURLConnection *)connection{
    NSString *result = [[NSString alloc] initWithData:rssData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",result);
    self.news = [NSMutableArray array];
    NSXMLParser *rssParser = [[NSXMLParser alloc] initWithData:rssData];
    rssParser.delegate  = self;
    [rssParser parse];

}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict  {
    
    self.currentElement = elementName;
    if ([elementName isEqualToString:@"Currency"]) {
        self.currentTitle = [NSMutableString string];
        self.pubDate = [NSMutableString string];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"Currency"]) {
        NSDictionary *newsItem = [NSDictionary dictionaryWithObjectsAndKeys:
                                  currentTitle, @"Name",
                                  pubDate, @"Rate", nil];
        [news addObject:newsItem];
        self.currentTitle = nil;
        self.pubDate = nil;
        self.currentElement = nil;
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([currentElement isEqualToString:@"Name"]) {
		[currentTitle appendString:string];
	} else if ([currentElement isEqualToString:@"Rate"]) {
		[pubDate appendString:string];
    }
}


- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return news.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *newsItem = [news objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [newsItem objectForKey:@"Name"];
    
    cell.detailTextLabel.text = [newsItem objectForKey:@"Rate"];

    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/




// In a storyboard-based application, you will often want to do a little preparation before navigation
/* - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ViewController *vc = [segue destinationViewController];
    UITableViewCell *cell = (UITableViewCell*)sender;
    vc.myText= cell.textLabel.text;
} */


@end
