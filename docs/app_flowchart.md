# SafeDoc App Flowchart

## 🔄 แผนผังการทำงานของแอปพลิเคชั่น SafeDoc

### 1. Flow การเริ่มต้นแอป (App Initialization)

```mermaid
graph TD
    A[เปิดแอป SafeDoc] --> B{ครั้งแรก?}
    B -->|ใช่| C[ขออนุญาตการแจ้งเตือน]
    B -->|ไม่| D[โหลดข้อมูลจาก ObjectBox]
    C --> E{อนุญาต?}
    E -->|ใช่| F[Setup Local Notifications]
    E -->|ไม่| G[แสดงคำเตือน]
    F --> D
    G --> D
    D --> H[แสดงหน้าแรก - Documents]
```

### 2. Flow หน้าเอกสาร (Documents Screen)

```mermaid
graph TD
    A[หน้า Documents] --> B[แสดงรายการ PDF 53 ไฟล์]
    B --> C{ผู้ใช้เลือกอะไร?}
    
    C -->|ค้นหา| D[ใช้ Search Function]
    C -->|เลือกหมวดหมู่| E[กรองตาม Category]
    C -->|เลือกเอกสาร| F[ไปหน้า PDF Detail]
    
    D --> G[แสดงผลการค้นหา]
    E --> H[แสดงเอกสารตามหมวด]
    F --> I[หน้าจัดการ PDF]
    
    G --> C
    H --> C
    
    subgraph "Categories"
        E1[Contract]
        E2[Legal Document]
        E3[Court Filing]
        E4[Agreement]
        E5[Policy]
        E6[Regulation]
    end
```

### 3. Flow หน้าจัดการ PDF (PDF Management)

```mermaid
graph TD
    A[เลือกเอกสาร PDF] --> B[แสดงรายละเอียด]
    B --> C{ผู้ใช้เลือกอะไร?}
    
    C -->|ดูตัวอย่าง| D[เปิด PDF Viewer]
    C -->|ดาวน์โหลด| E[บันทึกไฟล์]
    C -->|เพิ่มรายการโปรด| F[บันทึกลง Favorites]
    C -->|แชร์| G[Share to Other Apps]
    C -->|กลับ| H[หน้า Documents]
    
    D --> I[แสดง PDF Content]
    E --> J{Permission OK?}
    F --> K[อัปเดต Database]
    G --> L[เปิด Share Sheet]
    
    J -->|ใช่| M[Download Success]
    J -->|ไม่| N[แสดง Error]
    
    I --> C
    M --> C
    N --> C
    K --> C
    L --> C
```

### 4. Flow หน้าการแจ้งเตือน (Reminder System)

```mermaid
graph TD
    A[หน้า Reminders] --> B[แสดงรายการ Reminders]
    B --> C{ผู้ใช้เลือกอะไร?}
    
    C -->|เพิ่มใหม่| D[หน้าสร้าง Reminder]
    C -->|แก้ไข| E[หน้าแก้ไข Reminder]
    C -->|ลบ| F[ยืนยันการลบ]
    C -->|เปิด/ปิด| G[Toggle Active Status]
    C -->|Settings| H[หน้า Notification Settings]
    
    D --> I[กรอกข้อมูล]
    I --> J[เลือกวันเวลา]
    J --> K[เลือกการทำซ้ำ]
    K --> L[เลือกไฟล์ PDF (Optional)]
    L --> M[บันทึกข้อมูล]
    
    subgraph "Repeat Options"
        K1[ไม่เกิดซ้ำ]
        K2[ทุกวัน]
        K3[ทุกสัปดาห์]
        K4[ทุกเดือน]
        K5[ทุกปี]
    end
    
    M --> N[Schedule Local Notification]
    N --> O[อัปเดต ObjectBox]
    O --> B
    
    E --> I
    F --> P{ยืนยัน?}
    P -->|ใช่| Q[ลบจาก Database & Cancel Notification]
    P -->|ไม่| B
    Q --> B
    
    G --> R[อัปเดตสถานะ]
    R --> B
```

### 5. Navigation Flow (Bottom Navigation)

```mermaid
graph TD
    A[App Start] --> B[Bottom Navigation]
    B --> C{เลือกแท็บ}
    
    C -->|Documents| D[Documents Screen]
    C -->|Reminders| E[Reminders Screen]
    
    D --> F[Document List]
    F --> G[PDF Detail]
    G --> H[PDF Viewer/Download]
    
    E --> I[Reminder List]
    I --> J[Add/Edit Reminder]
    J --> K[Reminder Form]
    
    subgraph "Shared Features"
        L[Search Function]
        M[Favorites Management]
        N[Theme Toggle]
        O[Language Switch]
    end
```

### 6. Notification System Flow

```mermaid
graph TD
    A[Reminder Created] --> B[Schedule Notification]
    B --> C[Store in ObjectBox]
    C --> D[Set Local Notification]
    
    D --> E{เวลาถึง?}
    E -->|ไม่| F[รอเวลา]
    E -->|ใช่| G[Send Notification]
    
    F --> E
    G --> H{มีการทำซ้ำ?}
    
    H -->|ไม่| I[Complete]
    H -->|ใช่| J[คำนวณเวลาถัดไป]
    J --> K[Schedule Next Notification]
    K --> E
    
    subgraph "Notification Types"
        G1[Simple Notification]
        G2[With PDF Attachment]
        G3[Recurring Notification]
    end
```

### 7. Data Flow Architecture

```mermaid
graph TD
    A[UI Layer] --> B[ViewModel/Riverpod]
    B --> C[Repository Layer]
    C --> D[Data Sources]
    
    D --> E[ObjectBox Database]
    D --> F[Local Storage]
    D --> G[Asset Files]
    
    subgraph "Features"
        H[Documents]
        I[Reminders] 
        J[Favorites]
        K[Settings]
    end
    
    H --> A
    I --> A
    J --> A
    K --> A
    
    subgraph "Core Services"
        L[Notification Service]
        M[PDF Service]
        N[Permission Service]
        O[Theme Service]
    end
    
    B --> L
    B --> M
    B --> N
    B --> O
```

### 8. Complete User Journey Flow

```mermaid
graph TD
    A[เปิดแอป] --> B[หน้า Documents]
    B --> C[เลือกเอกสาร]
    C --> D[ดูรายละเอียด]
    D --> E{ต้องการอะไร?}
    
    E -->|ดาวน์โหลด| F[Download PDF]
    E -->|ตั้งเตือน| G[ไปหน้า Reminders]
    E -->|ดูไฟล์| H[PDF Viewer]
    
    F --> I[บันทึกไฟล์สำเร็จ]
    G --> J[สร้าง Reminder]
    H --> K[อ่านเอกสาร]
    
    J --> L[เลือกวันเวลา]
    L --> M[เชื่อมโยง PDF]
    M --> N[บันทึก Reminder]
    N --> O[ได้รับการแจ้งเตือนตามเวลา]
    
    I --> P[กลับหน้าหลัก]
    K --> P
    O --> Q[เปิดไฟล์ที่เกี่ยวข้อง]
    Q --> P
    P --> B
```

---

## 🏗️ Architecture Overview

```mermaid
graph TB
    subgraph "Presentation Layer"
        A1[Screens/Pages]
        A2[Widgets/Components]
        A3[Dialogs/Sheets]
    end
    
    subgraph "State Management"
        B1[Riverpod Providers]
        B2[ViewModels]
        B3[State Classes]
    end
    
    subgraph "Business Logic"
        C1[Use Cases]
        C2[Services]
        C3[Repositories]
    end
    
    subgraph "Data Layer"
        D1[ObjectBox Database]
        D2[Local Storage]
        D3[Asset Manager]
        D4[Notification Manager]
    end
    
    A1 --> B1
    A2 --> B1
    A3 --> B1
    
    B1 --> C1
    B2 --> C2
    B3 --> C3
    
    C1 --> D1
    C2 --> D2
    C3 --> D3
    C2 --> D4
```

## 📱 Key Features Flow Summary

1. **Document Management**: Browse → View → Download → Favorite
2. **Reminder System**: Create → Schedule → Notify → Repeat
3. **PDF Integration**: View → Download → Share → Link to Reminders
4. **Offline First**: All data stored locally using ObjectBox
5. **Responsive Design**: Adapts to Mobile, Tablet, iPad
6. **Localization**: Thai/English language support
