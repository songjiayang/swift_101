import UIKit
import MediaPlayer
import QuartzCore

class ViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate,HttpProtocol,ChannelProtocol{
                            
    @IBOutlet var iv: UIImageView
    @IBOutlet var tv: UITableView
    @IBOutlet var progressView: UIProgressView
    @IBOutlet var playTime: UILabel
    @IBOutlet var btnPlay:UIImageView
    @IBOutlet var tap:UITapGestureRecognizer=nil

    var eHttp:HttpController = HttpController()
    var tableData:NSArray=NSArray()
    var channelData:NSArray=NSArray()
    var imageCache=Dictionary<String,UIImage>()
    var audioPlayer:MPMoviePlayerController=MPMoviePlayerController();
    var timer:NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eHttp.delegate=self
        eHttp.onSearch("http://www.douban.com/j/app/radio/channels")
        eHttp.onSearch("http://douban.fm/j/mine/playlist?channel=0")
        progressView.progress=0.0
        iv.addGestureRecognizer(tap)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        var channelC:ChannelController=segue.destinationViewController as ChannelController
        channelC.delegate=self
        channelC.channelData=self.channelData
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int{
        return tableData.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        let cell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "douban")
        let rowData:NSDictionary=self.tableData[indexPath.row] as NSDictionary
        cell.text=rowData["title"] as String
        cell.detailTextLabel.text=rowData["artist"] as String
        cell.image=UIImage(named:"detail.jpg")
        let url=rowData["picture"] as String
        let image=self.imageCache[url] as? UIImage
        if !image?{
            let imgURL:NSURL=NSURL(string:url)
            let request:NSURLRequest=NSURLRequest(URL:imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response:NSURLResponse!,data:NSData!,error:NSError!)->Void in
                let img=UIImage(data:data)
                cell.image=img
                self.imageCache[url]=img
                
            })
        }else {
            cell.image=image
        }
        return cell
    }
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
 
        var rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        var audioUrl:String = rowData["url"] as String
        onSetAudio(audioUrl)
        let imgUrl:String=rowData["picture"] as String
        onSetImage(imgUrl)
        
    }
    
    func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!){
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform=CATransform3DMakeScale(1, 1, 1)
            })
    }
    
    func didRecieveResults(results:NSDictionary){
        if results["song"] {
            self.tableData=results["song"] as NSArray
            self.tv.reloadData()
            
            let firDict:NSDictionary=self.tableData[0] as NSDictionary
            let audioUrl:String=firDict["url"] as String
            onSetAudio(audioUrl)
            let imgUrl:String=firDict["picture"] as String
            onSetImage(imgUrl)
            
        }else if results["channels"]{
            self.channelData=results["channels"] as NSArray
            
        }
    }
    func onSetAudio(url:String){
        timer?.invalidate()
        playTime.text="00:00"
        self.audioPlayer.stop()
        self.audioPlayer.contentURL=NSURL(string:url)
        self.audioPlayer.play()
        timer=NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "onUpdate", userInfo: nil, repeats: true)
        btnPlay.removeGestureRecognizer(tap)
        iv.addGestureRecognizer(tap)
		btnPlay.hidden=true
    }
    func onUpdate(){
        let c=audioPlayer.currentPlaybackTime
        if c>0.0 {
            let t=audioPlayer.duration
            let p:CFloat=CFloat(c/t)
            progressView.setProgress(p, animated: true)
            
            let all:Int=Int(c)
            let m:Int=all % 60
            let f:Int=Int(all/60)
            var time:String=""
            if f<10{
                time="0\(f):"
            }else {
                time="\(f)"
            }
            if m<10{
                time+="0\(m)"
            }else {
                time+="\(m)"
            }
            playTime.text=time
        }
    }
    func onSetImage(url:String){
        let image=self.imageCache[url] as? UIImage
        if !image?{
            let imgURL:NSURL=NSURL(string:url)
            let request:NSURLRequest=NSURLRequest(URL:imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response:NSURLResponse!,data:NSData!,error:NSError!)->Void in
                let img=UIImage(data:data)
                self.iv.image=img
                self.imageCache[url]=img
                
                })
        }else {
           self.iv.image=image
        }
    }
    func onChangeChannel(channel:String){
        let url:String="http://douban.fm/j/mine/playlist?\(channel)"
        eHttp.onSearch(url)
    }
    @IBAction func onTap(recognizer: UITapGestureRecognizer){
        if recognizer.view==btnPlay {
            btnPlay.hidden=true
            audioPlayer.play()
            btnPlay.removeGestureRecognizer(tap)
            iv.addGestureRecognizer(tap)
        }else if recognizer.view==iv {
            btnPlay.hidden=false
            audioPlayer.pause()
            btnPlay.addGestureRecognizer(tap)
            iv.removeGestureRecognizer(tap)
        }
    }

}

