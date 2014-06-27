//
//  RDMasterViewController.h
//  OfficeRadar
//
//  Created by Traun Leyden on 6/27/14.
//  Copyright (c) 2014 Couchbase Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RDDetailViewController;

@interface RDMasterViewController : UITableViewController

@property (strong, nonatomic) RDDetailViewController *detailViewController;

@end
