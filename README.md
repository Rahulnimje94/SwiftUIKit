# SwiftUIKit 🧩

A lightweight, production-ready SwiftUI component library for iOS developers. Build beautiful, consistent UIs faster — without reinventing the wheel.

![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![iOS](https://img.shields.io/badge/iOS-16.0+-blue.svg)
![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)
![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)

---


<p align="center">
  <img src="https://github.com/user-attachments/assets/25a07630-2052-4d7b-92e2-f3e3e2cefd75" width="45%" />
  <img src="https://github.com/user-attachments/assets/b42534fe-fbfa-47ca-8ead-0499cd664fc4" width="45%" />
</p>

![Image 1](path/to/image1.png) ![Image 2](path/to/image2.png)

## ✨ Features

| Category | Components |
|---|---|
| 🔘 **Buttons** | `SKButton`, `SKLoadingButton`, `SKIconButton` |
| 🃏 **Cards** | `SKCard`, `SKInfoCard`, `SKStatCard`, `SKListTile` |
| 🔔 **Toast & Alerts** | `SKToastView`, `SKAlert` |
| 📝 **Forms** | `SKTextField`, `SKToggleField`, `SKPickerField` |
| 🛠️ **Extensions** | Color(hex:), View modifiers, String validators |

---

## 📦 Installation

### Swift Package Manager

In Xcode: `File → Add Package Dependencies`

```
https://github.com/rahulnimje/SwiftUIKit
```

Or add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/rahulnimje/SwiftUIKit.git", from: "1.0.0")
]
```

---

## 🚀 Quick Start

```swift
import SwiftUIKit
```

---

## 📖 Usage

### Buttons

```swift
// Primary Button
SKButton("Get Started", style: .primary, size: .large) {
    print("Tapped!")
}

// Loading Button
SKButton("Submit", style: .primary, isLoading: true) { }

// With Icon
SKButton("Delete", style: .destructive, icon: "trash") {
    deleteItem()
}

// Full Width Outline
SKButton("Sign In", style: .outline, isFullWidth: true) {
    signIn()
}

// Icon Only
SKIconButton(icon: "heart.fill", color: .red) {
    toggleFavourite()
}
```

### Cards

```swift
// Basic Card
SKCard {
    Text("Hello, World!")
}

// Info Card
SKInfoCard(
    title: "John Doe",
    subtitle: "iOS Developer",
    icon: "person.fill",
    iconColor: .blue,
    trailing: "Berlin"
)

// Stat Card
SKStatCard(
    title: "Portfolio Value",
    value: "₹16L",
    change: "+8.4%",
    isPositive: true,
    icon: "chart.line.uptrend.xyaxis",
    color: .green
)

// List Tile
SKListTile(
    title: "Settings",
    subtitle: "Manage your preferences",
    leading: AnyView(Image(systemName: "gear").foregroundColor(.blue)),
    onTap: { navigate() }
)
```

### Toast Notifications

```swift
struct ContentView: View {
    @State private var toast: SKToastModel?

    var body: some View {
        VStack {
            SKButton("Show Toast", style: .primary) {
                toast = SKToastModel(message: "Saved successfully!", type: .success)
            }
        }
        .skToast(toast: $toast)
    }
}
```

### Custom Alerts

```swift
SKAlert(
    title: "Delete Account",
    message: "This action cannot be undone.",
    type: .error,
    buttons: [
        SKAlertButton(title: "Cancel", role: .cancel) { },
        SKAlertButton(title: "Delete", role: .destructive) { deleteAccount() }
    ],
    isPresented: $showAlert
)
```

### Form Fields

```swift
// Text Field with Validation
SKTextField(
    "Email",
    placeholder: "you@example.com",
    text: $email,
    icon: "envelope",
    rules: [.required, .email],
    keyboardType: .emailAddress
)

// Secure Field
SKTextField(
    "Password",
    placeholder: "Enter password",
    text: $password,
    icon: "lock",
    rules: [.required, .minLength(8)],
    isSecure: true
)

// Toggle
SKToggleField("Push Notifications", subtitle: "Get alerts for updates", isOn: $notifications)

// Picker
SKPickerField("Country", options: ["India", "Germany", "New Zealand"], selection: $country)
```

### Extensions

```swift
// Hex Color
Color(hex: "#FF6B6B")

// Conditional Modifier
Text("Hello")
    .if(isHighlighted) { $0.bold() }

// Specific Corner Radius
View()
    .cornerRadius(16, corners: [.topLeft, .topRight])

// Skeleton Loading
Text("Loading content...")
    .skSkeleton(isLoading: true)

// String Validation
"test@email.com".isValidEmail // true
"+91 9876543210".isValidPhone  // true
```

---

## 🎨 Customisation

All components are built with sensible defaults but are fully customisable:

```swift
SKCard(
    padding: 20,
    cornerRadius: 20,
    shadowRadius: 10,
    backgroundColor: Color(.systemGray6)
) {
    // Your content
}
```

---

## 📋 Requirements

- iOS 16.0+
- Swift 5.9+
- Xcode 15.0+

---

## 🤝 Contributing

Contributions are welcome! Please open an issue or submit a PR.

1. Fork the repo
2. Create your feature branch (`git checkout -b feature/AmazingComponent`)
3. Commit your changes (`git commit -m 'Add AmazingComponent'`)
4. Push to the branch (`git push origin feature/AmazingComponent`)
5. Open a Pull Request

---

## 📄 License

SwiftUIKit is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

---

## 👨‍💻 Author

**Rahul Nimje** — Senior iOS Developer  
[GitHub](https://github.com/rahulnimje) · [LinkedIn](https://linkedin.com/in/rahulnimje)

> Built with ❤️ in Bangalore, India
