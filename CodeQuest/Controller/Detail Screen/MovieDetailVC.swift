//
//  MovieDetailVC.swift
//  CodeQuest
//
//  Created by Subhangi Pawar on 11/01/21.
//

import UIKit

class MovieDetailVC: UIViewController {

    @IBOutlet weak var tblMovieDetail: UITableView!
    
    var movieIdentifier = 0
    var movieDetailList: MovieDetailModal?
    var movieCastAndCrewList: MovieCastModal?
    var similarMovieList: SimilarMoviesModal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        print("id = \(movieIdentifier)")
        getMovieDetails()
    }

    func registerXib(){
        let headerNib = UINib(nibName: TableViewHeaderViewNibName.HomeTableViewHeaderView.rawValue, bundle: nil)
        tblMovieDetail.register(headerNib, forHeaderFooterViewReuseIdentifier: TableViewHeaderIdentifier.HomeTableViewHeader.rawValue)
    }
    
    fileprivate func getMovieDetails() {
        
        let radQueue = OperationQueue()
        let operation1 = BlockOperation {
            let group = DispatchGroup()
            group.enter()
            APIHandler.sharedInstance.getMovieDetailData(movieId: self.movieIdentifier) { [self] (responseData) in
                let jsonDecoder = JSONDecoder()
                do {
                    let resObj = try jsonDecoder.decode(MovieDetailModal.self, from: responseData)
                    movieDetailList = resObj
                    group.leave()
                } catch {
                    print("JSONSerialization error:", error)
                    group.leave()
                }
            } failure: { (error) in
                print("\(error)")
                group.leave()
            }
            group.wait()
        }
        
        let operation2 = BlockOperation {
            let group = DispatchGroup()
            group.enter()
            APIHandler.sharedInstance.getMovieCastAndCrewData(movieId: self.movieIdentifier) { [self] (responseData) in
                let jsonDecoder = JSONDecoder()
                do {
                    let resObj = try jsonDecoder.decode(MovieCastModal.self, from: responseData)
                    movieCastAndCrewList = resObj
                    group.leave()
                } catch {
                    print("JSONSerialization error:", error)
                    group.leave()
                }
            } failure: { (error) in
                print("\(error)")
                group.leave()
            }
            group.wait()
        }
        
        let operation3 = BlockOperation {
            let group = DispatchGroup()
            group.enter()
            APIHandler.sharedInstance.getSimilarMovieData(movieId: self.movieIdentifier) { [self] (responseData) in
                let jsonDecoder = JSONDecoder()
                do {
                    let resObj = try jsonDecoder.decode(SimilarMoviesModal.self, from: responseData)
                    similarMovieList = resObj
                    DispatchQueue.main.async { [self] in
                        print("similarMovieList")
                        tblMovieDetail.reloadData()
                    }
                    group.leave()
                } catch {
                    print("JSONSerialization error:", error)
                    group.leave()
                }
            } failure: { (error) in
                print("\(error)")
                group.leave()
            }
            group.wait()
        }
        
        operation2.addDependency(operation1)
        operation3.addDependency(operation2)
        radQueue.addOperation(operation1)
        radQueue.addOperation(operation2)
        radQueue.addOperation(operation3)
        
    }
}

//  MARK: - UITableViewDelegate, UITableViewDataSource
extension MovieDetailVC: UITableViewDelegate, UITableViewDataSource {
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tblMovieDetail.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.moviePlayerCell.rawValue, for: indexPath) as! MoviePlayerTableViewCell
            cell.lblMovieName.text = movieDetailList?.originalTitle
            cell.lblMovieReleaseDate.text = "Release Date: \(movieDetailList?.releaseDate ?? "")"
            cell.lblMovieLanguage.text = "Language: \(movieDetailList?.originalLanguage ?? "")"
            if movieDetailList?.genres?.count ?? 0 > 0 {
                cell.lblMovieGenre.text = "Genre: \(movieDetailList?.genres?[indexPath.row].name ?? "")"
            } else {
                cell.lblMovieGenre.text = "Genre: Movie)"
            }
            cell.lblMovieSynopsis.text = movieDetailList?.overview
            return cell
        } else {
            let cell = tblMovieDetail.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.movieDetailTableCell.rawValue, for: indexPath) as! MovieDetailTableViewCell
            switch indexPath.section {
            case 1:
                cell.collectionViewCast.tag = CollectionViewTag.cast.rawValue
            case 2:
                cell.collectionViewCast.tag = CollectionViewTag.crew.rawValue
            case 3:
                cell.collectionViewCast.tag = CollectionViewTag.similarMovie.rawValue
            default:
                break
            }
            cell.collectionViewCast.reloadData()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tblMovieDetail.dequeueReusableHeaderFooterView(withIdentifier: TableViewHeaderIdentifier.HomeTableViewHeader.rawValue) as! HomeTableViewHeaderView
        switch section {
        case 1:
            headerView.lblCategory.text = "Cast"
        case 2:
            headerView.lblCategory.text = "Crew"
        case 3:
            headerView.lblCategory.text = "Similar Movies"
        default:
            break
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 35.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 12.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 400.0 : 145
    }

}
//  MARK: -  UICollectionViewDelegate, UICollectionViewDataSource
extension MovieDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView.tag {
        case 1000:
            return movieCastAndCrewList?.cast?.count ?? 0
        case 1001:
            return movieCastAndCrewList?.crew?.count ?? 0
        case 1002:
            return similarMovieList?.results?.count ?? 0
        default:
            break
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.movieDetailCollectionCell.rawValue, for: indexPath) as! MovieDetailCollectionViewCell
        switch collectionView.tag {
        case 1000:
            cell.lblName.text = movieCastAndCrewList?.cast?[indexPath.row].originalName
            cell.imgViewPic.image = UIImage(named: "ActorPoster")
        case 1001:
            cell.lblName.text = movieCastAndCrewList?.crew?[indexPath.row].originalName
            cell.imgViewPic.image = UIImage(named: "ActorPoster")
        case 1002:
            cell.lblName.text = similarMovieList?.results?[indexPath.row].originalTitle
            cell.imgViewPic.image = UIImage(named: "moviePoster")
        default:
            break
        }
        return cell
    }
}
