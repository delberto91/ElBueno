//
//  InbodyViewController.swift
//  Sports World
//
//  Created by Aldo Gutierrez Montoya on 6/6/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

import UIKit
import Charts
class InbodyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var inbodyValues = APIManager.sharedInstance.inbodyValues
    let values = APIManager.sharedInstance.lastInbody
    
    var pesoArray = APIManager.sharedInstance.lastInbody
    
    var dataEntries: [BarChartDataEntry] = []
    var valores = APIManager.sharedInstance.lastInbody
    
    
    /////EN ESTE CONTROLADOR FALTA CREAR EL ARRAY SIN QUE SE REPITAN LOS ELELEMENTOS
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    private let cell = "InbodyTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(values)
        print(pesoArray)
        print(valores)
        activity.isHidden = true
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "LarkeNeue-Regular", size: 23)
        //attributes for the first part of the string
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "back_button"), style: .done, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
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
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    @objc func back(){
        _ = UIStoryboard(name: "Main", bundle: nil)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        //vc.menu = true
        self.present(vc, animated: true, completion: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            if Reachability.isConnectedToNetwork() {
                
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        pesoArray.removeAll()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cel = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath as IndexPath) as! InbodyTableViewCell
        
        self.setChart(dataPoints: ["Pes","Est","RCC","PGC","IMC","MME","MGC","ACT"], values: values)
        
        print("values", values)
        
        cel.barChart.noDataText = "No hay información para mostrar."
        cel.barChart.noDataTextColor = UIColor.white
        
        cel.pesoLabel.text! = String(APIManager.sharedInstance.pesoInbody)
        
        cel.estaturaLabel.text! =  String(APIManager.sharedInstance.estaturaInbody)
        print(String(APIManager.sharedInstance.estaturaInbody))
        cel.relacionCinturaCadera.text! = String(APIManager.sharedInstance.rccInbody)
        print(String(APIManager.sharedInstance.rccInbody))
        cel.porcentajeGrasaCorporal.text! = String(APIManager.sharedInstance.pgcInbody)
        print(String(APIManager.sharedInstance.pgcInbody))
        cel.indiceMasaCorporal.text! = String(APIManager.sharedInstance.imcInbody)
        print(String(APIManager.sharedInstance.imcInbody))
        cel.masaMuscularEsqueleto.text! = String(APIManager.sharedInstance.mmeInbody)
        print(String(APIManager.sharedInstance.mmeInbody))
        cel.masaGrasaCorporal.text! = String(APIManager.sharedInstance.mmeInbody)
        print(String(APIManager.sharedInstance.actInbody))
        cel.aguaCorporalTotal.text! = String(APIManager.sharedInstance.actInbody)
        print(String(APIManager.sharedInstance.actInbody))
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label:"")
        //let charData = BarChartDataSet(
        let chartData = BarChartData(dataSets: [chartDataSet])
        chartDataSet.colors = [UIColor(patternImage: UIImage(named: "naranja_fondo")!),UIColor(patternImage: UIImage(named: "rojo_fondo")!),UIColor(patternImage: UIImage(named: "verde_fondo")!)]
        
        //chartDataSet.colors = ChartColorTemplates.vordiplom()
        let set1: LineChartDataSet = LineChartDataSet(values: dataEntries, label: "")
        //set1.fillColor = UIColor(patternImage: UIImage(named: "rojo_fondo")!)
        set1.drawFilledEnabled = true
        set1.drawCirclesEnabled = false
        
        
        let gradientColors = [UIColor.cyan.cgColor, UIColor.clear.cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        set1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
        set1.drawFilledEnabled = true // Draw the Gradient
        
        let data = LineChartData()
        
        data.addDataSet(set1)
        
        chartData.addDataSet(chartDataSet)
        cel.barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: ["Pes","Est","RCC","PGC","IMC","MME","MGC","ACT"])
        print("inbodyValues")
        cel.barChart.xAxis.wordWrapEnabled = true
        cel.barChart.xAxis.wordWrapWidthPercent = 5.0
        
        cel.barChart.xAxis.labelWidth = 0.5
        cel.barChart.fitScreen()
        
        //cel.barChart.xAxis.wordWrapWidthPercent = 10
        cel.barChart.xAxis.labelTextColor = UIColor.white
        cel.barChart.xAxis.granularity = 1
        cel.barChart.chartDescription?.text = ""
        cel.barChart.chartDescription?.textColor = UIColor.clear
        cel.barChart.data = chartData
        cel.barChart.leftAxis.forceLabelsEnabled = true
        cel.barChart.rightAxis.forceLabelsEnabled = true
        cel.barChart.xAxis.granularityEnabled = true
        cel.barChart.xAxis.granularity = 1.0
        cel.barChart.leftAxis.drawGridLinesEnabled = false
        cel.barChart.rightAxis.drawGridLinesEnabled = false
        cel.barChart.xAxis.drawGridLinesEnabled = false
        cel.barChart.leftAxis.axisMinimum = 0.5
        cel.barChart.leftAxis.axisMaximum = 200
        cel.barChart.leftAxis.labelTextColor = UIColor.white
        cel.barChart.rightAxis.enabled = false
        cel.barChart.drawGridBackgroundEnabled = false
        cel.barChart.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        cel.barChart.legend.enabled = false
        //cel.barChart.xAxis.labelWidth = 10.0
        cel.barChart.xAxis.labelFont.withSize(5.0)
        cel.barChart.layer.cornerRadius = 8
        cel.layer.borderWidth = 1.0
        cel.barChart.barData?.barWidth = 0.2
        //cel.barChart.xAxis.setLabelCount(inbodyValues.count, force: <#T##Bool#>)
        
        // cel.proteinas.text = pesoArray[indexPath.row]
        
        return cel
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 687
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        if values.count > 0 {
            for i in 0..<dataPoints.count  {
                let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
                
                dataEntries.append(dataEntry)
            }
            
        }
       
    }
    
    
}

