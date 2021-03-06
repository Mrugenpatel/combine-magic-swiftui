//
//  GenericCombineStreamView.swift
//  CombineTutorial
//
//  Created by Kevin Cheng on 10/22/19.
//  Copyright © 2019 Kevin-Cheng. All rights reserved.
//

import SwiftUI
import Combine

struct GenericCombineStreamView: View {
    
    @State private var stream1Values: [String] = []
    
    @State private var stream2Values: [String] = []
    
    @State private var disposables = Set<AnyCancellable>()
    
    var navigationBarTitle: String?
    
    var description: String?
    
    var comparingPublisher: (AnyPublisher<String, Never>) -> (AnyPublisher<String, Never>)
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Text(description ?? "")
            .font(.system(.headline, design: .monospaced))
            .lineLimit(nil).padding()
            
            TunnelView(streamValues: $stream1Values)
            TunnelView(streamValues: $stream2Values)
            HStack {
                Button("Subscribe") {
                    self.disposables.forEach {
                        $0.cancel()
                    }
                    self.disposables.removeAll()
                    let publisher = self.invervalValuePublisher()
                    publisher.sink {
                        self.stream1Values.append($0)
                    }.store(in: &self.disposables)
                    let comparingPublisher = self.comparingPublisher(publisher)
                    comparingPublisher.sink {
                        self.stream2Values.append($0)
                    }.store(in: &self.disposables)
                }
                if self.disposables.count > 0 {
                    Button("Cancel") {
                        self.disposables.removeAll()
                    }
                } else {
                    Button("Clear") {
                        self.stream1Values.removeAll()
                        self.stream2Values.removeAll()
                    }
                }
            }
            Spacer()
        }.navigationBarTitle(navigationBarTitle ?? "")
    }
    
    func invervalValuePublisher() -> AnyPublisher<String, Never> {
        let publishers = (1...5).map { String($0) }
            .map { Just($0).delay(for: .seconds(1), scheduler: DispatchQueue.main).eraseToAnyPublisher() }
        return publishers[1...].reduce(publishers[0]) {
            Publishers.Concatenate(prefix: $0, suffix: $1).eraseToAnyPublisher()
        }
    }
}

struct GenericCombineStreamView_Previews: PreviewProvider {
    static var previews: some View {
        GenericCombineStreamView {
            $0.map { (Int($0) ?? 0) * 2 }.map { String($0) }.eraseToAnyPublisher()
        }
    }
}
