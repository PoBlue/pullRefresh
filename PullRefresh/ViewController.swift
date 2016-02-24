//
//  ViewController.swift
//  PullRefresh
//
//  Created by Gabriel Theodoropoulos on 6/6/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var tblDemo: UITableView!
    var refreshControl: UIRefreshControl!
    var customView: UIView!
    var timer:NSTimer!
    
    var isAnimating = false
    var currentColorIndex = 0
    var currentLabelIndex = 0
    
    var labelsArray: Array<UILabel> = []
    
    var dataArray: Array<String> = ["One","Two","Three","Four","Five"]
    
    func insertLoveData(){
        let lastIndexpath = NSIndexPath(forRow: dataArray.count, inSection: 0)
        dataArray.append("其实我也喜欢你")
        
        tblDemo.beginUpdates()
        tblDemo.insertRowsAtIndexPaths([lastIndexpath], withRowAnimation: .Middle)
        tblDemo.endUpdates()
    }
    
    func doSomething(){
        timer = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: "endOfWork", userInfo: nil, repeats: true)
    }
    
    func endOfWork(){
        refreshControl.endRefreshing()
        
        timer.invalidate()
        timer = nil
        insertLoveData()
    }
    
    func loadCustomRefreshContens(){
        let refreshContents = NSBundle.mainBundle().loadNibNamed("RefreshContents", owner: self, options: nil)
        
        customView = refreshContents[0] as! UIView
        customView.frame = refreshControl.bounds
        
        for var i=0; i < customView.subviews.count; ++i{
            labelsArray.append(customView.viewWithTag(i + 1) as! UILabel)
        }
        
        refreshControl.addSubview(customView)
    }
    
    func animateRefreshStep1(){
        isAnimating = true
        
        UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveLinear, animations: {
                self.labelsArray[self.currentLabelIndex].transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
            self.labelsArray[self.currentLabelIndex].textColor = self.getNextColor()
            
            
        }, completion: {(finished) -> Void in
            UIView.animateWithDuration(0.05, delay: 0.0, options: .CurveLinear, animations: {
                    self.labelsArray[self.currentLabelIndex].transform = CGAffineTransformIdentity
                self.labelsArray[self.currentLabelIndex].textColor = UIColor.blackColor()
                
                }, completion: {(fin) -> Void in
                    ++self.currentLabelIndex
                    
                    if self.currentLabelIndex < self.labelsArray.count{
                        self.animateRefreshStep1()
                    }
                    else{
                        self.animateRefreshStep2()
                    }
                
                }
            )
        })
    }
    
    func animateRefreshStep2(){
        UIView.animateWithDuration(0.35, delay: 0.0, options: .CurveLinear, animations: {
                self.labelsArray[0].transform = CGAffineTransformMakeScale(1.5,1.5)
                self.labelsArray[1].transform = CGAffineTransformMakeScale(1.5,1.5)
                self.labelsArray[2].transform = CGAffineTransformMakeScale(1.5,1.5)
                self.labelsArray[3].transform = CGAffineTransformMakeScale(1.5,1.5)
                self.labelsArray[4].transform = CGAffineTransformMakeScale(1.5,1.5)
                self.labelsArray[5].transform = CGAffineTransformMakeScale(1.5,1.5)
                self.labelsArray[6].transform = CGAffineTransformMakeScale(1.5,1.5)
            
            
            }, completion: {(fin) -> Void in
                UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveLinear, animations: {
                        self.labelsArray[0].transform = CGAffineTransformIdentity
                        self.labelsArray[1].transform = CGAffineTransformIdentity
                        self.labelsArray[2].transform = CGAffineTransformIdentity
                        self.labelsArray[3].transform = CGAffineTransformIdentity
                        self.labelsArray[4].transform = CGAffineTransformIdentity
                        self.labelsArray[5].transform = CGAffineTransformIdentity
                        self.labelsArray[6].transform = CGAffineTransformIdentity
                    
                    }, completion: {(fin) -> Void in
                        if self.refreshControl.refreshing{
                            self.currentLabelIndex = 0
                            self.animateRefreshStep1()
                        }else{
                            self.isAnimating  = false
                            self.currentLabelIndex = 0
                            for var i = 0; i<self.labelsArray.count; ++i{
                                self.labelsArray[i].textColor = UIColor.blackColor()
                                self.labelsArray[i].transform = CGAffineTransformIdentity
                            }
                        }
                })
        
        })
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if refreshControl.refreshing{
            if !isAnimating{
                doSomething()   
                animateRefreshStep1()
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("\(scrollView.contentOffset)")
    }
    
    func getNextColor() -> UIColor{
        var colorsArray: Array<UIColor> = [UIColor.magentaColor(),UIColor.brownColor(),UIColor.yellowColor(),UIColor.redColor(),UIColor.greenColor(),UIColor.blueColor(),UIColor.orangeColor()]
        if currentColorIndex == colorsArray.count{
            currentColorIndex = 0
        }
        
        let returnColor = colorsArray[currentColorIndex]
        ++currentColorIndex
        
        return returnColor
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tblDemo.delegate = self
        tblDemo.dataSource = self
        
        refreshControl = UIRefreshControl()
        
        refreshControl.backgroundColor = UIColor.redColor()
        refreshControl.tintColor = UIColor.yellowColor()
        
        loadCustomRefreshContens()
        
        tblDemo.addSubview(refreshControl)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCell", forIndexPath: indexPath)
        cell.textLabel!.text = dataArray[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }


}

