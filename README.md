# RealDay - A Social Photo-Sharing App Prototype

RealDay is an iOS application prototype written in **Swift 6.0**, designed for devices running **iOS 18+**. The app operates entirely locally and provides a sleek user interface for exploring and sharing authentic moments through photos.

---

## Features

### **Account Management**
- **Create an Account**: Users can create a new account locally.
- **Login**: Authenticate with a username and password.
- **Sign in with Apple (UI only)**: A placeholder UI for signing in with Apple (functionality not implemented).

### **Dashboard**
- **Carousel View**: Browse posts from the last 24 hours in a carousel format, grouped by users.
- **Grid View**: View photos grouped by time periods (e.g., "This Morning", "Last Night") from the last 24 hours.

### **Profile Management**
- **User Profile**: View and edit your profile picture.
- **Other Profiles**: Explore the profiles of other users in the app.

### **Posts**
- **Add Post**: Capture a photo directly from your camera, add a caption, and share it.
- **Explore Posts**: View posts from users you follow, sorted by recency.

### **Search and Follow**
- **Search Users**: Find other users in the app using the search functionality.
- **Follow/Unfollow**: Follow users to see their posts in your feed or unfollow them if you wish.

---

## Requirements

- **iOS**: 18+
- **Swift**: 6.0
- **Xcode**: v16+

---

## Getting Started

### **Clone the Repository**
To get started, clone this repository:
```bash
git clone https://github.com/JohannPetzold/realday.git
cd RealDay
```

### Open the Project
Open the `realday.xcodeproj` file in Xcode 16+.

### Build and Run
1. Select your desired simulator or connected device.
2. Press `Cmd + R` to build and run the app.

---

## Known Limitations
- **Sign in with Apple**: Only the UI is implemented; the underlying functionality is not yet integrated.
- **Local-Only**: All data is stored and managed locally; no server or cloud integration is provided.
