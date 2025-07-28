# SafeDoc

## app name : SafeDoc

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
  - เป็นแอปออฟไลน์
  - ใช้งานได้ทั้ง iOS , Android
  - รองรับหน้าจอ Mobile , iPad , Tablet
  - รองรับการทำงานแบบ Responsive
  - ดาวน์โหลดไฟล์ PDF ได้
  - แสดงไฟล์ PDF ก่อนดาวน์โหลดได้
  - แยกข้อมูลไฟล์ ตามหัวข้อ
  - เพิ่ม ลบ แก้ไข ข้อมูล Reminder ได้

---

## 📱 คู่มือการใช้งานแอปพลิเคชั่น SafeDoc

### 🛠️ เทคโนโลยีและ Package ที่ใช้งาน

#### **Framework & Language**
- **Framework**: Flutter 3.7.2+
- **Language**: Dart
- **Version**: 0.0.5

#### **การจัดการ State และ Architecture**
- **State Management**: Riverpod (flutter_riverpod 2.6.1)
- **Architecture**: MVVM (Model-View-ViewModel)
- **Dependency Injection**: GetIt + Injectable
- **Code Generation**: Freezed, JSON Serializable

#### **Navigation และ UI**
- **Router**: GoRouter 14.6.2 (Bottom Navigation)
- **Responsive**: ScreenUtil, Responsive Framework, Responsive Builder
- **Theme**: Material Design 3 + Flex Color Scheme
- **Fonts**: Google Fonts
- **UI Components**: Adaptive Dialog, Custom Widgets

#### **Database และ Storage**
- **Database**: ObjectBox 4.0.3 (Local Database)
- **Data Models**: Freezed + JSON Annotation
- **Storage**: SharedPreferences

#### **PDF และ File Management**
- **PDF Viewer**: flutter_pdfview 1.4.1
- **PDF Generation**: pdf 3.11.1
- **File Access**: path_provider, open_file
- **Permissions**: permission_handler

#### **Notifications และ Scheduling**
- **Local Notifications**: flutter_local_notifications 19.3.0
- **Timezone**: timezone 0.10.1, flutter_timezone
- **Background Tasks**: Native Android/iOS

#### **Localization และ Internationalization**
- **Languages**: Thai (th_TH), English (en_US)
- **Localization**: flutter_localizations, intl

---

### 🏗️ โครงสร้างโปรเจค

```
lib/
├── main.dart                    # Entry Point
├── components/                  # Reusable Components
├── core/                       # Core Functionalities
│   ├── database/               # ObjectBox Database
│   ├── router/                 # Navigation Management
│   ├── theme/                  # App Theming
│   └── utils/                  # Utilities & Services
├── features/                   # Feature Modules
│   ├── home/                   # หน้าแรก (เอกสาร)
│   ├── form/                   # หน้าจัดการ PDF
│   ├── reminder/               # หน้าการแจ้งเตือน
│   └── settings/               # หน้าตั้งค่า
├── models/                     # Data Models
└── shared/                     # Shared Resources
```

---

### 📱 ฟีเจอร์หลักของแอปพลิเคชั่น

#### **1. หน้าแรก (Home Screen - เอกสาร)**

**ความสามารถ:**
- **แสดงรายการเอกสาร PDF**: เอกสารทางกฎหมายทั้งหมด 53 ไฟล์
- **การจัดหมวดหมู่**: แบ่งตามประเภทเอกสาร (Contract, Legal Document, Court Filing, Agreement, Policy, Regulation)
- **ระบบค้นหา**: ค้นหาเอกสารตามชื่อและเนื้อหา
- **ฟิลเตอร์**: กรองเอกสารตามหมวดหมู่
- **สถิติเอกสาร**: แสดงจำนวนเอกสารทั้งหมดและเอกสารใหม่

**การใช้งาน:**
1. เปิดแอป → จะแสดงหน้า Documents เป็นหน้าแรก
2. เลื่อนดูรายการเอกสาร หรือใช้ช่องค้นหาด้านบน
3. เลือกหมวดหมู่จากแท็บด้านบนเพื่อกรองเอกสาร
4. แตะที่เอกสารเพื่อดูตัวอย่างและดาวน์โหลด

**UI Elements:**
- **App Bar**: มีช่องค้นหาและสถิติ
- **Category Tabs**: แท็บเลือกหมวดหมู่แบบ Horizontal Scroll
- **Document Cards**: การ์ดแสดงรายละเอียดเอกสาร พร้อมไอคอนรายการโปรด
- **Stats Cards**: แสดงจำนวนเอกสารและสถิติต่างๆ

#### **2. หน้าจัดการ PDF (Form Screen)**

**ความสามารถ:**
- **ดูตัวอย่าง PDF**: เปิดดูเอกสาร PDF ก่อนดาวน์โหลด
- **ดาวน์โหลดไฟล์**: บันทึกไฟล์ PDF ลงในเครื่อง
- **จัดการรายการโปรด**: เพิ่ม/ลบเอกสารจากรายการโปรด
- **แชร์เอกสาร**: แชร์ไฟล์ PDF ไปยังแอปอื่น
- **ข้อมูลเอกสาร**: แสดงขนาดไฟล์, วันที่อัปเดต, จำนวนดาวน์โหลด

**การใช้งาน:**
1. จากหน้า Documents → แตะที่เอกสารที่ต้องการ
2. **ดูตัวอย่าง**: แตะไอคอน "ดู" เพื่อเปิด PDF Viewer
3. **ดาวน์โหลด**: แตะไอคอน "ดาวน์โหลด" เพื่อบันทึกไฟล์
4. **เพิ่มรายการโปรด**: แตะไอคอนหัวใจเพื่อเพิ่ม/ลบจากรายการโปรด
5. **แชร์**: แตะไอคอน "แชร์" เพื่อส่งไฟล์

#### **3. หน้าการแจ้งเตือน (Reminder Screen)**

**ความสามารถ:**
- **สร้างการแจ้งเตือน**: ตั้งเวลาแจ้งเตือนสำหรับงานต่างๆ
- **เลือกไฟล์ PDF**: เชื่อมโยงไฟล์ PDF กับการแจ้งเตือน (Multi-Select)
- **การทำซ้ำ**: ตั้งค่าการแจ้งเตือนแบบวนซ้ำ (ทุกวัน, สัปดาห์, เดือน, ปี)
- **จัดการการแจ้งเตือน**: เพิ่ม, แก้ไข, ลบ, เปิด/ปิดการแจ้งเตือน
- **การแจ้งเตือนในเวลาที่กำหนด**: ระบบ Local Notification

**ประเภทการทำซ้ำ:**
- **ไม่เกิดซ้ำ** (none): แจ้งเตือนครั้งเดียว
- **ทุกวัน** (daily): แจ้งเตือนทุกวันในเวลาเดิม
- **ทุกสัปดาห์** (weekly): เลือกวันในสัปดาห์
- **ทุกเดือน** (monthly): เลือกวันที่ในเดือน
- **ทุกปี** (yearly): เลือกเดือนและวันที่

**การใช้งาน:**
1. **เพิ่มการแจ้งเตือนใหม่**: แตะปุ่ม "+" หรือ "เพิ่มการเตือนความจำ"
2. **กรอกข้อมูล**:
   - หัวข้อการแจ้งเตือน
   - รายละเอียด (Optional)
   - วันที่และเวลา
   - การทำซ้ำ
   - ไฟล์ PDF ที่เกี่ยวข้อง (Optional)
3. **บันทึก**: แตะ "บันทึก" เพื่อสร้างการแจ้งเตือน
4. **แก้ไข**: แตะที่การ์ดการแจ้งเตือนเพื่อแก้ไข
5. **ลบ**: กดปุ่มลบแล้วยืนยัน

#### **4. หน้าตั้งค่าการแจ้งเตือน (Notification Settings)**

**ความสามารถ:**
- **ตรวจสอบสถานะการแจ้งเตือน**: แสดงว่าเปิด/ปิดการแจ้งเตือน
- **จัดการสิทธิ์**: นำทางไปยังการตั้งค่าระบบ
- **ทดสอบการแจ้งเตือน**: ส่งการแจ้งเตือนทดสอบ
- **Battery Optimization** (Android): ปิดการปรับแต่งแบตเตอรี่
- **รีเฟรชสถานะ**: ตรวจสอบสถานะล่าสุด

**การใช้งาน:**
1. จากหน้า Reminder → แตะไอคอน Settings ขวาบน
2. **ตรวจสอบสถานะ**: ดูสถานะการแจ้งเตือนปัจจุบัน
3. **เปิดสิทธิ์**: หากปิดอยู่ให้แตะ "ไปที่การตั้งค่า"
4. **ทดสอบ**: แตะ "ทดสอบการแจ้งเตือน" เพื่อทดสอบ
5. **Battery Optimization**: แตะ "ปิดการปรับแต่งแบตเตอรี่" (Android)

---

### 🔄 ลำดับการใช้งานแอปพลิเคชั่น

#### **เริ่มต้นใช้งานครั้งแรก**
1. **เปิดแอป** → ระบบขออนุญาตการแจ้งเตือน
2. **อนุญาตการแจ้งเตือน** → แตะ "อนุญาต"
3. **สำรวจเอกสาร** → ดูรายการเอกสาร PDF ทั้งหมด
4. **ดาวน์โหลดเอกสาร** → เลือกเอกสารที่ต้องการ

#### **การใช้งานประจำ**
1. **ค้นหาเอกสาร** → ใช้ช่องค้นหาหรือกรองตามหมวดหมู่
2. **ดูตัวอย่าง PDF** → แตะเพื่อดูก่อนดาวน์โหลด
3. **ตั้งการแจ้งเตือน** → สำหรับงานสำคัญที่เกี่ยวข้องกับเอกสาร
4. **จัดการรายการโปรด** → เพิ่มเอกสารที่ใช้บ่อย

#### **การจัดการการแจ้งเตือน**
1. **ไปหน้า Reminder** → แตะแท็บ "Reminders"
2. **เพิ่มการแจ้งเตือน** → แตะปุ่ม "+" 
3. **กรอกข้อมูล** → หัวข้อ, เวลา, การทำซ้ำ
4. **เลือกไฟล์** → เชื่อมโยงกับเอกสาร PDF (ถ้าต้องการ)
5. **บันทึก** → การแจ้งเตือนจะทำงานอัตโนมัติ

---

### 📊 ข้อมูลเพิ่มเติม

#### **สถิติการใช้งาน**
- **เอกสาร PDF**: 53 ไฟล์
- **หมวดหมู่**: 6 หมวดหมู่หลัก
- **ภาษา**: รองรับไทย-อังกฤษ
- **แพลตฟอร์ม**: iOS, Android, iPad, Tablet

#### **ข้อกำหนดระบบ**
- **iOS**: 11.0+
- **Android**: API Level 21+ (Android 5.0)
- **หน่วยความจำ**: 100MB+
- **พื้นที่จัดเก็บ**: 200MB+ (สำหรับเอกสาร PDF)

#### **การแก้ไขปัญหาการแจ้งเตือน**
- ตรวจสอบการตั้งค่าการแจ้งเตือนในระบบ
- ปิด Battery Optimization (Android)
- รีสตาร์ทแอปหากการแจ้งเตือนไม่ทำงาน
- ใช้ฟีเจอร์ทดสอบการแจ้งเตือนใน Settings

---

### 🎯 จุดเด่นของแอปพลิเคชั่น

1. **ใช้งานออฟไลน์**: ไม่จำเป็นต้องเชื่อมต่ออินเทอร์เน็ต
2. **Responsive Design**: ปรับตัวได้กับทุกขนาดหน้าจอ
3. **Modern UI/UX**: ใช้ Material Design 3
4. **Performance**: ใช้ ObjectBox สำหรับความเร็วในการเข้าถึงข้อมูล
5. **Reliability**: การแจ้งเตือนที่เชื่อถือได้ด้วย Native Implementation
6. **Localization**: รองรับภาษาไทยเต็มรูปแบบ

แอปพลิเคชั่น SafeDoc เป็นเครื่องมือที่สมบูรณ์สำหรับการจัดการเอกสารทางกฎหมายและการแจ้งเตือน เหมาะสำหรับผู้ที่ต้องการความสะดวกและความเชื่อถือได้ในการทำงานกับเอกสารสำคัญ

## Project Structure
