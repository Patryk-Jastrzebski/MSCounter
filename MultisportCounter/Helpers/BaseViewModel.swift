//
//  BaseViewModel.swift
//  MultisportCounter
//
//  Created by Patryk Jastrzębski on 14/11/2023.
//

import SwiftUI

protocol BaseViewModel: AnyObject, ObservableObject {
    var defaultErrorDescription: String { get set }
    var apiErrorDescription: String? { get set }
    var apiError: Bool { get set }
    var isLoading: Bool { get set }
    func handleError(_ string: String?)
    func hideError()
    func setLoadingState(_ loadingState: Bool)
}

extension BaseViewModel {
    @MainActor func apiFunction<ResponseData>(with method: () async throws -> ResponseData,
                                              successAction: (@MainActor (_ data: ResponseData) async -> Void)? = nil) async {
        setLoadingState(true)
        do {
            let response = try await method()
            if let successAction {
                await successAction(response)
            }
        } catch let AppError.apiError(_, data) {
            handleError(data?.getErrorMessage())
        } catch {
            handleError(nil)
        }
        setLoadingState(false)
    }
    
    @MainActor func apiFunction<ResponseData, RequestData>(data: RequestData,
                                                           with method: (RequestData) async throws -> ResponseData,
                                                           successAction: (@MainActor (_ data: ResponseData) async -> Void)? = nil) async {
        setLoadingState(true)
        do {
            let response = try await method(data)
            if let successAction {
                await successAction(response)
            }
        } catch let AppError.apiError(_, data) {
            handleError(data?.getErrorMessage())
        } catch {
            handleError(nil)
        }
        setLoadingState(false)
    }
    
    func handleError(_ string: String?) {
        Task {
            await showError(string)
        }
    }
    
    func hideError() {
        Task {
            await handleHideError()
        }
    }
    
    func setLoadingState(_ loadingState: Bool) {
        Task {
            await changeLoadingState(loadingState)
        }
    }
}

private extension BaseViewModel {
    @MainActor func changeLoadingState(_ loadingState: Bool) {
        withAnimation(.default) { [weak self] in
            self?.isLoading = loadingState
        }
    }
    
    @MainActor func handleHideError() {
        withAnimation(.default) { [weak self] in
            self?.apiError = false
            self?.apiErrorDescription = nil
        }
    }
    
    @MainActor func showError(_ string: String?) {
        apiErrorDescription = string ?? defaultErrorDescription
        withAnimation(.default) {
            setLoadingState(false)
            apiError = true
        }
    }
}

extension Data {
    func getErrorMessage() -> String? {
        if let errorMessage = try? JSONDecoder.default.decode(ErrorMessage.self, from: self) {
            return errorMessage.message
        }
        return nil
    }
}

struct ErrorMessage: Codable {
    let message: String
}

extension JSONDecoder {
    static var `default`: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
}
