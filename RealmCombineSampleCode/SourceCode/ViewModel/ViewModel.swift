//
//  ViewModel.swift
//  Created by GaliSrikanth on 22/06/24.

import Foundation
import Combine
import RealmSwift

class ViewModel: ObservableObject {
    @Published var dataArr: [PostModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let apiClient: ApiClientUseCase
    private var cancellables = Set<AnyCancellable>()
    //private var realm: Realm
    
    init(apiClient: ApiClientUseCase = ApiClientService()) {
        self.apiClient = apiClient
      //  self.realm = try! Realm()
        fetchPersistedPosts()
    }
    
    func fetchPosts() {
        isLoading = true
        apiClient.fetchData()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] posts in
                self?.dataArr = posts
                self?.savePosts(WithPostsArr: posts)
            })
            .store(in: &cancellables)
    }
    
    func fetchPersistedPosts() {
        DispatchQueue(label: "realm").async {
            let realm = try! Realm()
            let realmPosts = realm.objects(PostModelRealm.self)
            let posts = realmPosts.map { PostModel(title: $0.title, body: $0.body) }
            self.dataArr = Array(posts)
        }
    }
    
    private func savePosts(WithPostsArr posts: [PostModel]) {
        DispatchQueue(label: "realm").async {
            let realm = try! Realm()
            try! realm.write {
                realm.delete(realm.objects(PostModelRealm.self))
                posts.forEach { post in
                    let realmPost = PostModelRealm()
                    realmPost.title = post.title ?? ""
                    realmPost.body = post.body ?? ""
                    realm.add(realmPost)
                }
            }
        }
    }
}
