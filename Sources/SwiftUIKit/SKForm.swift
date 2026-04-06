import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

public enum SKKeyboardType {
    case `default`
    case emailAddress
    case numberPad
    case phonePad
    case decimalPad
    case url
}

#if canImport(UIKit)
private extension SKKeyboardType {
    var uiKeyboardType: UIKeyboardType {
        switch self {
        case .default:
            return .default
        case .emailAddress:
            return .emailAddress
        case .numberPad:
            return .numberPad
        case .phonePad:
            return .phonePad
        case .decimalPad:
            return .decimalPad
        case .url:
            return .URL
        }
    }
}
#endif

// MARK: - Validation
public enum SKValidationRule {
    case required
    case minLength(Int)
    case maxLength(Int)
    case email
    case phone
    case numeric
    case custom(String, (String) -> Bool)

    func validate(_ value: String) -> String? {
        switch self {
        case .required:
            return value.trimmingCharacters(in: .whitespaces).isEmpty ? "This field is required" : nil
        case .minLength(let min):
            return value.count < min ? "Minimum \(min) characters required" : nil
        case .maxLength(let max):
            return value.count > max ? "Maximum \(max) characters allowed" : nil
        case .email:
            let regex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
            let valid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: value)
            return valid ? nil : "Enter a valid email address"
        case .phone:
            let digits = value.filter { $0.isNumber }
            return digits.count >= 10 ? nil : "Enter a valid phone number"
        case .numeric:
            return value.allSatisfy({ $0.isNumber }) ? nil : "Only numbers are allowed"
        case .custom(let message, let validator):
            return validator(value) ? nil : message
        }
    }
}

// MARK: - SKTextField
public struct SKTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let icon: String?
    let rules: [SKValidationRule]
    let isSecure: Bool
    let keyboardType: SKKeyboardType

    @State private var errorMessage: String? = nil
    @State private var isFocused: Bool = false
    @State private var showPassword: Bool = false

    public init(
        _ title: String,
        placeholder: String = "",
        text: Binding<String>,
        icon: String? = nil,
        rules: [SKValidationRule] = [],
        isSecure: Bool = false,
        keyboardType: SKKeyboardType = .default
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.icon = icon
        self.rules = rules
        self.isSecure = isSecure
        self.keyboardType = keyboardType
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.secondary)

            HStack(spacing: 10) {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(isFocused ? .blue : .secondary)
                        .font(.system(size: 15))
                        .frame(width: 20)
                }

                Group {
                    if isSecure && !showPassword {
                        SecureField(placeholder, text: $text)
                    } else {
                        textField
                    }
                }
                .font(.system(size: 15))
                .onChange(of: text) { _ in
                    if errorMessage != nil { validate() }
                }

                if isSecure {
                    Button(action: { showPassword.toggle() }) {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.secondary)
                            .font(.system(size: 14))
                    }
                }

                if !text.isEmpty && !isSecure {
                    Button(action: { text = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .font(.system(size: 14))
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.gray.opacity(0.12))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        errorMessage != nil ? Color.red :
                        isFocused ? Color.blue : Color.clear,
                        lineWidth: 1.5
                    )
            )
            .onTapGesture { isFocused = true }

            if let error = errorMessage {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 11))
                    Text(error)
                        .font(.system(size: 12))
                }
                .foregroundColor(.red)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: errorMessage)
    }

    public func validate() {
        for rule in rules {
            if let error = rule.validate(text) {
                errorMessage = error
                return
            }
        }
        errorMessage = nil
    }

    @ViewBuilder
    private var textField: some View {
        #if canImport(UIKit)
        TextField(placeholder, text: $text)
            .keyboardType(keyboardType.uiKeyboardType)
        #else
        TextField(placeholder, text: $text)
        #endif
    }
}

// MARK: - SKToggleField
public struct SKToggleField: View {
    let title: String
    let subtitle: String?
    @Binding var isOn: Bool
    let tintColor: Color

    public init(
        _ title: String,
        subtitle: String? = nil,
        isOn: Binding<Bool>,
        tintColor: Color = .blue
    ) {
        self.title = title
        self.subtitle = subtitle
        self._isOn = isOn
        self.tintColor = tintColor
    }

    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            Toggle("", isOn: $isOn)
                .tint(tintColor)
                .labelsHidden()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - SKPickerField
public struct SKPickerField: View {
    let title: String
    let options: [String]
    @Binding var selection: String

    public init(_ title: String, options: [String], selection: Binding<String>) {
        self.title = title
        self.options = options
        self._selection = selection
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.secondary)

            Menu {
                ForEach(options, id: \.self) { option in
                    Button(option) { selection = option }
                }
            } label: {
                HStack {
                    Text(selection.isEmpty ? "Select \(title)" : selection)
                        .font(.system(size: 15))
                        .foregroundColor(selection.isEmpty ? .secondary : .primary)
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color.gray.opacity(0.12))
                .cornerRadius(12)
            }
        }
    }
}
