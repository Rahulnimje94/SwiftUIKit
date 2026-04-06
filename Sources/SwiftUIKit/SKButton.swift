import SwiftUI

// MARK: - Button Style Enum
public enum SKButtonStyle {
    case primary
    case secondary
    case destructive
    case ghost
    case outline
}

public enum SKButtonSize {
    case small
    case medium
    case large

    var padding: EdgeInsets {
        switch self {
        case .small: return EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        case .medium: return EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24)
        case .large: return EdgeInsets(top: 16, leading: 32, bottom: 16, trailing: 32)
        }
    }

    var fontSize: CGFloat {
        switch self {
        case .small: return 13
        case .medium: return 15
        case .large: return 17
        }
    }
}

// MARK: - SKButton
public struct SKButton: View {
    let title: String
    let style: SKButtonStyle
    let size: SKButtonSize
    let isLoading: Bool
    let isFullWidth: Bool
    let icon: String?
    let action: () -> Void

    public init(
        _ title: String,
        style: SKButtonStyle = .primary,
        size: SKButtonSize = .medium,
        isLoading: Bool = false,
        isFullWidth: Bool = false,
        icon: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.size = size
        self.isLoading = isLoading
        self.isFullWidth = isFullWidth
        self.icon = icon
        self.action = action
    }

    public var body: some View {
        Button(action: { if !isLoading { action() } }) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: foregroundColor))
                        .scaleEffect(0.8)
                } else {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: size.fontSize, weight: .medium))
                    }
                    Text(title)
                        .font(.system(size: size.fontSize, weight: .semibold))
                }
            }
            .padding(size.padding)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: style == .outline ? 1.5 : 0)
            )
        }
        .opacity(isLoading ? 0.8 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
    }

    private var backgroundColor: Color {
        switch style {
        case .primary: return .blue
        case .secondary: return Color.gray.opacity(0.15)
        case .destructive: return .red
        case .ghost: return .clear
        case .outline: return .clear
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .primary: return .white
        case .secondary: return .primary
        case .destructive: return .white
        case .ghost: return .blue
        case .outline: return .blue
        }
    }

    private var borderColor: Color {
        switch style {
        case .outline: return .blue
        default: return .clear
        }
    }
}

// MARK: - Icon Only Button
public struct SKIconButton: View {
    let icon: String
    let size: CGFloat
    let color: Color
    let action: () -> Void

    public init(
        icon: String,
        size: CGFloat = 44,
        color: Color = .blue,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.size = size
        self.color = color
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size * 0.4, weight: .medium))
                .foregroundColor(color)
                .frame(width: size, height: size)
                .background(color.opacity(0.1))
                .clipShape(Circle())
        }
    }
}

// MARK: - Loading Button (Standalone)
public struct SKLoadingButton: View {
    let title: String
    let isLoading: Bool
    let action: () -> Void

    @State private var dotCount: Int = 0
    private let timer = Timer.publish(every: 0.4, on: .main, in: .common).autoconnect()

    public init(_ title: String, isLoading: Bool, action: @escaping () -> Void) {
        self.title = title
        self.isLoading = isLoading
        self.action = action
    }

    public var body: some View {
        SKButton(
            isLoading ? "Loading" + String(repeating: ".", count: dotCount) : title,
            style: .primary,
            isLoading: isLoading,
            isFullWidth: true,
            action: action
        )
        .onReceive(timer) { _ in
            if isLoading {
                dotCount = (dotCount % 3) + 1
            }
        }
    }
}
