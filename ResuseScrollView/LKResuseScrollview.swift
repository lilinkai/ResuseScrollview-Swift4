//
//  LKResuseScrollview.swift
//  ResuseScrollView
//
//  Created by 林凯李 on 2017/10/23.
//  Copyright © 2017年 林凯李. All rights reserved.
//

import UIKit

struct ImageShowModel {
    var imageUrls:[String]?                     //轮播图片URL数组
    var imageDescs:[String]?                    //轮播图片描述
    var jumpId:[Int]?                        //轮播图跳转id
    var jumpUrl:[String]?                       //轮播图跳转url
}

typealias SelectIndex = (Int)->Void

class LKResuseScrollview: UIScrollView {
    
    private let images:[UIImage]? = nil             //轮播图片获取
    private var imageModels:ImageShowModel          //图片点击跳转Model
    
    private var currentImageView:UIImageView!       //创建当前显示的imageview
    private var nextImageView:UIImageView!          //创建下一个显示的imageview
    
    private var currentIndex:Int = 0                //当前索引
    private var nextIndex:Int = 1                   //下一个索引
    
    private var timer:Timer!                        //timer循环对象
    private var selectIndex:SelectIndex!            //获取当前选中的索引值

    required public init(frame: CGRect, imgModels:ImageShowModel, clickIndex:@escaping SelectIndex) {
        
        imageModels = imgModels
        selectIndex = clickIndex
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.blue
        isPagingEnabled = true
        
        contentSize = CGSize(width: imageModels.imageUrls!.count*Int(frame.width), height: 0)
        contentOffset = CGPoint.init(x: frame.width, y: 0)
        delegate = self
        showsHorizontalScrollIndicator = false
        
        setUpTime()
        ConfigDataSource()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 根据数据配置轮播图
    ///
    /// - Parameter imgModel: 当前选中的数据
    private func ConfigDataSource(){
        
        guard imageModels.imageUrls != nil else{
            print("传入的图片url为空");
            return;
        }
        
        currentImageView = CreateImageView();
        currentImageView.frame.origin.x = frame.width;
        currentImageView.image = UIImage.init(named: imageModels.imageUrls![currentIndex]);
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(TapImageView))
        currentImageView.addGestureRecognizer(tapGesture)
        
        nextImageView = CreateImageView();
        nextImageView.frame.origin.x = 0;
        nextImageView.image = UIImage.init(named: imageModels.imageUrls![nextIndex]);

        currentIndex = 0
        
    }
    
    /// 点击了当前展示图片
    @objc private func TapImageView(){
        selectIndex(currentIndex)
    }
    
    /// 创建imageview
    private func CreateImageView()->UIImageView{
        let Cimageview = UIImageView.init(frame: CGRect.init(origin: CGPoint.zero, size: frame.size))
        Cimageview.contentMode = .scaleAspectFill
        Cimageview.clipsToBounds = true
        addSubview(Cimageview)
        Cimageview.isUserInteractionEnabled = true
        return Cimageview
    }
    
    /// 创建定时器
    private func setUpTime() {
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(automaticChangePage), userInfo: nil, repeats: true)
    }
    
    /// 释放定时器
    private func pauseTime(){
        timer?.invalidate()
        timer = nil
    }
    
    /// 自动换页
    @objc private func automaticChangePage() {
        setContentOffset(CGPoint(x: frame.width*2, y: 0), animated: true)
    }
    
    /// 最终交换显示与下一个显示图片复位到scrollView初始值
    private func changeNextImageView() {
        currentImageView.image = nextImageView.image
        contentOffset = CGPoint.init(x: frame.width, y: 0)
        currentIndex = nextIndex
    }
    
}

extension LKResuseScrollview:UIScrollViewDelegate{
    /// 滚动代理
    ///
    /// - Parameter scrollView: 当前scrollview
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offSetX = scrollView.contentOffset.x
        
        //判断滚动方向
        //右
        if(offSetX < frame.width){
            //移动nextimageview位置
            nextImageView.frame.origin.x = 0;
            
            //确定下一个索引
            nextIndex = currentIndex - 1
            
            if nextIndex < 0 {
                nextIndex = imageModels.imageUrls!.count - 1
            }
            
            nextImageView.image = UIImage.init(named: imageModels.imageUrls![nextIndex]);
            
            if(offSetX <= 0){
                changeNextImageView()
            }
        }else if(offSetX > frame.width){
            nextImageView.frame.origin.x = frame.width*2;
            nextIndex = (currentIndex + 1)%imageModels.imageUrls!.count
            
            nextImageView.image = UIImage.init(named: imageModels.imageUrls![nextIndex]);
            
            if offSetX >= frame.width*2 {
                changeNextImageView()
            }
        }
    }
    
    /// 拖拽开始定时器
    ///
    /// - Parameter scrollView: scrollviewObj
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        pauseTime()
    }
    
    /// 拖拽结束定时器
    ///
    /// - Parameters:
    ///   - scrollView: scrollviewObj
    ///   - decelerate: true/false
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool){
        setUpTime()
    }
}
