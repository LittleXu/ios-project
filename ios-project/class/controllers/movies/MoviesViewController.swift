//
//  MoviesViewController.swift
//  ios-project
//
//  Created by liuxu on 2025/1/15.
//

import Foundation
import UIKit
import ObjectMapper


extension Common {

    static let want_see_key = "want_see_key"
    
    static func saveWantSee(movie: Movie) {
        
        if var array = UserDefaults.standard.value(forKey: want_see_key) as? [String] {
            array.insert(movie.title, at: 0)
            UserDefaults.standard.set(array, forKey: want_see_key)
        } else {
            UserDefaults.standard.set([movie.title], forKey: want_see_key)
        }
        
        UserDefaults.standard.synchronize()
    }
    
    static func cancelWantSee(movie: Movie) {
        if var array = UserDefaults.standard.value(forKey: want_see_key) as? [String] {
            array.removeAll { item in
                return item == movie.title
            }
            UserDefaults.standard.set(array, forKey: want_see_key)
        }
    }
    
    static func selectWantSeeMovies() -> [Movie] {
        if let array = UserDefaults.standard.value(forKey: want_see_key) as? [String] {
            let jsons = Common.parseJSON2Array(fileName: "movies")
            let datas = Mapper<Movie>().mapArray(JSONArray: jsons)
            let results = datas.filter { movie in
                return array.contains(movie.title)
            }
            return results
        }
        return []
    }
}



class MoviesViewController: BaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.background
        navigationItem.title = "热门电影"
        setupViews()
        handleMovieDatas()
    }
    
    private func setupViews() {
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 170 + 32
        table.register(MovieCell.self)
        table.separatorStyle = .singleLine
        table.separatorColor = Color.subText
        table.separatorInset = UIEdgeInsets.zero
    }
    
    private func handleMovieDatas() {
        view.showLoading()
        Common.fetch { [weak self] in
            guard let self = self else { return }
            let jsons = Common.parseJSON2Array(fileName: "movies")
            let datas = Mapper<Movie>().mapArray(JSONArray: jsons)
            view.hideLoading()
            self.datas = datas.shuffled()
            self.table.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.cellID(), for: indexPath) as! MovieCell
        cell.movie = datas[indexPath.row] as? Movie
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.datas[indexPath.row] as! Movie
        let sheet = UIAlertController(style: .actionSheet, title: "请选择操作")
        sheet.addAction(UIAlertAction(title: "想看", style: .default, handler: { _ in
            Common.showToast("已添加至想看!")
            Common.saveWantSee(movie: model)
        }))
        sheet.addAction(UIAlertAction(title: "发表评论", style: .default, handler: { _ in
            let vc = MovieReplyViewController()
            vc.movie = model
            Common.push(vc)
        }))
        sheet.addAction(UIAlertAction(title: "查看评论", style: .default, handler: { _ in
            let vc = MovieCommentsViewController()
            vc.movie = model
            Common.push(vc)
        }))
        sheet.addAction(UIAlertAction(title: "取消", style: .cancel))
        self.present(sheet, animated: true)
    }
}

extension MoviesViewController: RootViewControllerDelegate {
    func root_viewWillDidAppear() {
        
    }
    
    func root_viewWillDisappear() {
        
    }
    
    
}
