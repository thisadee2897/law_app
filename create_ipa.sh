#!/bin/bash

echo "🔧 สร้าง .ipa จาก .app file..."

# หา .app file
APP_FILE=$(find build -name "Runner.app" -type d | head -1)

if [ ! -z "$APP_FILE" ]; then
    echo "✅ พบไฟล์ .app: $APP_FILE"
    
    # สร้างโฟลเดอร์ Payload
    mkdir -p Payload
    
    # คัดลอก .app ไปยัง Payload
    cp -r "$APP_FILE" Payload/SafeDoc.app
    
    # สร้าง .ipa
    zip -r SafeDoc.ipa Payload/
    
    # ย้ายไฟล์ไปยัง docs
    mv SafeDoc.ipa docs/
    
    # ลบโฟลเดอร์ Payload
    rm -rf Payload/
    
    echo "✅ สร้าง docs/SafeDoc.ipa เสร็จสิ้น!"
    ls -lh docs/SafeDoc.ipa
    
else
    echo "❌ ไม่พบไฟล์ .app"
    echo "💡 ลองรันคำสั่ง: flutter build ios --release"
fi
