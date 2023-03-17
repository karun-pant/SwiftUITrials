//
//  AttributedLabel.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 16/03/23.
//

import SwiftUI

class LabelView: UIView {
    let boundingWidth: CGFloat
    let label: UILabel
    
    init(boundingWidth: CGFloat) {
        self.label = UILabel(frame: .init(origin: .zero,
                                          size: .init(width: boundingWidth,
                                                      height: 0)))
        self.boundingWidth = boundingWidth
        super.init(frame: .zero)
        setupView()
    }
    
    func setupView() {
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        addSubview(label)
        backgroundColor = .green
        label.backgroundColor = .brown
    }
    
    func setText(_ attributedText: NSAttributedString) {
        label.attributedText = attributedText
        label.sizeToFit()
        label.frame = CGRect(origin: label.frame.origin, size: .init(width: boundingWidth, height: label.frame.height))
        frame = label.frame
        
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct AttributedLabel: UIViewRepresentable {
    let attributedText: NSAttributedString
    let boundingWidth: CGFloat
    func makeUIView(context: Context) -> some UIView {
        let aView = LabelView(boundingWidth: boundingWidth)
        aView.setText(attributedText)
        aView.frame = aView.label.frame
        return aView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

struct AttributedLabel_Previews: PreviewProvider {
    static let attributedString = {
        let attributedString = NSMutableAttributedString(string: "Gooooogle something here!")
        attributedString.addAttribute(.link, value: "https://www.google.com", range: NSRange(location: 0, length: 5))
        return attributedString
    }()
    static var previews: some View {
        HStack {
            AttributedLabel(attributedText: attributedString, boundingWidth: 200)
            Spacer()
        }
        .background(Color.red)
    }
}
