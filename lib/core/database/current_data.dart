import 'package:law_app/core/database/models/category_form_model.dart';
import 'package:law_app/core/database/models/form_model.dart';

class CurrentCategoryData {
  static List<CategoryFormModel> getData() {
    return [
      CategoryFormModel(
        categoryId: 1,
        categoryFormName: 'ทั้งหมด',
        categoryFormFullName: 'แสดงข้อมูลทั้งหมด',
        categoryFormImage: 'assets/images/fervour-lighting-sound-2559.png',
        categoryFormUpdatedAt: DateTime.parse('2023-10-01T12:00:00Z'),
        categoryFormActive: true,
      ),
      CategoryFormModel(
        categoryId: 2,
        categoryFormName: 'การป้องกันและระงับอัคคีภัย',
        categoryFormFullName:
            'กำหนดมาตรฐานในการบริหารจัดการและดำเนินการด้านความปลอดภัยอาชีวอนามัยและสภาพแวดล้อมในการทำงานเกี่ยวกับการป้องกันและระงับอัคคีภัยพ.ศ.๒๕๕๕',
        categoryFormImage: 'assets/images/fervour-lighting-sound-2559.png',
        categoryFormUpdatedAt: DateTime.parse('2023-10-01T12:00:00Z'),
        categoryFormActive: true,
      ),
      CategoryFormModel(
        categoryId: 3,
        categoryFormName: 'สารเคมีอันตราย',
        categoryFormFullName: 'กำหนดมาตรฐานในการบริหารจัดการและดำเนินการด้านความปลอดภัยอาชีวอนามัยและสภาพแวดล้อมในการทำงานเกี่ยวกับสารเคมีอันตรายพ.ศ.๒๕๕๖',
        categoryFormImage: 'assets/images/fervour-lighting-sound-2559.png',
        categoryFormUpdatedAt: DateTime.parse('2023-10-01T12:00:00Z'),
        categoryFormActive: true,
      ),
      CategoryFormModel(
        categoryId: 4,
        categoryFormName: 'ความปลอดภัยเกี่ยวกับไฟฟ้า',
        categoryFormFullName:
            'กำหนดมาตรฐานในการบริหารจัดการและดำเนินการด้านความปลอดภัยอาชีวอนามัยและสภาพแวดล้อมในการทำงานเกี่ยวกับความปลอดภัยเกี่ยวกับไฟฟ้า พ.ศ.๒๕๕๘',
        categoryFormImage: 'assets/images/fervour-lighting-sound-2559.png',
        categoryFormUpdatedAt: DateTime.parse('2023-10-01T12:00:00Z'),
        categoryFormActive: true,
      ),
      CategoryFormModel(
        categoryId: 5,
        categoryFormName: 'ความร้อน/แสง/เสียง',
        categoryFormFullName:
            'กำหนดมาตรฐานในการบริหารจัดการและดำเนินการด้านความปลอดภัยอาชีวอนามัยและสภาพแวดล้อมในการทำงานเกี่ยวกับความร้อน แสงสว่าง และเสียง พ.ศ.๒๕๕๙',
        categoryFormImage: 'assets/images/fervour-lighting-sound-2559.png',
        categoryFormUpdatedAt: DateTime.parse('2023-10-01T12:00:00Z'),
        categoryFormActive: true,
      ),
      CategoryFormModel(
        categoryId: 6,
        categoryFormName: 'การทำงานในที่อับอากาศ',
        categoryFormFullName:
            'กำหนดมาตรฐานในการบริหารจัดการและดำเนินการด้านความปลอดภัยอาชีวอนามัยและสภาพแวดล้อมในการทำงานเกี่ยวกับการทำงานในที่อับอากาศ พ.ศ.๒๕๖๒',
        categoryFormImage: 'assets/images/fervour-lighting-sound-2559.png',
        categoryFormUpdatedAt: DateTime.parse('2023-10-01T12:00:00Z'),
        categoryFormActive: true,
      ),
      CategoryFormModel(
        categoryId: 7,
        categoryFormName: 'งานประดาน้ำ',
        categoryFormFullName: 'กำหนดมาตรฐานในการบริหารจัดการและดำเนินการด้านความปลอดภัยอาชีวอนามัยและสภาพแวดล้อมในการทำงานเกี่ยวกับงานประดาน้ำ พ.ศ.๒๕๖๓',
        categoryFormImage: 'assets/images/fervour-lighting-sound-2559.png',
        categoryFormUpdatedAt: DateTime.parse('2023-10-01T12:00:00Z'),
        categoryFormActive: true,
      ),
      CategoryFormModel(
        categoryId: 8,
        categoryFormName: 'ตรวจสอบสุขภาพลูกจ้าง',
        categoryFormFullName: 'กำหนดมาตรฐานการตรวจสุขภาพลูกจ้างซึ่งทำงานเกี่ยวกับปัจจัยเสียงพ.ศ.๒๕๖๓',
        categoryFormImage: 'assets/images/fervour-lighting-sound-2559.png',
        categoryFormUpdatedAt: DateTime.parse('2023-10-01T12:00:00Z'),
        categoryFormActive: true,
      ),
      CategoryFormModel(
        categoryId: 9,
        categoryFormName: 'นั่งร้านและค้ำยัน',
        categoryFormFullName: 'กำหนดมาตรฐานในการบริหารจัดการและดำเนินการด้านความปลอดภัยอาชีวอนามัยและสภาพแวดล้อมในการทำงานเกี่ยวกับนั่งร้านและค้ำยันพ.ศ.๒๕๖๔',
        categoryFormImage: 'assets/images/fervour-lighting-sound-2559.png',
        categoryFormUpdatedAt: DateTime.parse('2023-10-01T12:00:00Z'),
        categoryFormActive: true,
      ),
      CategoryFormModel(
        categoryId: 10,
        categoryFormName: 'งานก่อสร้าง',
        categoryFormFullName: 'กำหนดมาตรฐานในการบริหารจัดการและดำเนินการด้านความปลอดภัยอาชีวอนามัยและสภาพแวดล้อมในการทำงานเกี่ยวกับงานก่อสร้างพ.ศ.๒๕๖๔',
        categoryFormImage: 'assets/images/fervour-lighting-sound-2559.png',
        categoryFormUpdatedAt: DateTime.parse('2023-10-01T12:00:00Z'),
        categoryFormActive: true,
      ),
      CategoryFormModel(
        categoryId: 11,
        categoryFormName: 'อันตรายจากการตกที่สูง',
        categoryFormFullName:
            'กำหนดมาตรฐานในการบริหารจัดการและดำเนินการด้านความปลอดภัยอาชีวอนามัยและสภาพแวดล้อมในการทำงานในสถานที่ที่มีอันตรายจากการตกจากที่สูงและที่ลาดชันจากวัสดุกระเด็นตกหล่นและพังทลายและจากการตกลงไปในภาชนะเก็บหรือรองรับวัสดุพ.ศ.๒๕๖๔',
        categoryFormImage: 'assets/images/fervour-lighting-sound-2559.png',
        categoryFormUpdatedAt: DateTime.parse('2023-10-01T12:00:00Z'),
        categoryFormActive: true,
      ),
      CategoryFormModel(
        categoryId: 12,
        categoryFormName: 'การขึ้นทะเบียนและการอนุญาตให้บริการ',
        categoryFormFullName: 'กฎกระทรวงการขึ้นทะเบียนและการอนุญาตให้บริการเพื่อส่งเสริมความปลอดภัยอาชีวอนามัยและสภาพแวดล้อมในการทำงานพ.ศ.๒๕๖๔',
        categoryFormImage: 'assets/images/fervour-lighting-sound-2559.png',
        categoryFormUpdatedAt: DateTime.parse('2023-10-01T12:00:00Z'),
        categoryFormActive: true,
      ),
      CategoryFormModel(
        categoryId: 13,
        categoryFormName: 'เครื่องจักร/ปั้นจั่น และหม้อน้ำ',
        categoryFormFullName: 'เกี่ยวกับเครื่องจักร ปั้นจั่น และหม้อน้ำ',
        categoryFormImage: 'assets/images/fervour-lighting-sound-2559.png',
        categoryFormUpdatedAt: DateTime.parse('2023-10-01T12:00:00Z'),
        categoryFormActive: true,
      ),
      CategoryFormModel(
        categoryId: 14,
        categoryFormName: 'กำหนดมาตรฐานการทำงานเกี่ยวกับรังสี',
        categoryFormFullName: 'กำหนดมาตรฐานการทำงานเกี่ยวกับรังสี พ.ศ. ๒๕๖๔',
        categoryFormImage: 'assets/images/fervour-lighting-sound-2559.png',
        categoryFormUpdatedAt: DateTime.parse('2023-10-01T12:00:00Z'),
        categoryFormActive: true,
      ),
      CategoryFormModel(
        categoryId: 15,
        categoryFormName: 'ระบบการจัดการด้านความปลอดภัย',
        categoryFormFullName: 'กฎกระทรวงกำหนดมาตรฐานเกี่ยวกับระบบการจัดการด้านความปลอดภัยพ.ศ.๒๕๖๕',
        categoryFormImage: 'assets/images/fervour-lighting-sound-2559.png',
        categoryFormUpdatedAt: DateTime.parse('2023-10-01T12:00:00Z'),
        categoryFormActive: true,
      ),
      CategoryFormModel(
        categoryId: 16,
        categoryFormName: 'การจัดให้มีเจ้าหน้าที่ความปลอดภัยฯ',
        categoryFormFullName: 'การจัดให้มีเจ้าหน้าที่ความปลอดภัยฯ',
        categoryFormImage: 'assets/images/fervour-lighting-sound-2559.png',
        categoryFormUpdatedAt: DateTime.parse('2023-10-01T12:00:00Z'),
        categoryFormActive: true,
      ),
      CategoryFormModel(
        categoryId: 17,
        categoryFormName: 'การอนุญาตเป็นผู้ชำนาญการด้านความปลอดภัยฯ',
        categoryFormFullName: 'การอนุญาตเป็นผู้ชำนาญการด้านความปลอดภัยอาชีวอนามัยและสภาพแวดล้อมในการทำงานพ.ศ.๒๕๖๗',
        categoryFormImage: 'assets/images/fervour-lighting-sound-2559.png',
        categoryFormUpdatedAt: DateTime.parse('2023-10-01T12:00:00Z'),
        categoryFormActive: true,
      ),
      CategoryFormModel(
        categoryId: 18,
        categoryFormName: 'กำหนดกิจการอื่นที่ไม่อยู่ภายใต้บังคับกฏหมายว่าด้วยความปลอดภัยฯ',
        categoryFormFullName: 'กฎกระทรวงกำหนดกิจการอื่นที่ไม่อยู่ภายใต้บังคับกฎหมายว่าด้วยความปลอดภัยอาชีวอนามัยและสภาพแวดล้อมในการทำงานพ.ศ.๒๕๖๘',
        categoryFormImage: 'assets/images/fervour-lighting-sound-2559.png',
        categoryFormUpdatedAt: DateTime.parse('2023-10-01T12:00:00Z'),
        categoryFormActive: true,
      ),
    ];
  }
}

class CurrentFormPDFData {
  static List<FormModel> getData() {
    return [
      FormModel(
        formId: 1,
        formName: 'Criminal Law',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        favorite: false,
        pdfPath: 'assets/pdfs/test.pdf',
      ),
    ];
  }
}
