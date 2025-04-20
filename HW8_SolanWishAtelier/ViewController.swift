//
//  ViewController.swift
//  HW8_SolanWishAtelier
//
//  Created by Kate Yeh on 2025/4/6.
//

import UIKit

//定義一個商品結構，每個商品有品名、價格、數量(放在class前)
struct WishItem{
    let name:String
    let price:Int
    var quantity:Int
}


//主畫面 ViewController，包含UIScrollView、三分頁的資料處理
class ViewController: UIViewController, UIScrollViewDelegate {
    

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //三個商品頁的Label陣列，用來顯示數量
    @IBOutlet var lmqLabels: [UILabel]!
    @IBOutlet var pcqLabels: [UILabel]!
    @IBOutlet var fbqLabels: [UILabel]!
    
    //三個商品頁的Stepper陣列，用來調整數量
    @IBOutlet var lmsteppers: [UIStepper]!
    @IBOutlet var pcsteppers: [UIStepper]!
    @IBOutlet var fbsteppers: [UIStepper]!
    
    //Love&Memory分頁的商品資料陣列
    var lmpageItems:[WishItem] = [
        WishItem(name:"真愛永不離棄", price: 580, quantity: 0),
        WishItem(name:"永遠有人懂你", price: 520, quantity: 0),
        WishItem(name:"重拾失去的友情", price: 490, quantity: 0),
        WishItem(name:"忘記某個人", price: 460, quantity: 0),
        WishItem(name:"寵物不會死去", price: 600, quantity: 0),
        WishItem(name:"重返某年某月某日", price: 750, quantity: 0)
    ]
    
    //Power&Contril分頁的商品資料陣列
    var pcpageItems:[WishItem] = [
        WishItem(name:"過目不忘的記憶力", price: 560, quantity: 0),
        WishItem(name:"讀心術", price: 620, quantity: 0),
        WishItem(name:"預知危機", price: 600, quantity: 0),
        WishItem(name:"操控他人情緒", price: 670, quantity: 0),
        WishItem(name:"掌控命運", price: 700, quantity: 0),
        WishItem(name:"無敵的個人魅力", price: 510, quantity: 0)
    ]
    
    //Fantasy&Beyond分頁的商品資料陣列
    var fbpageItems:[WishItem] = [
        WishItem(name:"看見宇宙真理", price: 780, quantity: 0),
        WishItem(name:"夢境中的自由世界", price: 600, quantity: 0),
        WishItem(name:"成為小說主角", price: 550, quantity: 0),
        WishItem(name:"無窮的資產", price: 950, quantity: 0),
        WishItem(name:"凍齡的美貌", price: 800, quantity: 0),
        WishItem(name:"一夕爆紅的名氣", price: 710, quantity: 0)
    ]
    
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var resteButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //指定目前ViewController(self)為scrollView的代理(delegate)
        //讓它可以"接收和處理"UIScrollViewDelegate協定中的事件
        scrollView.delegate = self
        //初始化時更新總金額
        updateTotal()
        
    }
    
    //計算目前scrollView顯示哪一頁(0.1.2)
    var currentPage: Int {
        return Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
    
    //點選SegmentControl切換頁面
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        let pageWidth = scrollView.frame.size.width
        let offset = CGPoint(x: pageWidth * CGFloat(sender.selectedSegmentIndex), y: 0)
        //使用動畫方式滑動scrollView到對應的位置
        scrollView.setContentOffset(offset, animated: true)
        //頁面變更時更新總金額
        updateTotal()
    }
    
    //使用者滑動結束後自動呼叫，以更新Segment裡的商品項目
    //是delegate協定的回呼方法
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        segmentedControl.selectedSegmentIndex = page
        //更新總金額
        updateTotal()
    }
    
    //使用者調整(增減)Stepper時更新數據
    @IBAction func stepperChanged(_ sender: UIStepper) {
        let index = sender.tag
        let value = Int(sender.value)
        
        switch currentPage {
        case 0:
            lmpageItems[index].quantity = value
            lmqLabels[index].text = "\(value)"
        case 1:
            pcpageItems[index].quantity = value
            pcqLabels[index].text = "\(value)"
        case 2:
            fbpageItems[index].quantity = value
            fbqLabels[index].text = "\(value)"
        default:
            break
        }
        
        updateTotal()
    }
    
    //計算三頁所選商品的總價
    func updateTotal(){
        var total = 0
        
        for item in lmpageItems {
            total += item.quantity * item.price
        }
        
        for item in pcpageItems {
            total += item.quantity * item.price
        }
        
        for item in fbpageItems {
            total += item.quantity * item.price
        }
        
        totalLabel.text = "\(total)"
    }
    
    
    //點reset按鈕時把所有數量清零(stepper、總價歸零)
    @IBAction func tapReset(_ sender: Any) {
        //所有商品數量歸0(有顯示在畫面上的)
        for i in 0..<lmpageItems.count {
            lmpageItems[i].quantity = 0
            lmqLabels[i].text = "0"
        }
        //所有Stepper數值歸0(沒有顯示在畫面上的)
        for i in 0..<pcpageItems.count {
            pcpageItems[i].quantity = 0
            pcqLabels[i].text = "0"
        }
        
        for i in 0..<fbpageItems.count {
            fbpageItems[i].quantity = 0
            fbqLabels[i].text = "0"
        }
        
        for stepper in lmsteppers {
            stepper.value = 0
        }
        
        for stepper in pcsteppers {
            stepper.value = 0
        }
        
        for stepper in fbsteppers {
            stepper.value = 0
        }
        
        updateTotal()
    }
    
  
    //顯示購物清單的Alert視窗，包括購買清單、數量、總金額
    @IBAction func tapBuy(_ sender: Any) {
        var message = ""
        var total = 0
        
        //加入有選擇的商品(數量>0)
        func addItem(from items: [WishItem]){
            for item in items {
                if item.quantity > 0 {
                    message += "\n\(item.name)\n \(item.quantity)件\n"
                    total += item.price * item.quantity
                }
            }
        }
        
        addItem(from: lmpageItems)
        addItem(from: pcpageItems)
        addItem(from: fbpageItems)
        
        //如果沒買東西，提示清單裡目前沒有東西
        if total == 0 {
            message += "Your shopping list is empty. 😢"
        }else{
            message += "\n Your total cost is \(total) Solan.💜"
        }
        
        //顯示Alert視窗
        let endMessage = UIAlertController(title: "Shopping List 🛒", message: message, preferredStyle: .alert)
        let checkAction = UIAlertAction(title: "Correct! ☑️", style: .default, handler: nil)
        endMessage.addAction(checkAction)
        present(endMessage, animated: true)
    }
    
   
}
    
