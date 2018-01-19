//
//  ViewController.m
//  TableViewTest
//
//  Created by Gleb Arkhipov on 11/01/2018.
//  Copyright © 2018 Gleb Arkhipov. All rights reserved.
//

#import "ViewController.h"

/**
 *
 * The app creates a table view with one cell, with a subview hierarchy as follows:
 * Cell                              // UITableViewCell subclass
 * ⌞ UITableViewCellContentView      // standard one, untouched
 *   ⌞ ContainerView (yellow)        // snapped to content view edges
 *     ⌞ Label (green)               // snapped to container view layout margins
 * 
 * HOW TO USE:
 * - Launch on iPhone X.
 * - Observe: label has no extra padding (green background).
 * - Rotate to landscape.
 * - Observe: label is truncated
 *    - Expected: label should take two lines as it's AutomaticDimension and numberOfLines = 0
 * - Rotate back to portrait.
 * - Observe: label gets extra top and bottom padding
 *    - Expected: label should have no extra padding, like just after launching.
 * 
 */

#pragma mark - Container

@interface Label : UILabel
@end

@implementation Label

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor greenColor];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.font = [UIFont systemFontOfSize:20];
    self.text = @"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor.";
    self.numberOfLines = 0;
    return self;
}

@end

#pragma mark - Container

@interface ContainerView: UIView
@property (nonatomic, strong) Label* label;
@end

@implementation ContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    _label = [[Label alloc] initWithFrame:CGRectZero];
    [self addSubview:_label];
    
    // snap label to the container's layout margins
    UILayoutGuide *margins = self.layoutMarginsGuide;
    NSArray *constraints = @[
                             [self.label.topAnchor constraintEqualToAnchor:margins.topAnchor],
                             [self.label.leftAnchor constraintEqualToAnchor:margins.leftAnchor],
                             [self.label.bottomAnchor constraintEqualToAnchor:margins.bottomAnchor],
                             [self.label.rightAnchor constraintEqualToAnchor:margins.rightAnchor],
                             ];
    [self addConstraints:constraints];

    return self;
}

@end

#pragma mark - Cell

@interface Cell: UITableViewCell
@property (nonatomic, strong) ContainerView* containerView;
@end

@implementation Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _containerView = [[ContainerView alloc] initWithFrame:self.contentView.bounds];
    _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    _containerView.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:_containerView];

    // snap container to cell content view
    NSArray *containerViewConstraints = @[
                                          [self.containerView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
                                          [self.containerView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor],
                                          [self.containerView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
                                          [self.containerView.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor],
                                          ];
    [self.contentView addConstraints:containerViewConstraints];

    return self;
}

@end

#pragma mark - ViewController

@interface ViewController () <UITableViewDataSource>
@property (nonatomic, strong) UITableView* tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.insetsContentViewsToSafeArea = NO;
    [self.tableView registerClass:[Cell class] forCellReuseIdentifier:@"CellID"];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
}

@end
