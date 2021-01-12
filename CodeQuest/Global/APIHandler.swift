//
//  APIHandler.swift
//  CodeQuest
//
//  Created by Subhangi Pawar on 10/01/21.
//

import Foundation

class APIHandler: NSObject {
    
    fileprivate let apiKey = "api_key=8b85dbaf4d85258da5ce4d31f201c2c2"
    static let sharedInstance = APIHandler()
    fileprivate let mainUrl = "https://api.themoviedb.org/3/"
    
    //  MARK: -  Get Movie Data
    func getMoviesData(pageNo: Int, success: @escaping(_ resObj: Data) ->Void, failure: @escaping (_ resObj: AnyObject) -> Void) -> Void{
    
        let movieUrl = mainUrl + "movie/now_playing?" + apiKey + "&page=\(pageNo)"
        
        URLSession.shared.dataTask(with: URL(string: movieUrl)!) { (responseData, httpUrlResponse, error) in
            if (error == nil && responseData != nil) {
                success(responseData ?? Data())
            } else if error != nil {
                failure(error as AnyObject)
            }
        }.resume()
    }
    
    //  MARK: -  Get Search Movie Data
    func getSearchMovieData(query: String, pageNo: Int, success: @escaping(_ resObj: Data) ->Void, failure: @escaping (_ resObj: AnyObject) -> Void) -> Void{

        let movieUrl = mainUrl + "search/movie?" + apiKey + "&query=\(query)&page=\(pageNo)"
        let encodedUrl = URL(string: movieUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")!
      
        URLSession.shared.dataTask(with: encodedUrl) { (responseData, httpUrlResponse, error) in
            if (error == nil && responseData != nil) {
                success(responseData ?? Data())
            } else if error != nil {
                failure(error as AnyObject)
            }
        }.resume()
    }
    
    //  MARK: -  Get Movie Detail Data
    func getMovieDetailData(movieId: Int, success: @escaping(_ resObj: Data) ->Void, failure: @escaping (_ resObj: AnyObject) -> Void) -> Void{

        let movieUrl = mainUrl + "movie/\(movieId)?" + apiKey
        
        URLSession.shared.dataTask(with: URL(string: movieUrl)!) { (responseData, httpUrlResponse, error) in
            if (error == nil && responseData != nil) {
                success(responseData ?? Data())
            } else if error != nil {
                failure(error as AnyObject)
            }
        }.resume()
    }
    
    //  MARK: -  Get Movie Cast & Crew Data
    func getMovieCastAndCrewData(movieId: Int, success: @escaping(_ resObj: Data) ->Void, failure: @escaping (_ resObj: AnyObject) -> Void) -> Void{

        let movieUrl = mainUrl + "movie/\(movieId)/credits?" + apiKey
        
        URLSession.shared.dataTask(with: URL(string: movieUrl)!) { (responseData, httpUrlResponse, error) in
            if (error == nil && responseData != nil) {
                success(responseData ?? Data())
            } else if error != nil {
                failure(error as AnyObject)
            }
        }.resume()
    }
    
    //  MARK: -  Get Similar Movie Data
    func getSimilarMovieData(movieId: Int, success: @escaping(_ resObj: Data) ->Void, failure: @escaping (_ resObj: AnyObject) -> Void) -> Void{

        let movieUrl = mainUrl + "movie/\(movieId)/similar?" + apiKey
        
        URLSession.shared.dataTask(with: URL(string: movieUrl)!) { (responseData, httpUrlResponse, error) in
            if (error == nil && responseData != nil) {
                success(responseData ?? Data())
            } else if error != nil {
                failure(error as AnyObject)
            }
        }.resume()
    }
}
