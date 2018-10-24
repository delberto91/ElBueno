//
//  MoviesTableViewCell.swift
//  TableStyleNetflix
//
//  Created by VicktorManuel on 7/30/18.
//  Copyright © 2018 VicktorManuel. All rights reserved.
//

import UIKit
//Uso delegado para mandar información a la clase
protocol MoviesTableViewCellDelegate {
    func videoSelect(video : RutinasCasa)
}
class MoviesTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.videoRoutines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MoviewCollectionViewCell
        let video = self.videoRoutines[indexPath.row] as RutinasCasa
        cell.titleVideo.text = video.nombreEntrenamiento
        DispatchQueue.main.async {
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 25
            cell.image.downloadedFrom(url: NSURL(string: video.foto)! as URL, contentMode: .scaleAspectFill)
           
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        //Le mando el video seleccionado al segue en el viewcontroller
        let video = self.videoRoutines[indexPath.row] as RutinasCasa
        self.delegate.videoSelect(video: video)
    }
    @IBOutlet weak var titleCell: UILabel!
    var videoRoutines : [RutinasCasa] = [RutinasCasa]()
    var delegate:MoviesTableViewCellDelegate! = nil
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    

    
}


