//
//  AvancesTableViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 7/10/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON
class AvancesTableViewController: UITableViewController {
    @IBOutlet weak var pesoChart: LineChartView!
    @IBOutlet weak var estaturaChart: UIView!
    @IBOutlet weak var mesesView: UIView!
    
    @IBOutlet weak var mineralesChart: UIView!
    
    @IBOutlet weak var actChart: UIView!
    
    var lineChartEntry = [ChartDataEntry]()
   
    @IBOutlet weak var rcc: UIView!
    @IBOutlet weak var imcChart: UIView!
    
    @IBOutlet weak var pgcChart: UIView!
    
    @IBOutlet weak var mgcChart: UIView!
    @IBOutlet weak var mmeChart: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setEstaturaChart()
        self.setMineralesChart()
        self.setPeso()
        self.setActChart()
        self.setMgcChart()
        self.setRccChart()
        self.setMmeChart()
        self.setPgcChart()
        self.setImcChart()
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
        //attributes for the first part of the string
        
        let firstAttr = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //attributes for the second part of the string
        
        //initializing the attributed string and appending the two parts together
        let attrString = NSMutableAttributedString(string: "WELLNESS TEST", attributes: firstAttr)
        //setting the attributed string as an attributed text
        titleLabel.attributedText = attrString
        
        //finding the bounds of the attributed text and resizing the label accordingly
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
        titleLabel.frame.size = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size
        
        //setting the label as the title view of the navigation bar
        navigationItem.titleView = titleLabel
        
        var a : CGFloat = 0
        var xValue = self.mesesView.bounds.width / CGFloat(APIManager.sharedInstance.mes.count)
        for month in APIManager.sharedInstance.mes{
            let label : UILabel = UILabel(frame: CGRect(x: xValue * a, y: 0, width: xValue, height: 20))
            label.textColor = UIColor.white
            label.font = UIFont(name: "LarkeNeue-Regular", size: 15)
            
            print("pikktiiiaa")
            label.contentMode = .center
            label.text = month
            
            self.mesesView.addSubview(label)
            a = a + 1.0
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    var countTemp : Int = 0
    func addLine(fromPoint start: CGPoint, toPoint: CGPoint,viewGraph : UIView){
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: toPoint)
        line.path = linePath.cgPath
        line.strokeColor = UIColor.red.cgColor
        line.lineWidth = 2
        line.lineJoin = kCALineJoinRound
        viewGraph.layer.addSublayer(line)
        
        var dotPath = UIBezierPath(ovalIn: CGRect(x: start.x - 2.5, y: start.y - 2.5, width: 5, height: 5 ))
        
        var layer = CAShapeLayer()
        layer.path = dotPath.cgPath
        layer.strokeColor = UIColor.red.cgColor
        layer.backgroundColor = UIColor.red.cgColor
        layer.lineWidth = 5
        viewGraph.layer.addSublayer(layer)
        
        dotPath = UIBezierPath(ovalIn: CGRect(x: toPoint.x - 2.5, y: toPoint.y - 2.5, width: 5, height: 5 ))
        
        layer = CAShapeLayer()
        layer.path = dotPath.cgPath
        layer.lineWidth = 5
        layer.backgroundColor = UIColor.red.cgColor
        layer.strokeColor = UIColor.red.cgColor
        
        viewGraph.layer.addSublayer(layer)
        
        countTemp = countTemp + 1
        print(countTemp)
    }
    
    func addPoint(fromPoint start: CGPoint,viewGraph : UIView){
        
        let dotPath = UIBezierPath(ovalIn: CGRect(x: start.x - 2.5, y: start.y - 2.5, width: 5, height: 5 ))
        
        let layer = CAShapeLayer()
        layer.path = dotPath.cgPath
        layer.strokeColor = UIColor.red.cgColor
        layer.backgroundColor = UIColor.red.cgColor
        layer.lineWidth = 5
        viewGraph.layer.addSublayer(layer)
        
        countTemp = countTemp + 1
        print(countTemp)
    }
    func setPeso() {
        var months = APIManager.sharedInstance.mes
        let numbers = APIManager.sharedInstance.pesoInbody2
        var inbodyValues = ["peso"]
        if(numbers.count > 1){
            for i in 0..<(numbers.count - 1) {
                let value = ChartDataEntry(x: Double(i), y: numbers[i])
                lineChartEntry.append(value)
                addLine(fromPoint: CGPoint(x: ((pesoChart.bounds.width / CGFloat( numbers.count)) * CGFloat(i)), y: ((CGFloat(numbers[i]) / CGFloat(numbers.max()! * 1.10) * pesoChart.bounds.height ))), toPoint: CGPoint(x: ((pesoChart.bounds.width / CGFloat( numbers.count)) * CGFloat(i + 1)), y: ((CGFloat(numbers[i + 1]) / CGFloat(numbers.max()! * 1.10) * pesoChart.bounds.height ))), viewGraph: pesoChart)
            }
        }else if(numbers.count == 1){
            addPoint(fromPoint: CGPoint(x: ((pesoChart.bounds.width / CGFloat( numbers.count)) * CGFloat(0)), y: ((CGFloat(numbers[0]) / CGFloat(numbers.max()! * 1.10) * pesoChart.bounds.height ))), viewGraph: pesoChart)
        }
  
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 9
    }
    
    func setEstaturaChart() {
        var months = APIManager.sharedInstance.mes
        let numbers = APIManager.sharedInstance.estaturaInbody2
        var inbodyValues = ["estatura"]
        if(numbers.count > 1){
            for i in 0..<(numbers.count - 1) {
                let value = ChartDataEntry(x: Double(i), y: numbers[i])
                lineChartEntry.append(value)
                addLine(fromPoint: CGPoint(x: ((estaturaChart.bounds.width / CGFloat( numbers.count)) * CGFloat(i)), y: ((CGFloat(numbers[i]) / CGFloat(numbers.max()! * 1.10) * estaturaChart.bounds.height ))), toPoint: CGPoint(x: ((estaturaChart.bounds.width / CGFloat( numbers.count)) * CGFloat(i + 1)), y: ((CGFloat(numbers[i + 1]) / CGFloat(numbers.max()! * 1.10) * estaturaChart.bounds.height ))), viewGraph: estaturaChart)
            }
        }else if(numbers.count == 1){
            addPoint(fromPoint: CGPoint(x: ((estaturaChart.bounds.width / CGFloat( numbers.count)) * CGFloat(0)), y: ((CGFloat(numbers[0]) / CGFloat(numbers.max()! * 1.10) * estaturaChart.bounds.height ))), viewGraph: estaturaChart)
        }
    }
    func setMineralesChart() {
        var months = APIManager.sharedInstance.mes
        let numbers = APIManager.sharedInstance.mineralesInbody2
        var inbodyValues = ["minerales"]
        if(numbers.count > 1){
            for i in 0..<(numbers.count - 1) {
                let value = ChartDataEntry(x: Double(i), y: numbers[i])
                lineChartEntry.append(value)
                addLine(fromPoint: CGPoint(x: ((mineralesChart.bounds.width / CGFloat( numbers.count)) * CGFloat(i)), y: ((CGFloat(numbers[i]) / CGFloat(numbers.max()! * 1.10) * mineralesChart.bounds.height ))), toPoint: CGPoint(x: ((mineralesChart.bounds.width / CGFloat( numbers.count)) * CGFloat(i + 1)), y: ((CGFloat(numbers[i + 1]) / CGFloat(numbers.max()! * 1.10) * mineralesChart.bounds.height ))), viewGraph: mineralesChart)
            }
        }else if(numbers.count == 1){
            addPoint(fromPoint: CGPoint(x: ((mineralesChart.bounds.width / CGFloat( numbers.count)) * CGFloat(0)), y: ((CGFloat(numbers[0]) / CGFloat(numbers.max()! * 1.10) * mineralesChart.bounds.height ))), viewGraph: mineralesChart)
        }
        
     
    }
    
    func setActChart() {
        var months = APIManager.sharedInstance.mes
        let numbers = APIManager.sharedInstance.actInbody2
        var inbodyValuesAct = ["act"]
        if(numbers.count > 1){
            for i in 0..<(numbers.count - 1) {
                let value = ChartDataEntry(x: Double(i), y: numbers[i])
                lineChartEntry.append(value)
                addLine(fromPoint: CGPoint(x: ((actChart.bounds.width / CGFloat( numbers.count)) * CGFloat(i)), y: ((CGFloat(numbers[i]) / CGFloat(numbers.max()! * 1.10) * actChart.bounds.height ))), toPoint: CGPoint(x: ((actChart.bounds.width / CGFloat( numbers.count)) * CGFloat(i + 1)), y: ((CGFloat(numbers[i + 1]) / CGFloat(numbers.max()! * 1.10) * actChart.bounds.height ))), viewGraph: actChart)
            }
        }else if(numbers.count == 1){
            addPoint(fromPoint: CGPoint(x: ((actChart.bounds.width / CGFloat( numbers.count)) * CGFloat(0)), y: ((CGFloat(numbers[0]) / CGFloat(numbers.max()! * 1.10) * actChart.bounds.height ))), viewGraph: actChart)
        }
        
        
        
        
    }
    func setMgcChart () {
        var months = APIManager.sharedInstance.mes
        let numbers = APIManager.sharedInstance.mcgInbody2
        var inbodyValuesMgc = ["mgc"]
        if(numbers.count > 1){
            for i in 0..<(numbers.count - 1) {
                let value = ChartDataEntry(x: Double(i), y: numbers[i])
                lineChartEntry.append(value)
                addLine(fromPoint: CGPoint(x: ((mgcChart.bounds.width / CGFloat( numbers.count)) * CGFloat(i)), y: ((CGFloat(numbers[i]) / CGFloat(numbers.max()! * 1.10) * mgcChart.bounds.height ))), toPoint: CGPoint(x: ((mgcChart.bounds.width / CGFloat( numbers.count)) * CGFloat(i + 1)), y: ((CGFloat(numbers[i + 1]) / CGFloat(numbers.max()! * 1.10) * mgcChart.bounds.height ))), viewGraph: mgcChart)
            }
        }else if(numbers.count == 1){
            addPoint(fromPoint: CGPoint(x: ((mgcChart.bounds.width / CGFloat( numbers.count)) * CGFloat(0)), y: ((CGFloat(numbers[0]) / CGFloat(numbers.max()! * 1.10) * mgcChart.bounds.height ))), viewGraph: mgcChart)
        }
       
    }
    func setRccChart () {
        var months = APIManager.sharedInstance.mes
        let numbers = APIManager.sharedInstance.rccInbody2
        var inbodyValueRcc = ["mgc"]
        if(numbers.count > 1){
            for i in 0..<(numbers.count - 1) {
                let value = ChartDataEntry(x: Double(i), y: numbers[i])
                lineChartEntry.append(value)
                addLine(fromPoint: CGPoint(x: ((rcc.bounds.width / CGFloat( numbers.count)) * CGFloat(i)), y: ((CGFloat(numbers[i]) / CGFloat(numbers.max()! * 1.10) * rcc.bounds.height ))), toPoint: CGPoint(x: ((rcc.bounds.width / CGFloat( numbers.count)) * CGFloat(i + 1)), y: ((CGFloat(numbers[i + 1]) / CGFloat(numbers.max()! * 1.10) * rcc.bounds.height ))), viewGraph: rcc)
            }
        }else if(numbers.count == 1){
            addPoint(fromPoint: CGPoint(x: ((rcc.bounds.width / CGFloat( numbers.count)) * CGFloat(0)), y: ((CGFloat(numbers[0]) / CGFloat(numbers.max()! * 1.10) * rcc.bounds.height ))), viewGraph: rcc)
        }
    }
    func setMmeChart() {
        var months = APIManager.sharedInstance.mes
        let numbers = APIManager.sharedInstance.mmeInbody2
        var inbodyValuesMgc = ["mgc"]
        if(numbers.count > 1){
            for i in 0..<(numbers.count - 1) {
                let value = ChartDataEntry(x: Double(i), y: numbers[i])
                lineChartEntry.append(value)
                addLine(fromPoint: CGPoint(x: ((mmeChart.bounds.width / CGFloat( numbers.count)) * CGFloat(i)), y: ((CGFloat(numbers[i]) / CGFloat(numbers.max()! * 1.10) * mmeChart.bounds.height ))), toPoint: CGPoint(x: ((mmeChart.bounds.width / CGFloat( numbers.count)) * CGFloat(i + 1)), y: ((CGFloat(numbers[i + 1]) / CGFloat(numbers.max()! * 1.10) * mmeChart.bounds.height ))), viewGraph: mmeChart)
            }
        }else if(numbers.count == 1){
            addPoint(fromPoint: CGPoint(x: ((mmeChart.bounds.width / CGFloat( numbers.count)) * CGFloat(0)), y: ((CGFloat(numbers[0]) / CGFloat(numbers.max()! * 1.10) * mmeChart.bounds.height ))), viewGraph: mmeChart)
        }
    }
    
    func setPgcChart() {
        var months = APIManager.sharedInstance.mes
        let numbers = APIManager.sharedInstance.pgcInbody2
        var inbodyValuesMgc = ["mgc"]
        if(numbers.count > 1){
            for i in 0..<(numbers.count - 1) {
                let value = ChartDataEntry(x: Double(i), y: numbers[i])
                lineChartEntry.append(value)
                addLine(fromPoint: CGPoint(x: ((pgcChart.bounds.width / CGFloat( numbers.count)) * CGFloat(i)), y: ((CGFloat(numbers[i]) / CGFloat(numbers.max()! * 1.10) * pgcChart.bounds.height ))), toPoint: CGPoint(x: ((pgcChart.bounds.width / CGFloat( numbers.count)) * CGFloat(i + 1)), y: ((CGFloat(numbers[i + 1]) / CGFloat(numbers.max()! * 1.10) * pgcChart.bounds.height ))), viewGraph: pgcChart)
            }
        }else if(numbers.count == 1){
            addPoint(fromPoint: CGPoint(x: ((pgcChart.bounds.width / CGFloat( numbers.count)) * CGFloat(0)), y: ((CGFloat(numbers[0]) / CGFloat(numbers.max()! * 1.10) * pgcChart.bounds.height ))), viewGraph: pgcChart)
        }
    }
    func setImcChart() {
        var months = APIManager.sharedInstance.mes
        let numbers = APIManager.sharedInstance.imcInbody2
        var inbodyValuesMgc = ["mgc"]
        if(numbers.count > 1){
            for i in 0..<(numbers.count - 1) {
                let value = ChartDataEntry(x: Double(i), y: numbers[i])
                lineChartEntry.append(value)
                addLine(fromPoint: CGPoint(x: ((imcChart.bounds.width / CGFloat( numbers.count)) * CGFloat(i)), y: ((CGFloat(numbers[i]) / CGFloat(numbers.max()! * 1.10) * imcChart.bounds.height ))), toPoint: CGPoint(x: ((imcChart.bounds.width / CGFloat( numbers.count)) * CGFloat(i + 1)), y: ((CGFloat(numbers[i + 1]) / CGFloat(numbers.max()! * 1.10) * imcChart.bounds.height ))), viewGraph: imcChart)
            }
        }else if(numbers.count == 1){
            addPoint(fromPoint: CGPoint(x: ((imcChart.bounds.width / CGFloat( numbers.count)) * CGFloat(0)), y: ((CGFloat(numbers[0]) / CGFloat(numbers.max()! * 1.10) * imcChart.bounds.height ))), viewGraph: imcChart)
        }
    }
    
}
