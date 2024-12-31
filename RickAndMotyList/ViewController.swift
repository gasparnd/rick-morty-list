//
//  ViewController.swift
//  RickAndMotyList
//
//  Created by Gaspar Dolcemascolo on 30-12-24.
//

import UIKit

class ViewController: UIViewController {
    
    let stackView = UIStackView()
    let label = UILabel()
    var characters: [Character] = []
    let tableView = UITableView()
    
    var currentPage = 1
    var hasMorePages = true
    var isLoading = false
    var footerView: LoadingFooterView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchCharacters(fromPage: currentPage){ result in
            switch result {
            case .success(let characters):
                self.characters = characters
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableCellView.self, forCellReuseIdentifier: TableCellView.reuseID) // 1. Registrar celda
        
        footerView = LoadingFooterView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        tableView.tableFooterView = footerView
        tableView.rowHeight = TableCellView.rowHeight
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}



// MARK: - TableView Delegate

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCellView.reuseID, for: indexPath) as! TableCellView
        cell.configure(with: characters[indexPath.row])
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Seleccionaste a: \(characters[indexPath.row].name)")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height 
        
        // Detectar si estamos cerca del final (desplazados 90%)
        if offsetY > contentHeight - scrollView.frame.height * 1.1 {
            fetchCharacters(fromPage: self.currentPage) { result in
                switch result {
                case .success(let characters):
                    self.characters.append(contentsOf: characters)
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}



// MARK: - Networking

extension ViewController {
    private func fetchCharacters(fromPage: Int, completion: @escaping (Result<[Character], Error>) -> Void) {
        guard !self.isLoading && self.hasMorePages else { return }
        self.isLoading = true
        self.footerView.showLoading()
        
        let url = URL(string: "https://rickandmortyapi.com/api/character/?page=\(fromPage)")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                defer { self.isLoading = false }
                
                guard let data = data, error == nil else {
                    if let error = error {
                        completion(.failure(error))
                    }
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let response = try decoder.decode(ApiResponse.self, from: data)
                    self.hasMorePages = response.info.next != nil
                    self.currentPage += 1
                    if !self.hasMorePages {
                        self.footerView.showNoMoreData()
                    } else {
                        self.footerView.hide()
                    }
                    completion(.success(response.results))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
