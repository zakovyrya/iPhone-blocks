#import "RootViewController.h"
#import "AlertViewAdditions.h"
#import "CollectionsAdditions.h"
#import "BlocksAdditions.h"

@implementation RootViewController

@synthesize taskCell;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (BOOL)showAlert:(TaskCell *)cell {
    UIAlertView *view = [[[UIAlertView alloc] initWithTitle:@"alert" message:@"hi! this is going to be an alert message" delegate:nil cancelButtonTitle:@"dismiss" otherButtonTitles:@"duh!", nil] autorelease];
    
    [view showOnTapDo:[[^(NSInteger buttonIndex) {
        NSLog(@"clicked button with index %i", buttonIndex);
        [cell.activity stopAnimating];
    } copy] autorelease]];
    
    return NO;
}

- (BOOL)collections:(TaskCell *)cell {
    NSArray *testArr = [NSArray arrayWithObjects:@"1", @"2", @"3", nil];
    [testArr do:^(id obj) {
        NSLog(@"do: %@", obj);
    }];
    
    NSLog(@"select: %@", [testArr select:^BOOL(id obj) {
        return [obj intValue] > 1;
    }]);
    
    NSLog(@"map: %@", [testArr map:^(id obj) {
        return [NSString stringWithFormat:@"<%@>", obj];
    }]);
    
    return YES;
}

- (BOOL)threadsAndLocks:(TaskCell *)cell {
    InBackground(^{
        WithAutoreleasePool(^{
            NSLog(@"curent thread: %@, main thread: %@", [NSThread currentThread], [NSThread mainThread]);
            
            OnMainThread(YES, ^{
                NSLog(@"current thread: %@, main thread: %@", [NSThread currentThread], [NSThread mainThread]);
                
                AfterDelay(1, ^{
                    NSLog(@"after delay");
                    [cell.activity stopAnimating];
                });
            });
        });
    });
    NSLock *lock = [[[NSLock alloc] init] autorelease];
    [lock whileLocked:^{
        NSLog(@"locked");
    }];
    
    return NO;
}

- (BOOL)parallel:(TaskCell *)cell {
    Parallelized(20, ^(int i) {
        NSLog(@"iteration: %d", i);
    });
    
    return YES;
}

- (BOOL)url:(TaskCell *)cell {
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]];
    [NSURLConnection sendAsynchronousRequest:req onCompletionDo: ^(NSData *data, NSURLResponse *res, NSError *err) {
        NSLog(@"data: %ld bytes. res: %@, error: %@", (long)[data length], res, err);
        [cell.activity stopAnimating];
    }];
    
    return NO;
}

- (void)awakeFromNib {
    rows = $arr(
                $arr(@"show alert", @"showAlert:"),
                $arr(@"collections utils", @"collections:"),
                $arr(@"threads and locks", @"threadsAndLocks:"),
                $arr(@"do in parallel", @"parallel:"),
                $arr(@"fetch url", @"url:"),
                );
    [rows retain];
    
    [[NSNotificationCenter defaultCenter] addObserverBlock:^(NSNotification *note) {
        NSLog(@"did become active");
    } forName:UIApplicationDidBecomeActiveNotification];
    [[NSNotificationCenter defaultCenter] addObserverBlock:^(NSNotification *note) {
        NSLog(@"will resign active");
    } forName:UIApplicationWillResignActiveNotification];
    
    NSString *s1 = [NSMutableString string];
    CFStringRef s2 = (void *)[NSMutableString string];
    NSLog(@"%d %d", [s1 retainCount], [(id)s2 retainCount]);
    id block = ^ {
        s1, s2;
    };
    block = [block copy];
    NSLog(@"%d %d", [s1 retainCount], [(id)s2 retainCount]);
    [block release];
    NSLog(@"%d %d", [s1 retainCount], [(id)s2 retainCount]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [rows count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"TaskCell";
    
    TaskCell *cell = (TaskCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"TaskCell" owner:self options:nil];
        cell = self.taskCell;
    }
    
    cell.label.text = [[rows objectAtIndex:indexPath.row] objectAtIndex:0];
    	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskCell *cell = (TaskCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (![cell.activity isAnimating]) {
        SEL sel = NSSelectorFromString([[rows objectAtIndex:indexPath.row] objectAtIndex:1]);
        [cell.activity startAnimating];
        if ([self performSelector:sel withObject:cell]) {
            [cell.activity stopAnimating];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
    self.taskCell = nil;
    [rows release];
    
    [super dealloc];
}


@end

