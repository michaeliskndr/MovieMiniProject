//
//  HomePresenter.swift
//  MovieMiniProject
//
//  Created by Michael Iskandar on 03/08/23.
//

import RxSwift
import RxRelay
import Foundation

public protocol HomePresenterProtocol {
    func loadCategories()
    func loadMovies()
    
    var selectedGenre: PublishSubject<Genre> { get set }
    var loadMoreMovies: PublishSubject<Void> { get set }
    
    // Output
    var genresObservable: Observable<[Genre]> { get }
    var genreObservable: Observable<Genre?> { get }
    var moviesObservable: Observable<[Movie]> { get }
    var isloadingGenreObservable: Observable<Bool> { get }
    var isLoadingObservable: Observable<Bool> { get }
    var isLoadingMoreDataObservable: Observable<Bool> { get }
    var errorMessageObservable: Observable<String?> { get }
}

final public class HomePresenter {
    
    private var interactor: HomeInteractorProtocol?

    private var page = 1
    private var canLoadMore = true
    
    public var selectedGenre: PublishSubject<Genre> = PublishSubject<Genre>()
    public var loadMoreMovies: PublishSubject<Void> = PublishSubject<Void>()
    
    private var genres: BehaviorRelay<[Genre]> = .init(value: [])
    private var genre: BehaviorRelay<Genre?> = .init(value: nil)
    private var movies: BehaviorRelay<[Movie]> = .init(value: [])
    private var isloadingGenre: BehaviorRelay<Bool> = .init(value: true)
    private var isLoading: BehaviorRelay<Bool> = .init(value: true)
    private var isLoadingMoreData: BehaviorRelay<Bool> = .init(value: false)
    private var errorMessage: BehaviorRelay<String?> = .init(value: nil)

    private let disposeBag = DisposeBag()
    
    public init(interactor: HomeInteractorProtocol) {
        self.interactor = interactor
        
        loadCategories()
        
        selectedGenre.bind(to: genre)
            .disposed(by: disposeBag)
        
        genres
            .skip(1)
            .take(2)
            .subscribe { [weak self] genres in
                if genres.count > 0, let firstGenre = genres.first {
                    self?.genre.accept(firstGenre)
                }
            }.disposed(by: disposeBag)
        
        genre.subscribe(onNext: { [weak self] _ in
            self?.isLoading.accept(true)
            self?.movies.accept([])
            self?.canLoadMore = false
            self?.page = 1
            self?.loadMovies()
        }).disposed(by: disposeBag)
        
        loadMoreMovies.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            if self.canLoadMore {
                self.isLoadingMoreData.accept(true)
                self.loadMovies()
            }
        }).disposed(by: disposeBag)
    }
}

extension HomePresenter: HomePresenterProtocol {
    public var genresObservable: Observable<[Genre]> {
        genres.asObservable()
    }
    
    public var genreObservable: Observable<Genre?> {
        genre.asObservable()
    }
    
    public var moviesObservable: Observable<[Movie]> {
        movies.asObservable()
    }
    
    public var isLoadingObservable: Observable<Bool> {
        isLoading.asObservable()
    }
    
    public var isloadingGenreObservable: Observable<Bool> {
        isloadingGenre.asObservable()
    }
    
    public var isLoadingMoreDataObservable: Observable<Bool> {
        isLoadingMoreData.asObservable()
    }
    
    public var errorMessageObservable: Observable<String?> {
        errorMessage.asObservable()
    }
    
    public func loadCategories() {
        interactor?.fetchMovieGenres()
            .asObservable()
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                self.isloadingGenre.accept(false)
                self.genres.accept(response.genres)
            }).disposed(by: disposeBag)
    }
    
    public func loadMovies() {
        guard let genre = genre.value else { return }
        interactor?.fetchMovie(page: page, genre: genre)
            .asObservable()
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                self.isLoading.accept(false)
                self.isLoadingMoreData.accept(false)
                var tempMovies = self.movies.value
                tempMovies.append(contentsOf: response.results)
                if tempMovies.count < (response.totalResults) {
                    self.page += 1
                    self.canLoadMore = true
                } else {
                    self.canLoadMore = false
                }
                self.movies.accept(tempMovies)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                if let error = error as? APIError {
                    self.errorMessage.accept(error.errorDescription)
                }
            }).disposed(by: disposeBag)
    }
}
