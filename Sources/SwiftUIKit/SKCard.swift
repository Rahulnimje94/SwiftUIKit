import SwiftUI

// MARK: - SKCard
public struct SKCard<Content: View>: View {
    let content: Content
    let padding: CGFloat
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    let backgroundColor: Color

    public init(
        padding: CGFloat = 16,
        cornerRadius: CGFloat = 16,
        shadowRadius: CGFloat = 6,
        backgroundColor: Color = Color(.white),
        @ViewBuilder content: () -> Content
    ) {
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.backgroundColor = backgroundColor
        self.content = content()
    }

    public var body: some View {
        content
            .padding(padding)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(color: .black.opacity(0.08), radius: shadowRadius, x: 0, y: 2)
    }
}

// MARK: - SKInfoCard
public struct SKInfoCard: View {
    let title: String
    let subtitle: String?
    let icon: String?
    let iconColor: Color
    let trailing: String?

    public init(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        iconColor: Color = .blue,
        trailing: String? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.iconColor = iconColor
        self.trailing = trailing
    }

    public var body: some View {
        SKCard {
            HStack(spacing: 12) {
                if let icon = icon {
                    ZStack {
                        Circle()
                            .fill(iconColor.opacity(0.15))
                            .frame(width: 44, height: 44)
                        Image(systemName: icon)
                            .foregroundColor(iconColor)
                            .font(.system(size: 18, weight: .medium))
                    }
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.primary)
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                if let trailing = trailing {
                    Text(trailing)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

// MARK: - SKStatCard
public struct SKStatCard: View {
    let title: String
    let value: String
    let change: String?
    let isPositive: Bool
    let icon: String
    let color: Color

    public init(
        title: String,
        value: String,
        change: String? = nil,
        isPositive: Bool = true,
        icon: String,
        color: Color = .blue
    ) {
        self.title = title
        self.value = value
        self.change = change
        self.isPositive = isPositive
        self.icon = icon
        self.color = color
    }

    public var body: some View {
        SKCard(backgroundColor: color.opacity(0.08)) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.system(size: 16, weight: .medium))
                    Spacer()
                    if let change = change {
                        HStack(spacing: 2) {
                            Image(systemName: isPositive ? "arrow.up.right" : "arrow.down.right")
                            Text(change)
                        }
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(isPositive ? .green : .red)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background((isPositive ? Color.green : Color.red).opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                Text(value)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.primary)
                Text(title)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - SKListTile
public struct SKListTile: View {
    let title: String
    let subtitle: String?
    let leading: AnyView?
    let trailing: AnyView?
    let onTap: (() -> Void)?

    public init(
        title: String,
        subtitle: String? = nil,
        leading: AnyView? = nil,
        trailing: AnyView? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.leading = leading
        self.trailing = trailing
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: { onTap?() }) {
            HStack(spacing: 12) {
                leading
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.primary)
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                trailing ?? AnyView(
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.secondary)
                )
            }
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
    }
}
