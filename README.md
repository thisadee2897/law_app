# law_safety

## app name : law_safety

## Project description

- Framework : Flutter
- Language : Dart
- Version : 1.0.0
- offline : Yes
- online : no
- Notification : Yes
- State management : Riverpod
- Architecture : MVVM
- Dependency Injection : GetIt
- Router : Go Router
- Database : ObjectBoxDatabase
- Platform : Android, iOS
- Responsive : Yes
- Design : Material Design
- Theme : Light, Dark
- Localization : Yes
- Testing : No
- CI/CD : No
- Features :
  - สามารถจักการ การแจ้งเตือนได้ เหมือน Reminder
  - สามารถจัดการ การแจ้งเตือนแบบรายวัน รายสัปดาห์ รายเดือน
  - สามารถจัดการ การแจ้งเตือนแบบรายปี
  - สามารถจัดการ การแจ้งเตือนแบบรายครั้ง
  - เป็นแอปออฟไลน์
  - ใช้งานได้ทั้ง iOS , Android
  - รองรับหน้าจอ Mobile , iPad , Tablet
  - รองรับการทำงานแบบ Responsive
  - ดาวน์โหลดไฟล์ PDF ได้
  - แสดงไฟล์ PDF ก่อนดาวน์โหลดได้
  - แยกข้อมูลไฟล์ ตามหัวข้อ
  - เพิ่ม ลบ แก้ไข ข้อมูล Reminder ได้

## Project Structure

```
lib/
├── core/
│   ├── constants/          # App constants and configuration
│   ├── database/          # ObjectBox database service
│   ├── di/               # Dependency injection setup
│   ├── router/           # Go Router configuration
│   ├── theme/            # App themes (light/dark)
│   └── utils/            # Utility services (notifications, etc.)
├── features/
│   ├── reminder/         # Reminder feature
│   │   ├── data/         # Data layer
│   │   ├── domain/       # Domain models and entities
│   │   └── presentation/ # UI screens and widgets
│   └── pdf/              # PDF management feature
│       ├── data/         # Data layer
│       ├── domain/       # Domain models and entities
│       └── presentation/ # UI screens and widgets
└── shared/
    └── widgets/          # Shared UI components
```

## Getting Started

### Prerequisites

- Flutter SDK (>=3.7.2)
- Dart SDK
- iOS development tools (for iOS)
- Android development tools (for Android)

### Installation

1. Clone the repository:

```bash
git clone <repository-url>
cd law_app
```

2. Install dependencies:

```bash
flutter pub get
```

3. Generate code (ObjectBox, Riverpod, etc.):

```bash
dart run build_runner build
```

4. Run the app:

```bash
flutter run
```

## Key Dependencies

- **flutter_riverpod**: State management
- **objectbox**: Local database
- **go_router**: Navigation and routing
- **get_it**: Dependency injection
- **injectable**: Code generation for DI
- **flutter_local_notifications**: Local notifications
- **flutter_screenutil**: Responsive design
- **flutter_pdfview**: PDF viewing
- **permission_handler**: Permission management

## Architecture

This app follows MVVM (Model-View-ViewModel) architecture with:

- **Model**: ObjectBox entities for data persistence
- **View**: Flutter widgets and screens
- **ViewModel**: Riverpod providers for state management
- **Dependency Injection**: GetIt for service registration
- **Navigation**: Go Router for declarative routing

## Features Implementation

### Reminder Management

- Create, read, update, delete reminders
- Support for different reminder types (once, daily, weekly, monthly, yearly)
- Local notifications for reminders
- Category-based organization

### PDF Management

- PDF file viewing and management
- Category-based file organization
- Preview before download functionality
- Search and filter capabilities

### Responsive Design

- Adaptive layouts for mobile, tablet, and desktop
- Material Design components
- Light and dark theme support

## Development

### Code Generation

Run code generation after making changes to:

- ObjectBox entities
- Riverpod providers
- Injectable services

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Adding New Features

1. Create feature folder under `lib/features/`
2. Implement domain models with ObjectBox annotations
3. Create data layer with repository pattern
4. Implement presentation layer with Riverpod providers
5. Add navigation routes in `app_router.dart`

## Screen Shots

(Add screenshots of the app here when available)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests (when implemented)
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
