//
//  MovieDetailViewController.swift
//  MovieMiniProject
//
//  Created by Michael Iskandar on 04/08/23.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import DiffableDataSources

class MovieDetailViewController: UIViewController {
    
    enum DiffableSection: Hashable {
        case main
    }
    
    enum CellType: Hashable {
        case header(item: Movie?)
        case sectionTitle
        case review(item: Review)
        case empty
    }

    var presenter: MovieDetailPresenterProtocol?
    
    private var movie: Movie?
    private var reviews: [Review] = []
    
    private lazy var tableView: UITableView = UITableView().then {
        $0.delegate = self
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.register(MovieHeaderTableViewCell.self, forCellReuseIdentifier: MovieHeaderTableViewCell.identifier)
        $0.register(ReviewTableViewCell.self, forCellReuseIdentifier: ReviewTableViewCell.identifier)
        $0.register(SectionTableViewCell.self, forCellReuseIdentifier: SectionTableViewCell.identifier)
        $0.register(EmptyTableViewCell.self, forCellReuseIdentifier: EmptyTableViewCell.identifier)
    }
    
    private lazy var loadMoreActivityIndicatorView = UIActivityIndicatorView().then {
        $0.hidesWhenStopped = true
    }
    
    lazy var dataSource = TableViewDiffableDataSource<DiffableSection, CellType>(tableView: tableView) { [weak self] tableView, indexPath, item in
        guard let self = self else { return UITableViewCell() }
        return self.setupDataSource(tableView, indexPath, item)
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupEvents()
    }
}

extension MovieDetailViewController {
    private func setupEvents() {
        presenter?.isLoadingObservable
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isLoading in
                self?.tableView.toggleLoading(isLoading)
            }).disposed(by: disposeBag)
        
        presenter?.isLoadingMoreDataObservable
            .bind(to: loadMoreActivityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        // MARK: - Data Source
        presenter?.movieObservable
            .subscribe(onNext: { [weak self] movie in
                guard let self = self else { return }
                self.movie = movie
            }).disposed(by: disposeBag)
        
        presenter?.reviewsObservable
            .skip(1)
            .subscribe(onNext: { [weak self] reviews in
                guard let self = self else { return }
                self.reviews = reviews
                self.refreshSnapShot()
            }).disposed(by: disposeBag)
        
        tableView.rx.didEndDecelerating
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.presenter?.loadMoreReviews.onNext(())
            }).disposed(by: disposeBag)
        
        presenter?.errorObservable
            .subscribe(onNext: { [weak self] error in
                if let error = error {
                    self?.showAlert(error)
                }
            }).disposed(by: disposeBag)
    }
}

extension MovieDetailViewController {
    private func setupDataSource(_ tableView: UITableView, _ indexPath: IndexPath, _ cellType: CellType) -> UITableViewCell {
        switch cellType {
        case .header(let item):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MovieHeaderTableViewCell.identifier,
                for: indexPath) as? MovieHeaderTableViewCell,
                  let item = item else { return UITableViewCell() }
            cell.configure(with: item)
            return cell
        case .sectionTitle:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SectionTableViewCell.identifier,
                for: indexPath) as? SectionTableViewCell else { return UITableViewCell() }
            return cell
        case .review(let item):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ReviewTableViewCell.identifier,
                for: indexPath) as? ReviewTableViewCell else { return UITableViewCell() }
            cell.configure(with: item)
            return cell
        case .empty:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: EmptyTableViewCell.identifier,
                for: indexPath) as? EmptyTableViewCell else { return UITableViewCell() }
            return cell
        }
    }
    
    private func refreshSnapShot() {
        var snapshot = DiffableDataSourceSnapshot<DiffableSection, CellType>()
        snapshot.appendSections([.main])
        snapshot.appendItems([.header(item: movie), .sectionTitle], toSection: .main)
        if reviews.count > 0 {
            reviews.forEach { review in
                snapshot.appendItems([.review(item: review)], toSection: .main)
            }
        } else {
            snapshot.appendItems([.empty])
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension MovieDetailViewController {
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(loadMoreActivityIndicatorView)
        navigationItem.title = "Movie Detail"
        
        tableView.dataSource = dataSource
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        loadMoreActivityIndicatorView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(tableView.snp.bottom).offset(-10)
        }
    }
}

extension MovieDetailViewController: UITableViewDelegate { }
