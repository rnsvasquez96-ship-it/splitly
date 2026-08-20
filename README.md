# Splitly 💸

Splitly is a modern group expense management mobile application built with Flutter. It helps users organize shared expenses, manage groups and members, track spending, calculate balances and settlements, set category budgets, and analyze spending activity.

The project was built as a portfolio application demonstrating mobile development, application architecture, Firebase integration, local data management, data visualization, and responsive UI design.

## ✨ Features

### 👥 Group Management
- Create and manage expense groups
- Add, edit, and remove members
- Search existing groups
- View group spending summaries

### 💳 Expense Tracking
- Add, edit, and delete expenses
- Assign who paid for an expense
- Categorize expenses
- Track expenses for individual groups
- View recent transactions

### ⚖️ Balance & Settlement
- Calculate member balances
- Determine who owes whom
- Generate settlement recommendations
- View group expense totals

### 📊 Analytics Dashboard
- Total spending overview
- Group and member statistics
- Transaction count
- Average expense
- Largest expense
- Top spender
- Monthly spending chart
- Expense category breakdown

### 🎯 Budget Tracking
- Create category-based budgets
- Monitor spending against budget limits
- Visual budget progress indicators
- Warning states as spending approaches the limit

### 📄 PDF Reports
- Generate group expense reports
- Export expense and settlement information
- Shareable report format

### 🔐 Authentication & Data
- Firebase Authentication
- Cloud Firestore integration
- Persistent application data
- User-based application experience

### 🎨 User Experience
- Modern Material UI
- Responsive mobile layout
- Animated dashboard statistics
- Smooth transitions
- Pull-to-refresh
- Empty states
- Bottom navigation
- Light and dark theme support

## 🛠 Tech Stack

| Technology | Purpose |
| --- | --- |
| Flutter | Mobile application development |
| Dart | Programming language |
| Firebase Authentication | User authentication |
| Cloud Firestore | Cloud database |
| fl_chart | Analytics charts |
| Shared Preferences | Local persistence |
| PDF | Report generation |
| UUID | Unique identifiers |
| Git | Version control |
| GitHub | Source code management |

## 📱 Application Sections

Splitly contains five primary areas:

**Home** — Dashboard showing spending totals, statistics, quick actions, recent groups, and recent expenses.

**Groups** — Create and manage groups, members, expenses, balances, and settlements.

**Budgets** — Define spending limits for expense categories and monitor budget usage.

**Analytics** — Visualize spending patterns, category distribution, monthly activity, and important statistics.

**Settings** — Manage application preferences and account-related options.

## 📸 Screenshots

Screenshots will be added here before the final portfolio release.

| Dashboard | Groups | Group Details |
| --- | --- | --- |
| Coming Soon | Coming Soon | Coming Soon |

| Budgets | Analytics | Settings |
| --- | --- | --- |
| Coming Soon | Coming Soon | Coming Soon |

## 🚀 Getting Started

### Prerequisites

Make sure the following are installed:

- Flutter SDK
- Dart SDK
- Android Studio or VS Code
- Android SDK
- Git

Check your Flutter environment:

```bash
flutter doctor
```

### Installation

Clone the repository:

```bash
git clone <YOUR-REPOSITORY-URL>
```

Open the mobile application:

```bash
cd splitly/mobile
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

## 📁 Project Structure

```text
lib/
├── app/
│   ├── theme/
│   └── widgets/
│
├── features/
│   ├── analytics/
│   ├── auth/
│   ├── budget/
│   ├── dashboard/
│   ├── expenses/
│   ├── groups/
│   ├── reports/
│   └── settlements/
│
├── firestore/
│   ├── repositories/
│   └── services/
│
└── main.dart
```

The project follows a feature-based structure to keep models, repositories, services, presentation logic, and reusable widgets organized.

## 🧠 What I Learned

Building Splitly strengthened my experience with:

- Flutter and Dart application development
- Feature-based project architecture
- Firebase Authentication
- Firestore database integration
- CRUD operations
- State and data management
- Expense calculation logic
- Budget tracking
- Data visualization
- PDF generation
- Form validation
- Responsive mobile UI design
- Debugging and application testing
- Git and GitHub workflows

## 🔮 Future Improvements

Potential future improvements include:

- Group invitations
- Real-time collaborative expense updates
- Multiple currencies
- Receipt image attachments
- Recurring expenses
- Advanced analytics filters
- Cloud synchronization improvements
- Push notifications
- Expense history export
- Additional settlement options

## 🎥 Demo

A demonstration video will be added before the final portfolio release.

## 👨‍💻 Author

**Ranz Nathaniel S. Vasquez**

Computer Engineering graduate focused on software development, full-stack web development, mobile development, and quality assurance.

GitHub: `rnsvasquez96-ship-it`

---

Built with Flutter 💙
