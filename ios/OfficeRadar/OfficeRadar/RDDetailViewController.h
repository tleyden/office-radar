//
//  RDDetailViewController.h
//  OfficeRadar
//
//  Created by Traun Leyden on 6/27/14.
//  Copyright (c) 2014 Couchbase Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
