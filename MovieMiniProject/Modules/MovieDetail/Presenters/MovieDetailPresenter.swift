//
//  MovieDetailPresenter.swift
//  MovieMiniProject
//
//  Created by Michael Iskandar on 04/08/23.
//

import Foundation
import RxSwift
import RxRelay

public protocol MovieDetailPresenterProtocol {
    func loadMovieDetail()
    func loadReviews()
    
    var loadMoreReviews: PublishSubject<Void> { get set }
    
    var movieObservable: Observable<Movie> { get }
    var reviewsObservable: Observable<[Review]> { get }
    var isLoadingObservable: Observable<Bool> { get }
    var isLoadingMoreDataObservable: Observable<Bool> { get }
    var errorObservable: Observable<String?> { get }
}

final public class MovieDetailPresenter {
    
    private var interactor: MovieDetailInteractorProtocol?
    private var movieId: Int
    
    private var movie: PublishSubject<Movie> = PublishSubject<Movie>()
    public var movieObservable: Observable<Movie> { movie.asObservable() }
    
    private var reviews: BehaviorRelay<[Review]> = .init(value: [])
    public var reviewsObservable: Observable<[Review]> { reviews.asObservable() }
    
    private var isLoading: BehaviorRelay<Bool> = .init(value: true)
    public var isLoadingObservable: Observable<Bool> { isLoading.asObservable() }
    
    private var isLoadingMoreData: BehaviorRelay<Bool> = .init(value: false)
    public var isLoadingMoreDataObservable: Observable<Bool> { isLoadingMoreData.asObservable() }
    
    public var loadMoreReviews: PublishSubject<Void> = PublishSubject<Void>()
    
    private var errorMessage: PublishSubject<String?> = PublishSubject<String?>()
    public var errorObservable: Observable<String?> { errorMessage.asObservable() }
    
    private let disposeBag = DisposeBag()
    
    private var page = 1
    private var canLoadMore = true
    
    public init(movieId: Int, interactor: MovieDetailInteractorProtocol) {
        self.movieId = movieId
        self.interactor = interactor
        loadMovieDetail()
        
        loadMoreReviews.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            if self.canLoadMore {
                self.isLoadingMoreData.accept(true)
                self.loadReviews()
            }
        }).disposed(by: disposeBag)
    }
}

extension MovieDetailPresenter: MovieDetailPresenterProtocol {

    public func loadMovieDetail() {
        interactor?.fetchMovieDetail(id: movieId)
            .asObservable()
            .subscribe(onNext: { [weak self] movie in
                guard let self = self else { return }
                self.movie.onNext(movie)
                self.loadReviews()
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.isLoading.accept(false)
                if let error = error as? APIError {
                    self.errorMessage.onNext(error.errorDescription)
                }
            }).disposed(by: disposeBag)
    }
    
    public func loadReviews() {
        interactor?.fetchMovieReviews(id: movieId, page: page)
            .asObservable()
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                self.isLoadingMoreData.accept(false)
                var tempReviews = self.reviews.value
                tempReviews.append(contentsOf: response.results)
                if tempReviews.count < (response.totalResults) {
                    self.page += 1
                    self.canLoadMore = true
                } else {
                    self.canLoadMore = false
                }
                self.reviews.accept(tempReviews)
            }, onError: { [weak self] error in
                guard let self = self else { return }
                if let error = error as? APIError {
                    self.errorMessage.onNext(error.errorDescription)
                }
            }).disposed(by: disposeBag)
    }
}
