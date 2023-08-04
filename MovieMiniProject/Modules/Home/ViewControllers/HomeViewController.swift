//
//  HomeViewController.swift
//  MovieMiniProject
//
//  Created by Michael Iskandar on 03/08/23.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

class HomeViewController: UIViewController {
    
    private let titleLabel = UILabel().then {
        $0.text = "Movies"
        $0.numberOfLines = 1
        $0.sizeToFit()
        $0.lineBreakMode = .byWordWrapping
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 32, weight: .bold)
    }
    
    private lazy var containerHeaderView = UIView().then {
        $0.addSubview(titleLabel)
        $0.addSubview(categoryCollectionView)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    var presenter: HomePresenterProtocol?
    
    private let disposeBag = DisposeBag()

    private lazy var categoryCollectionView = CategoryCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private lazy var mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        $0.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        if let layout = $0.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.itemSize = .init(width: (UIScreen.main.bounds.width / 3) - 16, height: 260)
            layout.minimumInteritemSpacing = 8
            layout.minimumLineSpacing = 8
        }
    }
    
    private lazy var loadMoreActivityIndicatorView = UIActivityIndicatorView().then {
        $0.hidesWhenStopped = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupEvents()
    }
}

extension HomeViewController {
    private func setupUI() {
        view.addSubview(containerHeaderView)
        view.addSubview(mainCollectionView)
        view.addSubview(loadMoreActivityIndicatorView)
        
        view.backgroundColor = .white
    }
    
    private func setupConstraints() {
        containerHeaderView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        mainCollectionView.snp.makeConstraints {
            $0.top.equalTo(containerHeaderView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        loadMoreActivityIndicatorView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(mainCollectionView.snp.bottom).offset(-10)
        }
    }
}

extension HomeViewController {
    private func setupEvents() {
        presenter?.isloadingGenreObservable.asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isLoading in
                self?.categoryCollectionView.toggleLoading(isLoading)
            }).disposed(by: disposeBag)
        
        presenter?.isLoadingObservable.asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isLoading in
                self?.mainCollectionView.toggleLoading(isLoading)
            }).disposed(by: disposeBag)
        
        presenter?.isLoadingMoreDataObservable
            .bind(to: loadMoreActivityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        //MARK: - Category Collection View Events
        presenter?.genresObservable.asObservable()
            .bind(to: categoryCollectionView.rx.items(
                cellIdentifier: CategoryCollectionViewCell.identifier,
                cellType: CategoryCollectionViewCell.self)
            ) { (item, value, cell)  in
                cell.configure(with: value)
            }.disposed(by: disposeBag)
        
        presenter?.genresObservable.asObservable()
            .subscribe(onNext: { [weak self] genres in
                if genres.count > 0 {
                    self?.selectInitialCategory()
                }
            }).disposed(by: disposeBag)
        
        categoryCollectionView.rx.modelSelected(Genre.self)
            .subscribe(onNext: { [weak self] genre in
                self?.presenter?.selectedGenre.onNext(genre)
            }).disposed(by: disposeBag)
        
        //MARK: Main Collection View Events
        presenter?.moviesObservable
            .bind(to: mainCollectionView.rx.items(
                cellIdentifier: MainCollectionViewCell.identifier,
                cellType: MainCollectionViewCell.self)
            ) { (item, value, cell) in
                cell.configure(with: value)
            }.disposed(by: disposeBag)
        
        mainCollectionView.rx.didEndDecelerating
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.presenter?.loadMoreMovies.onNext(())
            }).disposed(by: disposeBag)
        
        mainCollectionView.rx.modelSelected(Movie.self)
            .subscribe { [weak self] movie in
                guard let self = self else { return }
                self.presenter?.goToMovieDetail(id: movie.id)
            }.disposed(by: disposeBag)
        
        presenter?.errorMessageObservable
            .subscribe(onNext: { [weak self] error in
                if let error = error {
                    self?.showAlert(error)
                }
            }).disposed(by: disposeBag)
    }
}

extension HomeViewController {
    private func selectInitialCategory() {
        let initialIndex = IndexPath(item: 0, section: 0)
        categoryCollectionView.selectItem(at: initialIndex, animated: true, scrollPosition: .left)
    }
}
