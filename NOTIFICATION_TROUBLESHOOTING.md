# คู่มือแก้ไขปัญหาการแจ้งเตือน - Law App

## ปัญหาที่พบและการแก้ไข

### ❌ ปัญหา: การแจ้งเตือนไม่ทำงานเมื่อถึงเวลาที่กำหนด

### ✅ การแก้ไขที่ทำแล้ว:

#### 1. **การขออนุญาตการแจ้งเตือน**
- เพิ่มการขออนุญาตอัตโนมัติในตอนเปิดแอป
- เพิ่มหน้าการตั้งค่าการแจ้งเตือน
- เพิ่มการตรวจสอบสถานะการอนุญาต

#### 2. **การตั้งค่า Android**
- เพิ่ม permissions ใน AndroidManifest.xml:
  - `SCHEDULE_EXACT_ALARM` - สำหรับการแจ้งเตือนที่เวลาแน่นอน
  - `POST_NOTIFICATIONS` - สำหรับ Android 13+
  - `USE_EXACT_ALARM` - สำหรับการแจ้งเตือนแม่นยำ
  - `WAKE_LOCK` - เพื่อปลุกอุปกรณ์
  - `VIBRATE` - สำหรับการสั่น
  - `RECEIVE_BOOT_COMPLETED` - เพื่อให้การแจ้งเตือนทำงานหลังรีสตาร์ท
  - `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` - สำหรับขอปิดการปรับแต่งแบตเตอรี่

#### 3. **การจัดการ Battery Optimization**
- สร้าง helper class สำหรับจัดการ battery optimization
- เพิ่ม native Android code สำหรับตรวจสอบและขอปิดการปรับแต่งแบตเตอรี่
- เพิ่มการแจ้งเตือนผู้ใช้หากการปรับแต่งแบตเตอรี่เปิดอยู่

#### 4. **การปรับปรุง NotificationService**
- เพิ่มการสร้าง notification channel
- ปรับปรุงการขออนุญาต
- เพิ่มฟังก์ชันตรวจสอบสถานะการแจ้งเตือน
- เพิ่มการจัดการ timezone
- ปรับปรุง notification scheduling

#### 5. **การตั้งค่า iOS**
- เพิ่มการขออนุญาตที่สมบูรณ์ยิ่งขึ้น
- เพิ่ม critical และ provisional permissions

### 🔧 วิธีการใช้งาน:

1. **เปิดแอป** - ระบบจะขออนุญาตการแจ้งเตือนอัตโนมัติ
2. **ไปที่หน้า Reminder** - คลิกไอคอน settings ขวาบน
3. **ตรวจสอบสถานะ** - ดูว่าการแจ้งเตือนเปิดใช้งานหรือไม่
4. **ทดสอบการแจ้งเตือน** - คลิกปุ่ม "ทดสอบการแจ้งเตือน"
5. **จัดการ Battery Optimization** (Android) - คลิกปุ่ม "ปิดการปรับแต่งแบตเตอรี่" หากจำเป็น

### 📱 ขั้นตอนการแก้ไขสำหรับผู้ใช้:

#### สำหรับ Android:
1. เปิดแอป และอนุญาตการแจ้งเตือน
2. ไปที่ Settings > Apps > Law App > Notifications > เปิดใช้งาน
3. ไปที่ Settings > Apps > Law App > Battery > Unrestricted
4. หากยังไม่ทำงาน: Settings > Apps > Special access > Ignore battery optimization > เลือก Law App

#### สำหรับ iOS:
1. เปิดแอป และอนุญาตการแจ้งเตือน
2. ไปที่ Settings > Notifications > Law App > เปิดใช้งาน
3. ตรวจสอบว่า Allow Notifications เปิดอยู่
4. เปิด Critical Alerts หากต้องการ

### 🚨 หากการแจ้งเตือนยังไม่ทำงาน:

1. **รีสตาร์ทแอป** - ปิดแอปแล้วเปิดใหม่
2. **รีสตาร์ทโทรศัพท์** - ระบบจะ reschedule การแจ้งเตือนใหม่
3. **ตรวจสอบเวลาระบบ** - ให้แน่ใจว่าเวลาในโทรศัพท์ถูกต้อง
4. **ตรวจสอบ Do Not Disturb** - ปิดโหมดห้ามรบกวน
5. **ลบและสร้างการแจ้งเตือนใหม่** - ลบแล้วสร้างใหม่

### 🔍 การดีบัก:

1. ใช้ปุ่ม "ทดสอบการแจ้งเตือน" เพื่อตรวจสอบการทำงาน
2. ดู "การแจ้งเตือนที่รอดำเนินการ" เพื่อดูรายการที่ถูก schedule ไว้
3. ตรวจสอบ console logs ในระหว่างการพัฒนา

### 📋 คุณสมบัติที่เพิ่มเข้ามา:

- ✅ การขออนุญาตการแจ้งเตือนอัตโนมัติ
- ✅ หน้าการตั้งค่าการแจ้งเตือน
- ✅ การจัดการ Battery Optimization (Android)
- ✅ การทดสอบการแจ้งเตือนแบบทันที
- ✅ การแสดงรายการการแจ้งเตือนที่รอดำเนินการ
- ✅ การตรวจสอบสถานะการแจ้งเตือน
- ✅ การแจ้งเตือนแบบซ้ำ (รายวัน, รายสัปดาห์, รายเดือน, รายปี)
- ✅ การ reschedule การแจ้งเตือนหลังรีสตาร์ทแอป

### 🎯 ผลลัพธ์ที่คาดหวัง:

หลังจากการแก้ไข การแจ้งเตือนควรทำงานได้ในสถานการณ์ต่อไปนี้:
- ✅ เมื่อแอปเปิดอยู่ (Foreground)
- ✅ เมื่อแอปอยู่ในพื้นหลัง (Background)
- ✅ เมื่อแอปถูกปิด (Terminated)
- ✅ หลังจากรีสตาร์ทโทรศัพท์
- ✅ การแจ้งเตือนแบบซ้ำตามกำหนด
