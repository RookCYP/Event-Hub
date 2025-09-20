//
//  ShareGridView.swift
//  Event Hub
//
//  Created by Sergey Zakurakin on 9/19/25.
//

import SwiftUI

struct ShareGridView: View {
    let title: String
    let targets: [ShareTarget]
    let link: String
    let message: String

    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 4)
    private let iconSize: CGFloat = 40

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title)
                .padding(.top, 2)

            LazyVGrid(columns: columns, spacing: 24) {
                ForEach(targets) { target in
                    
                    if target == .copyLink, let url = URL(string: link) {
                        ShareLink(item: url) {
                            ShareCellView(target: target, iconSize: iconSize, isCopyStyle: true)
                        }
                    } else {
                        Button {
                            handleTap(target)
                        } label: {
                            ShareCellView(target: target, iconSize: iconSize, isCopyStyle: false)
                        }
                    }
                }
            }

            Button("CANCEL") {
                dismiss()
            }
                .foregroundStyle(.black)
                .font(.headline)
                .frame(maxWidth: .infinity, minHeight: 52)
                .background(Color(UIColor.systemGray6))
                .clipShape(
                    RoundedRectangle(cornerRadius: 14)
                )
                .padding(.horizontal, 10)
                .padding(.top, 35)
        }
        .padding(.horizontal, 32)
    }

    // MARK: - Actions (SwiftUI openURL)

    private func handleTap(_ target: ShareTarget) {
        switch target {
        case .copyLink:
            // Обработку копирования делает ShareLink
            break
        case .whatsapp:
            openDeepLink(scheme: "whatsapp://send?text=", encoded: "\(message) \(link)")
        case .telegram:
            openDeepLink(scheme: "tg://msg?text=", encoded: "\(message) \(link)")
        case .twitter:
            let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let encodedLink = link.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            openURLString("https://twitter.com/intent/tweet?text=\(encodedMessage)&url=\(encodedLink)")
        case .facebook:
            let encodedLink = link.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            openURLString("https://www.facebook.com/sharer/sharer.php?u=\(encodedLink)")
        case .messenger:
            let encodedLink = link.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            openURLString("fb-messenger://share?link=\(encodedLink)")
        case .instagram:
            openURLString("instagram://app")
        case .iMessage:
            let body = "\(message) \(link)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            openURLString("sms:&body=\(body)")
        }
    }

    private func openDeepLink(scheme: String, encoded text: String) {
        let full = scheme + (text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        openURLString(full)
    }

    private func openURLString(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        openURL(url) { accepted in
            if !accepted {
                // здесь можно показать Toast/Alert при желании
                print("Не удалось открыть: \(url)")
            }
        }
    }
}


#Preview("Share Grid") {
    ShareGridView(
        title: "Share with friends",
        targets: [.copyLink, .whatsapp, .telegram, .facebook, .messenger, .twitter, .instagram, .iMessage],
        link: "https://youreventhub.app/event/123",
        message: "International Band Music Concert — don’t miss it!"
    )
    .padding()
    .background(Color(.systemBackground))
}
