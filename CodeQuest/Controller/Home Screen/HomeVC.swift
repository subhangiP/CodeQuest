//
//  HomeVC.swift
//  CodeQuest
//
//  Created by Subhangi Pawar on 10/01/21.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var tblHome: UITableView!
    
    fileprivate var pageNo: Int = 1
    fileprivate var totalSize: Int = 0
    fileprivate var currentPage = 1
    fileprivate var totalPage = 0
    var movieList: MovieModal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getNowPlayingMoviesData(page: currentPage)
    }
    
    func registerXib(){
        let headerNib = UINib(nibName: TableViewHeaderViewNibName.HomeTableViewHeaderView.rawValue, bundle: nil)
        tblHome.register(headerNib, forHeaderFooterViewReuseIdentifier: TableViewHeaderIdentifier.HomeTableViewHeader.rawValue)
    }
    
    func getNowPlayingMoviesData(page: Int) {
        
        APIHandler.sharedInstance.getMoviesData(pageNo: page) { [self] (responseData) in
            let jsonDecoder = JSONDecoder()
            do {
                let resObj = try jsonDecoder.decode(MovieModal.self, from: responseData)
                totalSize = resObj.totalResults ?? 0
                currentPage = resObj.page ?? 0
                totalPage = resObj.totalPages ?? 0
                
                if page == 1 {
                    pageNo = 1
                    movieList = resObj
                } else {
                    for data in resObj.results! {
                        movieList?.results?.append(data)
                    }
                }
                
                DispatchQueue.main.async { [self] in
                    tblHome.reloadData()
                }
            } catch let error {
                print("error occurred while decoding = \(error.localizedDescription)")
            }
        } failure: { (error) in
            print(error)
        }

    }
}
//  MARK: - UITableViewDelegate, UITableViewDataSource
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList?.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblHome.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.homeTableCell.rawValue, for: indexPath) as! HomeTableViewCell
        cell.lblMovieTitle.text = movieList?.results?[indexPath.row].originalTitle
        cell.lblMovieReleaseDate.text = movieList?.results?[indexPath.row].releaseDate
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == (movieList?.results?.count ?? 0) - 1 {
            if totalSize  > movieList?.results?.count ?? 0 {
                if pageNo == currentPage {
                    pageNo += 1
                    getNowPlayingMoviesData(page: pageNo)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailScreen = self.storyboard?.instantiateViewController(identifier: VCIdentifier.MovieDetailVC.rawValue) as! MovieDetailVC
        detailScreen.movieIdentifier = movieList?.results?[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(detailScreen, animated: true)
    }
}

