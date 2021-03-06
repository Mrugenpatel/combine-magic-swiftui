//
//  CombineStreamView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/7/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI
import Combine
struct MultiValueStreamView: View {
    @ObservedObject var viewModel: StreamViewModel<[String]>

    var displayActionButtons: Bool = true

    var updateView: AnyView? {
        guard let updtableStreamViewModel = viewModel as? UpdatableStreamViewModel else {
            return nil
        }
        if let updateOperationStreamViewModel = updtableStreamViewModel.updateOperationStreamViewModel {
            return AnyView(UpdateOperationStreamView(viewModel: updateOperationStreamViewModel))
        } else if let updateUnifyingStreamViewModel = updtableStreamViewModel.updateUnifyingStreamViewModel {
          return AnyView(UpdateUnifyingStreamView(viewModel: updateUnifyingStreamViewModel))
        } else if let updateJoinStreamViewModel = updtableStreamViewModel.updateJoinStreamViewModel {
          return AnyView(UpdateJoinStreamView(viewModel: updateJoinStreamViewModel))
        } else {
            return nil
        }
    }

    var navigationView: some View {
        guard let updateView = updateView else {
            return AnyView(EmptyView())
        }
        return AnyView(NavigationLink(
            destination: updateView,
            label: {
                HStack {
                    Spacer()
                    Image(systemName: "pencil.circle")
                    .font(.system(size: 25, weight: .light))
                }.padding(.trailing, 10)
        }))
    }

    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            ZStack {
                Text(viewModel.title)
                    .font(.system(.headline, design: .monospaced))
                    .lineLimit(nil)
                self.navigationView
            }

            Text(viewModel.updatableDescription)
                       .font(.system(.subheadline, design: .monospaced))
                       .lineLimit(nil)

            MultiBallTunnelView(values: $viewModel.values, color: .green,
                                animationSecond: viewModel.animationSeconds).frame(maxHeight: 100)

            if displayActionButtons {
                HStack {
                    CombineDemoButton(text: "Subscribe", backgroundColor: .blue) {
                      self.viewModel.subscribe()
                    }

                    CombineDemoButton(text: "Cancel", backgroundColor: .red) {
                      self.viewModel.cancel()
                    }
                }.padding()
            }
            Spacer()
        }
    }
}

#if DEBUG
struct CombineSingleStreamView_Previews: PreviewProvider {
    static var previews: some View {
        MultiValueStreamView(viewModel: StreamViewModel<[String]>(title: "Stream A",
                                                                  description: "Sequence(A,B,C,D)",
                                                                  publisher: Empty().eraseToAnyPublisher()))
    }
}
#endif
