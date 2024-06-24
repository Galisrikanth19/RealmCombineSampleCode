//
//  ViewController.swift
//  Created by GaliSrikanth on 22/06/24.

import UIKit
import Combine

class ViewController: UIViewController {
    @IBOutlet weak var tbv: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let refreshControl = UIRefreshControl()
    
    private var viewModel = ViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
}

// MARK: CustomizeScreen
extension ViewController {
    private func setupVC() {
        setupTbv()
        bindViewModel()
    }
    
    private func loadData() {
        viewModel.fetchPosts()
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    private func setupTbv() {
        tbv.dataSource = self
        tbv.delegate = self
        
        tbv.backgroundColor = .clear
        tbv.separatorColor = .clear
        
        tbv.showsVerticalScrollIndicator = false
        addRefreshControll()
    }
    
    private func addRefreshControll() {
        refreshControl.tintColor = UIColor.darkGray
        refreshControl.addTarget(self, action: #selector(tbvNeedsRefresh), for: .valueChanged)
        tbv.addSubview(refreshControl)
    }
    
    @objc private func tbvNeedsRefresh() {
        viewModel.fetchPosts()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tbvCell = tableView.dequeueReusableCell(withIdentifier: "TbvCell", for: indexPath) as! TbvCell
        tbvCell.configureCell(WithPostModel: viewModel.dataArr[indexPath.row])
        return tbvCell
    }
}

// MARK: ViewModel binding
extension ViewController {
    private func bindViewModel() {
        viewModel.$dataArr
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tbv.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { isLoading in
                if isLoading {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
                
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    self?.showError(errorMessage)
                }
            }
            .store(in: &cancellables)
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
