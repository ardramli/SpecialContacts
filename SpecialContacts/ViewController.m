//
//  ViewController.m
//  SpecialContacts
//
//  Created by ardMac on 21/03/2017.
//  Copyright © 2017 ardMac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *contacts;
@property (strong,nonatomic) NSMutableArray *phoneNumbers;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swiper;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareContacts];
    [self prepareTableView];
    [self prepareButtons];
    self.textField.delegate = self;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareTableView {
    //[self.tableView setDataSource:self]; another way to do the below code
    self.tableView.dataSource = self; //set the datasource
    
}

-(void)prepareContacts {
    self.contacts = [@[@"kim",@"rock",@"naruto"] mutableCopy];//mutableCopy means i will create a mutable copy for this array, because array literals are not compatible with mutable array
    self.phoneNumbers = [@[@"0111111111",@"01222222222",@"012333333"] mutableCopy];
    
}

-(void)prepareButtons {
    [self.addButton addTarget:self action:@selector(buttonAddTapped) forControlEvents:UIControlEventTouchUpInside];
    
}

//-(void)addNewContacts {
//    NSString *contactName = self.textField.text;
//    [self.contacts addObject:contactName];
//    [self.tableView reloadData]; //to refresh table whenever you add new data into table
//    //not the most efficient
//    //but reloadData will re render everything. imagine if you have millions of data
//    //also can do it like below
//    //    self.tableView insertRowsAtIndexPaths:<#(nonnull NSArray<NSIndexPath *> *)#> withRowAnimation:<#(UITableViewRowAnimation)#>
//    
//}



#pragma mark - UITableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contacts.count; //this will determine number of rows
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell" forIndexPath:indexPath];
    
    [cell.textLabel setText:self.contacts[indexPath.row]];
    [cell.detailTextLabel setText:self.phoneNumbers[indexPath.row]];
    
    
    return cell;
}

-(void) buttonAddTapped {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add Contacts" message:@"please insert name" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * textField) { //to have textfield on alertcontroller
        textField.placeholder = @"Contact Name";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        
        
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * textField) {
        textField.placeholder = @"Phone Number";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        
        
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray *textfields = alertController.textFields;
        UITextField *nameField = textfields[0];
        UITextField *numberField = textfields[1];
        
        [self.contacts addObject:nameField.text];
        [self.phoneNumbers addObject:numberField.text];
        [self.tableView reloadData];
        
    }]];
    [self presentViewController:alertController animated:YES completion:NULL];
}

//below codes are for swipe left and delete contacts
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"delete contacts" message:@"you sure ah?" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        // remove the data from the array
        [self.contacts removeObjectAtIndex:indexPath.row];
        [self.phoneNumbers removeObjectAtIndex:indexPath.row];
        }
        //remove row from the tableview
//        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//        
    ]}
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {return;}


//edit button action
- (IBAction)editButtonTapped:(id)sender {
    [self.tableView setEditing:!self.tableView.editing];
}

//swipe right codes below
-(void)cellSwipe:(UISwipeGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_tableView];//where is the locaton you swiped
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:location];
    UITableViewCell *swipedCell  = [self.tableView cellForRowAtIndexPath:swipedIndexPath];
    [swipedCell.textLabel setTextColor:[UIColor redColor]]; //color should change to red
    
}

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
    [self cellSwipe:sender];
}

@end
