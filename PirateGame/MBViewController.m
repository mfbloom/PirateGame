//
//  MBViewController.m
//  PirateGame
//
//  Created by Michael Bloom on 5/29/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "MBViewController.h"
#import "MBFactory.h"
#import "MBTile.h"

@interface MBViewController ()

@end

@implementation MBViewController

// - this loads initially on launch 
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.northButton.layer.cornerRadius = 10;
    self.southButton.layer.cornerRadius = 10;
    self.eastButton.layer.cornerRadius = 10;
    self.westButton.layer.cornerRadius = 10;
    self.resetGameButton.layer.cornerRadius = 10;
    //self.backgroundImage.image = [UIImage imageNamed:@"PirateStart.jpg"];
    
   MBFactory *factory = [[MBFactory alloc] init];//initialize the factory to create the arrays
   self.tiles = [factory tiles]; //load the tiles
    self.currentPoint = CGPointMake(0,0); //set initial starting point as 0,0
    self.character = [factory character];
    self.boss = [factory boss];
    
    [self updateCharacterStatsForArmor:nil withWeapons:nil withHealthEffect:0];
    [self updateTile];
    [self updateButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - Helper Methods
// - loads the correct story to the view space
// - this method is not in the header file, because no other implemtnation will need access
- (void)updateTile
{
    MBTile *tileModel = [[self.tiles objectAtIndex:self.currentPoint.x] objectAtIndex:self.currentPoint.y];
    
    self.storyLabel.text    =   tileModel.story;
    self.backgroundImage.image = tileModel.backgroundImage;
    self.healthLabel.text   =   [NSString stringWithFormat:@"%i",self.character.health];
    self.damageLabel.text   =   [NSString stringWithFormat:@"%i",self.character.damage];
    self.armorLabel.text    =   self.character.armor.name;
    self.weaponLabel.text   =   self.character.weapon.name;
    [self.actionButton setTitle:tileModel.actionButtonName forState:UIControlStateNormal];

}

// - this method is not in the header file, because no other implemtnation will need access
// - only show buttons if they are on the map...
-(void)updateButtons
{
    self.westButton.hidden = [self tileExistsAtPoint:CGPointMake(self.currentPoint.x-1, self.currentPoint.y)];
    self.eastButton.hidden = [self tileExistsAtPoint:CGPointMake(self.currentPoint.x+1, self.currentPoint.y)];
    self.northButton.hidden =[self tileExistsAtPoint:CGPointMake(self.currentPoint.x, self.currentPoint.y+1)];
    self.southButton.hidden =[self tileExistsAtPoint:CGPointMake(self.currentPoint.x, self.currentPoint.y-1)];
}

// - return yes or no if CGPoint is valid
- (BOOL)tileExistsAtPoint:(CGPoint)point

{
    if(point.y >= 0 && point.x >= 0 && point.x < [self.tiles count] && point.y < [[self.tiles objectAtIndex:point.x] count]) return NO;

    else return YES;
}
-(void)updateCharacterStatsForArmor:(MBArmor *)armor withWeapons:(MBWeapon *)weapon withHealthEffect:(int)healthEffect
{
    if (armor != nil)
    {
        self.character.health = self.character.health - self.character.armor.health + armor.health;
        self.character.armor = armor;
    }
        else if (weapon != nil){
            
            self.character.damage = self.character.damage - self.character.weapon.damage + weapon.damage;
            
            self.character.weapon = weapon;
            
        }
        
        else if (healthEffect != 0){
            
            self.character.health = self.character.health + healthEffect;
            
        }
        
        else {
            
            self.character.health = self.character.health + self.character.armor.health;
            
            self.character.damage = self.character.damage + self.character.weapon.damage;
            
        }
    }

#pragma mark - Buttons
- (IBAction)actionButtonPressed:(UIButton *)sender
{
    MBTile *tile = [[self.tiles objectAtIndex:self.currentPoint.x]objectAtIndex:self.currentPoint.y];
    
    if (tile.healthEffect == -15) self.boss.health = self.boss.health - self.character.damage;
    
    [self updateCharacterStatsForArmor:tile.armor withWeapons:tile.weapon withHealthEffect:tile.healthEffect];
    [self updateTile];
    
    if (self.character.health <= 0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Death" message:@"You have died...restart the game!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [alertView show];
        
    }
    
    else if (self.boss.health <= 0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Victory"message:@"You killed the evil pirate boss!" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [alertView show];
        
    }
    
}



- (IBAction)northButtonPressed:(UIButton *)sender {
    self.currentPoint = CGPointMake(self.currentPoint.x, self.currentPoint.y+1);
    
    [self updateButtons];
    
    [self updateTile];
}

- (IBAction)westButtonPressed:(UIButton *)sender {
    self.currentPoint = CGPointMake(self.currentPoint.x-1, self.currentPoint.y);
    
    [self updateButtons];
    
    [self updateTile];
}

- (IBAction)eastButtonPressed:(UIButton *)sender {
    self.currentPoint = CGPointMake(self.currentPoint.x+1, self.currentPoint.y);
    
    [self updateButtons];
    
    [self updateTile];
}

- (IBAction)southButtonPressed:(UIButton *)sender {
    self.currentPoint = CGPointMake(self.currentPoint.x, self.currentPoint.y-1);
    
    [self updateButtons];
    
    [self updateTile];
}

- (IBAction)resetGamePressed:(UIButton *)sender {
    self.character = nil;
    self.boss = nil;
    [self viewDidLoad];
}
@end
