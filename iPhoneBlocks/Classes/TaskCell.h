//
//  TaskCell.h
//  iPhoneBlocks
//
//  Created by Vyacheslav Zakovyrya on 1/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TaskCell : UITableViewCell {
    IBOutlet UIActivityIndicatorView *activity;
    IBOutlet UILabel *label;
}

@property (retain) UIActivityIndicatorView *activity;
@property (retain, nonatomic) UILabel *label;

@end