import SwiftUI
import Combine

// MARK: - Toast Type
public enum SKToastType {
    case success
    case error
    case warning
    case info

    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .info: return "info.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .success: return .green
        case .error: return .red
        case .warning: return .orange
        case .info: return .blue
        }
    }
}

// MARK: - SKToast Model
public struct SKToastModel: Equatable {
    public let message: String
    public let type: SKToastType
    public let duration: Double

    public init(message: String, type: SKToastType = .info, duration: Double = 3.0) {
        self.message = message
        self.type = type
        self.duration = duration
    }

    public static func == (lhs: SKToastModel, rhs: SKToastModel) -> Bool {
        lhs.message == rhs.message && lhs.duration == rhs.duration
    }
}

// MARK: - SKToastView
public struct SKToastView: View {
    let toast: SKToastModel

    public init(toast: SKToastModel) {
        self.toast = toast
    }

    public var body: some View {
        HStack(spacing: 10) {
            Image(systemName: toast.type.icon)
                .foregroundColor(toast.type.color)
                .font(.system(size: 18, weight: .semibold))
            Text(toast.message)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(toast.type.color.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}

// MARK: - Toast View Modifier
public struct SKToastModifier: ViewModifier {
    @Binding var toast: SKToastModel?
    @State private var isShowing = false
    @State private var workItem: DispatchWorkItem?

    public func body(content: Content) -> some View {
        content
            .overlay(
                ZStack {
                    if isShowing, let toast = toast {
                        VStack {
                            SKToastView(toast: toast)
                                .transition(.move(edge: .top).combined(with: .opacity))
                            Spacer()
                        }
                        .padding(.top, 16)
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isShowing)
                    }
                }
            )
            .onChange(of: toast) { newValue in
                if let toast = newValue {
                    showToast(toast)
                }
            }
    }

    private func showToast(_ toast: SKToastModel) {
        workItem?.cancel()
        withAnimation { isShowing = true }
        let task = DispatchWorkItem {
            withAnimation { isShowing = false }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.toast = nil
            }
        }
        workItem = task
        DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
    }
}

public extension View {
    func skToast(toast: Binding<SKToastModel?>) -> some View {
        modifier(SKToastModifier(toast: toast))
    }
}

// MARK: - SKAlertButton
public struct SKAlertButton {
    public let title: String
    public let role: ButtonRole?
    public let action: () -> Void

    public init(title: String, role: ButtonRole? = nil, action: @escaping () -> Void) {
        self.title = title
        self.role = role
        self.action = action
    }
}

// MARK: - SKAlert
public struct SKAlert: View {
    let title: String
    let message: String
    let type: SKToastType
    let buttons: [SKAlertButton]
    @Binding var isPresented: Bool

    public init(
        title: String,
        message: String,
        type: SKToastType = .info,
        buttons: [SKAlertButton],
        isPresented: Binding<Bool>
    ) {
        self.title = title
        self.message = message
        self.type = type
        self.buttons = buttons
        self._isPresented = isPresented
    }

    public var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { isPresented = false }

            VStack(spacing: 0) {
                VStack(spacing: 12) {
                    Image(systemName: type.icon)
                        .font(.system(size: 40))
                        .foregroundColor(type.color)

                    Text(title)
                        .font(.system(size: 17, weight: .bold))
                        .multilineTextAlignment(.center)

                    Text(message)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(24)

                Divider()

                HStack(spacing: 0) {
                    ForEach(Array(buttons.enumerated()), id: \.offset) { index, button in
                        if index > 0 { Divider().frame(height: 50) }
                        Button(action: {
                            button.action()
                            isPresented = false
                        }) {
                            Text(button.title)
                                .font(.system(size: 16, weight: button.role == .cancel ? .regular : .semibold))
                                .foregroundColor(button.role == .destructive ? .red : .blue)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                        }
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(20)
            .padding(.horizontal, 40)
        }
    }
}
