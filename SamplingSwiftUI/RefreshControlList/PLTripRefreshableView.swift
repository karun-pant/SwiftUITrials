//
//  CustomScrollView.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 22/11/21.
//

import SwiftUI
import UIKit

struct PLTripRefreshableView<REFRESHABLEROOTVIEW>: UIViewRepresentable where REFRESHABLEROOTVIEW: View {
    
    var size: CGSize
    @Binding var attributedTitle: NSAttributedString?
    var onRefreshControlTriggered: (() -> Void)
    var onOpenTray: (() -> ())? = nil
    var onCloseTray: (() -> ())? = nil
    @Binding var isRefreshComplete: Bool
    let content: () -> REFRESHABLEROOTVIEW
    
    func makeCoordinator() -> Coordinator<REFRESHABLEROOTVIEW> {
        let coordinator = Coordinator(self, rootView: content)
        coordinator.onRefreshControlTriggered = onRefreshControlTriggered
        coordinator.onOpenTray = onOpenTray
        coordinator.onCloseTray = onCloseTray
        return coordinator
    }

    func makeUIView(context: Context) -> UIScrollView {
        let control = UIScrollView()
        control.delegate = context.coordinator
        control.refreshControl = UIRefreshControl()
        control.refreshControl?.attributedTitle = attributedTitle
        control.refreshControl?.addTarget(context.coordinator,
                                          action: #selector(Coordinator.handleRefreshControl),
                                          for: .valueChanged)
        let childView = UIHostingController(rootView: content() )
        childView.view.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        control.addSubview(childView.view)
        return control
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        uiView.refreshControl?.attributedTitle = attributedTitle
        if isRefreshComplete {
            DispatchQueue.main.async {
                isRefreshComplete.toggle()
                uiView.refreshControl?.endRefreshing()
            }
        }
    }
    
    class Coordinator<REFRESHABLEROOTVIEW>: NSObject, UIScrollViewDelegate where REFRESHABLEROOTVIEW: View {
        var refreshableView: PLTripRefreshableView<REFRESHABLEROOTVIEW>
        var onRefreshControlTriggered: (() -> Void)? = nil
        var onOpenTray: (() -> ())? = nil
        var onCloseTray: (() -> ())? = nil
        var rootView: () -> REFRESHABLEROOTVIEW
        private var isShowingRefreshControl: Bool = false

        init(_ control: PLTripRefreshableView<REFRESHABLEROOTVIEW>,
             rootView: @escaping () -> REFRESHABLEROOTVIEW) {
            self.refreshableView = control
            self.rootView = rootView
        }

        @objc func handleRefreshControl(sender: UIRefreshControl) {
            onRefreshControlTriggered?()
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            handleDragging(scrollView)
        }
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            handleDragging(scrollView)
        }
        private func handleDragging(_ scrollView: UIScrollView) {
            if let onOpenTray = onOpenTray,
                !self.isShowingRefreshControl,
                scrollView.contentOffset.y < 0 {
                isShowingRefreshControl = true
                onOpenTray()
            } else if let onCloseTray = onCloseTray,
                        self.isShowingRefreshControl,
                      scrollView.contentOffset.y == 0 {
                isShowingRefreshControl = false
                onCloseTray()
            }
        }
    }
}
