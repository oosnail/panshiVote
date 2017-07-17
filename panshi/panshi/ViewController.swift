//
//  ViewController.swift
//  panshi
//
//  Created by 张天琛 on 2017/7/11.
//  Copyright © 2017年 张天琛. All rights reserved.
//

import UIKit
import WebKit


//投票地址
let voteUrl = "http://pvote.a.stonevote.net/poll/xxxxxxxx.html"
//投票的id
let voteId = "op_xxxxxxx"



//需要投票id数组
let voteArr:[String] = ["op_3052976"]

class ViewController:
    
UIViewController ,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler{
    let mywebview = WKWebView()
    let websiteDataTypes:Set<String> = NSSet.init(array: [WKWebsiteDataTypeCookies,WKWebsiteDataTypeSessionStorage,WKWebsiteDataTypeLocalStorage,WKWebsiteDataTypeWebSQLDatabases,WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache]) as! Set<String>
    let nextbutton = UIButton()
    //自动投票
    var autoVote = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var voteNum = UserDefaults.standard.integer(forKey: "voteNum")
        
        
//        guard voteNum else{
//            voteNum = 0
//        }
        
        self.title = "已经投票\(voteNum)"
        
//        self.title = "给我投票吧"
        
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .yellow
        mywebview.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        //创建网址
        let url = URL.init(string:voteUrl)
        //创建请求
        let request = URLRequest.init(url: url! as URL)
        //加载请求
        mywebview.load(request)
        
        mywebview.uiDelegate = self
        mywebview.navigationDelegate = self
        //添加wkwebview
        self.view.addSubview(mywebview)
        
        nextbutton.frame = CGRect.init(x:  self.view.frame.width - 115, y: 60, width: 100, height: 50)
        nextbutton.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        nextbutton.addTarget(self, action: #selector(toupiao), for: .touchUpInside)
        nextbutton.setTitle("新的投票", for: .normal)
        self.view.addSubview(nextbutton)
        
        let button74 = UIButton()
        button74.frame = CGRect.init(x:  self.view.frame.width - 115, y: 460, width: 100, height: 50)
        button74.backgroundColor =  #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        button74.addTarget(self, action: #selector(scrollto74), for: .touchUpInside)
        button74.setTitle("滚到74", for: .normal)
        button74.setTitle("滚到验证码",for: .selected)
        self.view.addSubview(button74)
        
        let sbutton = UIButton()
        sbutton.frame = CGRect.init(x: self.view.frame.width - 115, y: 520, width: 100, height: 50)
        sbutton.backgroundColor =  #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        sbutton.addTarget(self, action: #selector(scrolltoend), for: .touchUpInside)
        sbutton.setTitle("投票", for: .normal)
        self.view.addSubview(sbutton)
        
        
        
        //清除缓存
        let date = NSDate.init(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: date as Date) {
        }
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //投票成功
        if (webView.url!.absoluteString .contains("voteurl=")){
            
            let voteNum = UserDefaults.standard.integer(forKey: "voteNum")
            UserDefaults.standard.set(voteNum + 1, forKey: "voteNum")
            toupiao(button: self.nextbutton)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //点击选项
        if autoVote{
            let Str1 = "$('#\(voteId) .iCheck-helper').trigger('click');$('html, body').animate({scrollTop: $('#inputCaptchacodeDiv').offset().top},0);"
            mywebview.evaluateJavaScript(Str1) { (make, error) in
                //            self.nextbutton.setTitle("加载完毕", for: .normal)
            }
        }
        
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.name)
        if(message.name == "mxBack"){
            
        }
    }
    
    func scrolltoend(button:UIButton){
        //点击了投票 就取消了当前页面自动投票机制
        autoVote = false
        let Str1 = "$('#\(voteId) .iCheck-helper').trigger('click');$('html, body').animate({scrollTop: $('#inputCaptchacodeDiv').offset().top},0);"
        mywebview.evaluateJavaScript(Str1) { (make, error) in
        }
    }
    
    func scrollto74(button:UIButton){
        button.isSelected = !button.isSelected
        if(!button.isSelected){
            //到验证码
            let Str1 = "$('html, body').animate({scrollTop: $('#inputCaptchacodeDiv').offset().top},0)"
            mywebview.evaluateJavaScript(Str1) { (make, error) in
            }
        }else{
            //到七十四
            let Str1 = "$('html, body').animate({scrollTop: $('#\(voteId)').offset().top}, 0);"
            mywebview.evaluateJavaScript(Str1) { (make, error) in
            }
        }
        
        
        
    }
    func toupiao(button:UIButton){
        //清除cookies
        
        let vc = ViewController()
        
        self.navigationController?.setViewControllers([self,vc], animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

