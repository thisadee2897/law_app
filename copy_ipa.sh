#!/bin/bash

echo "🔍 ค้นหาไฟล์ .ipa ในโฟลเดอร์ build..."

# ค้นหาไฟล์ .ipa
IPA_FILE=$(find build -name "*.ipa" -type f | head -1)

if [ ! -z "$IPA_FILE" ]; then
    echo "✅ พบไฟล์ .ipa: $IPA_FILE"
    echo "📦 คัดลอกไฟล์ไปยัง docs/SafeDoc.ipa..."
    cp "$IPA_FILE" docs/SafeDoc.ipa
    echo "🎉 เสร็จสิ้น! ไฟล์พร้อมใช้งานแล้ว"
    ls -lh docs/SafeDoc.ipa
else
    echo "❌ ไม่พบไฟล์ .ipa"
    echo "🔧 ลองใช้ไฟล์ .app แทน..."
    
    APP_FILE=$(find build -name "Runner.app" -type d | head -1)
    if [ ! -z "$APP_FILE" ]; then
        echo "✅ พบไฟล์ .app: $APP_FILE"
        echo "⚠️  หมายเหตุ: ไฟล์ .app ใช้ได้เฉพาะในโหมดทดสอบเท่านั้น"
        echo "📦 สร้าง zip file สำหรับการแจกจ่าย..."
        cd "$(dirname "$APP_FILE")"
        zip -r "../SafeDoc.zip" "$(basename "$APP_FILE")"
        cd - > /dev/null
        mv "$(dirname "$APP_FILE")/SafeDoc.zip" docs/SafeDoc.zip
        echo "📁 สร้างไฟล์ docs/SafeDoc.zip แล้ว"
        ls -lh docs/SafeDoc.zip
    else
        echo "❌ ไม่พบไฟล์ .app ด้วย"
        echo "💡 ลองรันคำสั่ง: flutter build ios --release"
    fi
fi

echo ""
echo "📋 สรุป:"
echo "- หากต้องการใช้งานจริง: ต้องมีไฟล์ .ipa ที่ลงนามแล้ว"
echo "- หากต้องการทดสอบ: สามารถใช้ไฟล์ .app หรือ .zip ได้"
echo "- ตำแหน่งไฟล์: docs/SafeDoc.ipa (หรือ docs/SafeDoc.zip)"
