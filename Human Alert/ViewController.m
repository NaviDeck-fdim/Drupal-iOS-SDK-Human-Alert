//
//  ViewController.m
//  Human Alert
//
//  Created by Fotis Dimanidis on 26/11/14.
//  Copyright (c) 2014 navideck. All rights reserved.
//

#import "ViewController.h"
#import "DIOSNode.h"
#import "DIOSUser.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *idTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getNode:(id)sender {
    
    if ([_idTextField.text  isEqual:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter Node ID" delegate:self cancelButtonTitle:@"Return" otherButtonTitles:nil,nil];
        [alert show];
        return;
    }
    
    NSMutableDictionary *nodeData = [NSMutableDictionary new];
    [nodeData setValue:_idTextField.text forKey:@"nid"];
    [DIOSNode nodeGet:nodeData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //Get the title
        _titleTextField.text = [responseObject objectForKey:@"title"];
        
        //Get the description (aka body)
        NSDictionary *languageDict = [responseObject objectForKey:@"body"];
        if ([languageDict count]>0){    //In case body is empty
            NSArray *bodyValues = [languageDict objectForKey:@"und"];
            NSDictionary *descDict = [bodyValues objectAtIndex:0];
            _descTextField.text = [descDict objectForKey:@"value"];
        }
        
        //Get the address (custom field)
        if ([languageDict count]>0){    //In case body is empty
            NSDictionary *languageDict = [responseObject objectForKey:@"field_address"];  //Node the you need to add the "field_" prefix
            NSArray *bodyValues = [languageDict objectForKey:@"und"];
            NSDictionary *descDict = [bodyValues objectAtIndex:0];
            _addressTextField.text = [descDict objectForKey:@"value"];
        }
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil,nil];
        [alert show];
    }];

}

- (IBAction)updateNode:(id)sender {
    
    NSMutableDictionary *nodeData = [NSMutableDictionary new];
    
    //Set title
    [nodeData setObject:_titleTextField.text forKey:@"title"];
    
    //Set body
    NSDictionary *bodyValues = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:_descTextField.text, nil] forKeys:[NSArray arrayWithObjects:@"value", nil]];
    NSDictionary *languageDict = [NSDictionary dictionaryWithObject:[NSArray arrayWithObject:bodyValues] forKey:@"und"];
    [nodeData setObject:languageDict forKey:@"body"];
    [nodeData setObject:@"und" forKey:@"language"];
    
    //Set Node ID
    [nodeData setObject:_idTextField.text forKey:@"nid"];
    
    [DIOSNode nodeUpdate:nodeData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //Successful node update
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Operation successful!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //Failed to update the node
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil,nil];
        [alert show];
    }];
    
}

- (IBAction)createNode:(id)sender {
    
    NSMutableDictionary *nodeData = [NSMutableDictionary new];
    
    //Set title
    [nodeData setObject:_titleTextField.text forKey:@"title"];
    
    //Set body
    NSDictionary *bodyValues = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:_descTextField.text, nil] forKeys:[NSArray arrayWithObjects:@"value", nil]];
    NSDictionary *languageDict = [NSDictionary dictionaryWithObject:[NSArray arrayWithObject:bodyValues] forKey:@"und"];
    [nodeData setObject:languageDict forKey:@"body"];
    [nodeData setObject:@"und" forKey:@"language"];
    
    //Set Node type
    [nodeData setObject:@"homeless" forKey:@"type"];  //New node need type
    
    
    [DIOSNode nodeSave:nodeData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //Successful node update
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Operation successful!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //Failed to update the node
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil,nil];
        [alert show];
    }];
    
}


- (IBAction)login:(id)sender {
    [DIOSUser
     userLoginWithUsername:@"Api User"
     andPassword:@"5Wx3AXK94Asg"
     success:^(AFHTTPRequestOperation *op, id response) {
         /* Handle successful operation here */
         [_loginButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
     }
     failure:^(AFHTTPRequestOperation *op, NSError *err) {
         /* Handle operation failire here */
         [_loginButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
     }
     ];
}

#pragma mark - UI code
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //hide keyboard of autocomplete textfields when hitting "Done" on keyboard
    [textField resignFirstResponder];
    return NO;
}

@end
