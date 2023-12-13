//
//  ViewController.swift
//  pure_MVVM
//
//  Created by matias on 13/12/2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var table: UITableView!
    
    var viewModel = ViewModelList()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationView()
        bind()
    }
    
    private func configurationView(){
        activity.startAnimating()
        // Llama a la función retrieveDataList
        viewModel.retrieveDataList()
        
   
    }
    
    private func bind(){
        viewModel.refreshData = { [weak self] () in
            guard let self = self else { return }
            DispatchQueue.main.async{
                self.table.reloadData()
                self.activity.stopAnimating()
                self.activity.isHidden = true
            }
        }
        
        
    }
}

typealias TableConfiguration =  UITableViewDelegate & UITableViewDataSource

extension ViewController: TableConfiguration{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let object = viewModel.dataArray[indexPath.row]
        
        cell.textLabel?.text = object.title
        cell.textLabel?.font =  UIFont(name: "Optima", size: 18.0)
        cell.detailTextLabel?.text = object.body
        cell.detailTextLabel?.font = UIFont(name: "Optima", size: 14.0)
        
        return cell
    }
    
    
}
