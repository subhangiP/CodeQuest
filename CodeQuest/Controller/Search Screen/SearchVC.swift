//
//  SearchVC.swift
//  CodeQuest
//
//  Created by Subhangi Pawar on 10/01/21.
//

import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var tblSearch: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    fileprivate var queryText = String()
    fileprivate var pageNo: Int = 1
    fileprivate var totalSize: Int = 0
    fileprivate var currentPage = 1
    fileprivate var searchMovieResponse: SearchModal?
    fileprivate var searchMovieList: [Result]?
    fileprivate var cacheTextList = [String]()
    fileprivate var isTextSearchActive = false
    fileprivate var noOfWordsInSearchText = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
  
    override func viewWillAppear(_ animated: Bool) {
        queryText = ""
        searchBar.text = ""
        isTextSearchActive = false
        if let data = UserDefaults.standard.value(forKey: DefaultKeys.cacheData.rawValue) {
            cacheTextList = data as! [String]
            tblSearch.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set(cacheTextList, forKey: DefaultKeys.cacheData.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func getSearchMovie(query: String, page: Int) {
        
        APIHandler.sharedInstance.getSearchMovieData(query: query, pageNo: page) { [self] (responseData) in
            let jsonDecoder = JSONDecoder()
            do {
                let resObj = try jsonDecoder.decode(SearchModal.self, from: responseData)
                
                totalSize = resObj.totalResults ?? 0
                currentPage = resObj.page ?? 0
                
                if page == 1 {
                    searchMovieResponse = resObj
                    pageNo = 1
                    if noOfWordsInSearchText == 1 {
                        searchMovieList = resObj.results?.filter({ (itemResult) -> Bool in
                            (itemResult.originalTitle?.lowercased().hasPrefix(queryText.lowercased()) ?? false)
                        })
                    } else {
                        searchMovieList = resObj.results
                    }
                } else {
                    searchMovieResponse?.results?.append(contentsOf: resObj.results!)
                    if noOfWordsInSearchText == 1 {
                        let newMovies = resObj.results?.filter({ (itemResult) -> Bool in
                            (itemResult.originalTitle?.lowercased().hasPrefix(queryText.lowercased()) ?? false)
                        })
                        searchMovieList?.append(contentsOf: newMovies!)
                    } else {
                        searchMovieList?.append(contentsOf: resObj.results!)
                    }
                }
                
                DispatchQueue.main.async { [self] in
                    tblSearch.reloadData()
                }
            } catch let error {
                print("error occurred while decoding = \(error.localizedDescription)")
            }
        } failure: { (error) in
            print(error)
        }

        
    }
    
    func saveCacheData() {
        if !cacheTextList.contains(queryText) && queryText.count > 0 {
            if cacheTextList.count == 5 {
                cacheTextList.remove(at: 0)
                cacheTextList.append(queryText)
            } else {
                cacheTextList.append(queryText)
            }
        }
        UserDefaults.standard.set(cacheTextList, forKey: DefaultKeys.cacheData.rawValue)
        UserDefaults.standard.synchronize()
    }
    
}

extension SearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        queryText = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        queryText = searchBar.text?.trimmingCharacters(in: .whitespaces) ?? ""
        noOfWordsInSearchText = queryText.components(separatedBy: " ").count
        if !(queryText.isEmpty){
            isTextSearchActive = true
            saveCacheData()
            getSearchMovie(query: queryText, page: 1)
        } else {
            isTextSearchActive = false
            tblSearch.reloadData()
        }
        searchBar.resignFirstResponder()
    }
}
//  MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let listCount = isTextSearchActive ? searchMovieList?.count ?? 0 : cacheTextList.count
        if listCount > 0 {
            tableView.restore()
        } else {
            tableView.setEmptyMessage("No Result Found!!!")
        }
        return listCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblSearch.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.SearchTableCell.rawValue, for: indexPath) as! SearchTableViewCell
        cell.lblMovieName.text = isTextSearchActive ? searchMovieList?[indexPath.row].originalTitle : cacheTextList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isTextSearchActive {
            if indexPath.row == (searchMovieList?.count ?? 0) - 1 {
                if totalSize  > searchMovieResponse?.results?.count ?? 0 {
                    if pageNo == currentPage {
                        pageNo += 1
                        getSearchMovie(query: queryText, page: pageNo)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isTextSearchActive {
            let detailScreen = self.storyboard?.instantiateViewController(identifier: VCIdentifier.MovieDetailVC.rawValue) as! MovieDetailVC
            detailScreen.movieIdentifier = searchMovieResponse?.results?[indexPath.row].id ?? 0
            self.navigationController?.pushViewController(detailScreen, animated: true)
        } else {
            isTextSearchActive = true
            noOfWordsInSearchText = cacheTextList[indexPath.row].components(separatedBy: " ").count
            pageNo = 1
            queryText = cacheTextList[indexPath.row]
            getSearchMovie(query: cacheTextList[indexPath.row], page: 1)
            searchBar.text = cacheTextList[indexPath.row]
        }
        
    }
    
}
