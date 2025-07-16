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
        categoryFormActive: false,
      ),
      CategoryFormModel(
        categoryId: 12,
        categoryFormName: 'การขึ้นทะเบียนและการอนุญาตให้บริการ',
        categoryFormFullName: 'กฎกระทรวงการขึ้นทะเบียนและการอนุญาตให้บริการเพื่อส่งเสริมความปลอดภัยอาชีวอนามัยและสภาพแวดล้อมในการทำงานพ.ศ.๒๕๖๔',
        categoryFormImage: 'assets/images/fervour-lighting-sound-2559.png',
        categoryFormUpdatedAt: DateTime.parse('2023-10-01T12:00:00Z'),
        categoryFormActive: false,
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
        categoryFormActive: false,
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
        categoryFormActive: false,
      ),
      CategoryFormModel(
        categoryId: 18,
        categoryFormName: 'กำหนดกิจการอื่นที่ไม่อยู่ภายใต้บังคับกฏหมายว่าด้วยความปลอดภัยฯ',
        categoryFormFullName: 'กฎกระทรวงกำหนดกิจการอื่นที่ไม่อยู่ภายใต้บังคับกฎหมายว่าด้วยความปลอดภัยอาชีวอนามัยและสภาพแวดล้อมในการทำงานพ.ศ.๒๕๖๘',
        categoryFormImage: 'assets/images/fervour-lighting-sound-2559.png',
        categoryFormUpdatedAt: DateTime.parse('2023-10-01T12:00:00Z'),
        categoryFormActive: false,
      ),
    ];
  }
}

class CurrentFormPDFData {
  static List<FormModel> getData() {
    return [
      FormModel(
        formId: 1,
        categoryId: 2, // การป้องกันและระงับอัคคีภัย
        code: '21',
        formName: 'ประกาศกรมสวัสดิการและคุ้มครองแรงงาน เรื่อง กำหนดแบบรายงานผลการฝึกซ้อมดับเพลิงและฝึกซ้อมอพยพหนีไฟ',
        categoryName: 'การป้องกันและระงับอัคคีภัย',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/21.pdf',
      ),
      FormModel(
        formId: 2,
        categoryId: 3, // 3_กฎกระทรวงสารเคมีอันตราย
        categoryName: 'กฎกระทรวงสารเคมีอันตราย',
        code: '31',
        formName: 'กฎกระทรวงกำหนดมาตรฐานในการบริหาร จัดการ และดำเนินการด้านความปลอดภัย อาชีวอนามัยและสภาพแวดล้อมในการทำงานเกี่ยวกับสารเคมีอันตรายพ.ศ. ๒๕๕๖',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/31.pdf',
      ),
      FormModel(
        formId: 3,
        categoryId: 3, // 3_กฎกระทรวงสารเคมีอันตราย
        categoryName: 'กฎกระทรวงสารเคมีอันตราย',
        code: '32',
        formName:
            'ประกาศกรมสวัสดิการและคุ้มครองแรงงาน เรื่อง กำหนดแบบและวิธีการแจ้งบัญชีรายชื่อสารเคมีอันตรายและรายละเอียดข้อมูลความปลอดภัยของสารเคมีอันตรายทางอิเล็กทรอนิกส์',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/32.pdf',
      ),
      FormModel(
        formId: 4,
        categoryId: 3, // 3_กฎกระทรวงสารเคมีอันตราย
        categoryName: 'กฎกระทรวงสารเคมีอันตราย',
        code: '33',
        formName:
            'ประกาศกรมสวัสดิการและคุ้มครองแรงงาน เรื่อง กำหนดแบบและวิธีการส่งรายงานผลการตรวจวัดและวิเคราะห์ระดับความเข้มข้นของสารเคมีอันตรายในบรรยากาศของสถานที่ทำงานและสถานที่เก็บรักษาสารเคมีอันตรายทางอิเล็กทรอนิกส์',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/33.pdf',
      ),
      FormModel(
        formId: 5,
        categoryId: 3, // 3_กฎกระทรวงสารเคมีอันตราย
        categoryName: 'กฎกระทรวงสารเคมีอันตราย',
        code: '34',
        formName: 'ประกาศกรมสวัสดิการและคุ้มครองแรงงาน เรื่อง แบบบัญชีรายชื่อสารเคมีอันตรายและรายละเอียดข้อมูลความปลอดภัยของสารเคมีอันตราย ',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/34.pdf',
      ),
      FormModel(
        formId: 6,
        categoryId: 3, // 3_กฎกระทรวงสารเคมีอันตราย
        categoryName: 'กฎกระทรวงสารเคมีอันตราย',
        code: '35',
        formName: 'ประกาศกรมสวัสดิการและคุ้มครองแรงงาน เรื่อง หลักเกณฑ์ วิธีการตรวจวัด และการวิเคราะห์ผลการตรวจวัดระดับความเข้มข้นของสารเคมีอันตราย ',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/35.pdf',
      ),
      FormModel(
        formId: 7,
        categoryId: 3, // 3_กฎกระทรวงสารเคมีอันตราย
        categoryName: 'กฎกระทรวงสารเคมีอันตราย',
        code: '36',
        formName:
            'ประกาศกรมสวัสดิการและคุ้มครองแรงงาน เรื่อง หลักเกณฑ์ วิธีการตรวจวัด และการวิเคราะห์ผลการตรวจวัดระดับความเข้มข้นของสารเคมีอันตราย (ฉบับที่ ๒)',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/36.pdf',
      ),
      FormModel(
        formId: 8,
        categoryId: 4, // 4_กฎกระทรวงความปลอดภัยเกี่ยวกับไฟฟ้า
        categoryName: 'กฎกระทรวงความปลอดภัยเกี่ยวกับไฟฟ้า',
        code: '41',
        formName: 'ประกาศกรมสวัสดิการและคุ้มครองแรงงาน เรื่อง หลักเกณฑ์ วิธีการ และเงื่อนไขการจัดทำบันทึกผล การตรวจสอบและรับรองระบบไฟฟ้าและบริภัณฑ์ไฟฟ้า',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/41.pdf',
      ),
      FormModel(
        formId: 9,
        categoryId: 5, // 5_กฎกระทรวงความร้อน แสง เสียง
        categoryName: 'กฎกระทรวงความปลอดภัยเกี่ยวกับไฟฟ้า',
        code: '51',
        formName:
            'ประกาศกรมสวัสดิการและคุ้มครองแรงงาน เรื่อง กำหนดแบบรายงานผลการตรวจวัดและวิเคราะห์สภาวะการทำงาน เกี่ยวกับความร้อน แสงสว่าง และเสียงภายในสถานประกอบกิจการ',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/51.pdf',
      ),
      FormModel(
        formId: 10,
        categoryId: 6, // 6_กฎกระทรวงฯ การทำงาน ในที่อับอากาศ
        categoryName: 'กฎกระทรวงความปลอดภัยเกี่ยวกับไฟฟ้า',
        code: '61',
        formName: 'ประกาศกรมสวัสดิการและคุ้มครองแรงงาน เรื่อง หลักเกณฑ์ วิธีการ และหลักสูตรการฝึกอบรมความปลอดภัยในการทำงานในที่อับอากาศ',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/61.pdf',
      ),
      FormModel(
        formId: 11,
        categoryId: 7, // 7_กฎกระทรวงฯ เกี่ยวกับงาน ประดาน้ำ
        categoryName: 'กฎกระทรวงฯ เกี่ยวกับงาน ประดาน้ำ',
        code: '71',
        formName: 'ประกาศกรมสวัสดิการและคุ้มครองแรงงานเรื่องกำหนดแบบแจ้งสถานที่ทำงานหรือเปลี่ยนสถานที่ทำการทำงานประดาน้ำของลูกจ้าง',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/71.pdf',
      ),
      FormModel(
        formId: 12,
        categoryId: 7, // 7_กฎกระทรวงฯ เกี่ยวกับงาน ประดาน้ำ
        categoryName: 'กฎกระทรวงฯ เกี่ยวกับงาน ประดาน้ำ',
        code: '72',
        formName: 'ประกาศกรมสวัสดิการและคุ้มครองแรงงานเรื่องหลักเกณฑ์การกำหนดระยะเวลาการตรวจสุขภาพและจัดทำบัตรตรวจสุขภาพของลูกจ้างที่ทำงานประดาน้ำ',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/72.pdf',
      ),
      FormModel(
        formId: 13,
        categoryId: 8, // 8_กฎกระทรวงฯ การตรวจสุขภาพลูกจ้าง
        categoryName: 'กฎกระทรวงฯ การตรวจสุขภาพลูกจ้าง',
        code: '81',
        formName:
            'ประกาศกรมสวัสดิการและคุ้มครองแรงงาน เรื่อง กำหนดแบบและวิธีการส่งผลการตรวจสุขภาพของลูกจ้างที่ผิดปกติหรือที่มีอาการ หรือเจ็บป่วยเนื่องจากการทำงาน การให้การรักษาพยาบาล และการป้องกันแก้ไข',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/81.pdf',
      ),
      FormModel(
        formId: 14,
        categoryId: 8, // 8_กฎกระทรวงฯ การตรวจสุขภาพลูกจ้าง
        categoryName: 'กฎกระทรวงฯ การตรวจสุขภาพลูกจ้าง',
        code: '82',
        formName: 'ประกาศกรมสวัสดิการและคุ้มครองแรงงาน เรื่อง กำหนดแบบสมุดสุขภาพประจำตัวของลูกจ้างซึ่งทำงานเกี่ยวกับปัจจัยเสี่ยง',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/82.pdf',
      ),
      FormModel(
        formId: 15,
        categoryId: 9, // 9_กฎกระกรวงฯ เกี่ยวกับนั่งร้าน และค้ำยัน
        categoryName: 'กฎกระกรวงฯ เกี่ยวกับนั่งร้าน และค้ำยัน',
        code: '91',
        formName: 'ประกาศกรมสวัสดิการและคุ้มครองแรงงาน เรื่อง หลักเกณฑ์ วิธีการ และเงื่อนไขการค านวณออกแบบและควบคุมการใช้นั่งร้านโดยวิศวกร',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/91.pdf',
      ),
      FormModel(
        formId: 16,
        categoryId: 10, // 10_ก่อสร้าง
        categoryName: 'ก่อสร้าง',
        code: '101',
        formName: 'กำหนดแบบแจ้งข้อมูลก่อนเริ่มงานก่อสร้าง',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/101.pdf',
      ),
      FormModel(
        formId: 17,
        categoryId: 13, // 13_เครื่องจักร ปั่นจั่น หม้อน้ำ
        code: '131',
        formName: 'ความปลอดภัยในการใช้หม้อน้ำ',
        categoryName: 'เครื่องจักร ปั่นจั่น หม้อน้ำ',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/131.pdf',
      ),
      FormModel(
        formId: 18,
        categoryId: 13, // 13_เครื่องจักร ปั่นจั่น หม้อน้ำ
        categoryName: 'เครื่องจักร ปั่นจั่น หม้อน้ำ',
        code: '132',
        formName: 'แบบแจ้งใช้งานหรือยกเลิกใช้งานหม้อน้ำ',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/132.pdf',
      ),
      FormModel(
        formId: 19,
        categoryId: 13, // 13_เครื่องจักร ปั่นจั่น หม้อน้ำ
        categoryName: 'เครื่องจักร ปั่นจั่น หม้อน้ำ',
        code: '133',
        formName: 'หม้อต้มของเหลว',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/133.pdf',
      ),
      FormModel(
        formId: 20,
        categoryId: 13, // 13_เครื่องจักร ปั่นจั่น หม้อน้ำ
        categoryName: 'เครื่องจักร ปั่นจั่น หม้อน้ำ',
        code: '134',
        formName: 'เอกสารทดสอบปั่นจั่น',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/134.pdf',
      ),
      FormModel(
        formId: 21,
        categoryId: 14, // 14_รังสี
        categoryName: 'รังสี',
        code: '141',
        formName: '(กภ.ร ๒)แบบจัดทำข้อมูลเกี่ยวกับปริมาณรังสีสะสมและแบบแจ้งปริมาณรังสีสะสมที่เกินกำหนดของลูกจ้างซึ่งปฏิบัติงานเกี่ยวกับรังสี',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/141.pdf',
      ),
      FormModel(
        formId: 22,
        categoryId: 14, // 14_รังสี
        categoryName: 'รังสี',
        code: '142',
        formName: '(กภ.ร ๓) แบบจัดทำข้อมูลเกี่ยวกับปริมาณรังสีสะสมและแบบแจ้งปริมาณรังสีสะสมที่เกินกำหนดของลูกจ้างซึ่งปฏิบัติงานเกี่ยวกับรังสี',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/142.pdf',
      ),
      FormModel(
        formId: 23,
        categoryId: 14, // 14_รังสี
        categoryName: 'รังสี',
        code: '143',
        formName:
            'แบบแจ้งประเภทต้นกำเนิดรังสี ปริมาณรังสี สถานประกอบกิจการซึ่งต้นกำเนิดรังสีตั้งอยู่ข้อมูลเกี่ยวกับการอนุญาตหรือการแจ้งการครอบครองหรือใช้ และกรณีที่มีการเปลี่ยนแปลงข้อมูล',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/143.pdf',
      ),
      FormModel(
        formId: 24,
        categoryId: 16, // 16_การจัดให้มีเจ้าหน้าที่ความปลอดภัยในการทำงานบุคลากรหน่วยงานหรือคณะบุคคล เพื่อดำเนินการด้านความปลอดภัยในสถานประกอบกิจการพ.ศ.๒๕๖๕
        categoryName: 'การจัดให้มีเจ้าหน้าที่ความปลอดภัยฯ',
        code: '161',
        formName: 'การแจ้งการขึ้นทะเบียน การพ้นจากตำแหน่งหรือพ้นจากหน้าที่ของเจ้าหน้าที่ความปลอดภัยในการทำงาน และผู้บริหารหน่วยงานความปลอดภัย',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/161.pdf',
      ),
      FormModel(
        formId: 25,
        categoryId: 16, // 16_การจัดให้มีเจ้าหน้าที่ความปลอดภัยในการทำงานบุคลากรหน่วยงานหรือคณะบุคคล เพื่อดำเนินการด้านความปลอดภัยในสถานประกอบกิจการพ.ศ.๒๕๖๕
        categoryName: 'การจัดให้มีเจ้าหน้าที่ความปลอดภัยฯ',
        code: '162',
        formName:
            'การฝึกอบรมหรือการพัฒนาความรู้ของเจ้าหน้าที่ความปลอดภัยในการทำงานระดับเทคนิคระดับเทคนิคขั้นสูง และระดับวิชาชีพ เกี่ยวกับความปลอดภัยในการทำงานเพิ่มเติม',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/162.pdf',
      ),
      FormModel(
        formId: 26,
        categoryId: 16, // 16_การจัดให้มีเจ้าหน้าที่ความปลอดภัยในการทำงานบุคลากรหน่วยงานหรือคณะบุคคล เพื่อดำเนินการด้านความปลอดภัยในสถานประกอบกิจการพ.ศ.๒๕๖๕
        categoryName: 'การจัดให้มีเจ้าหน้าที่ความปลอดภัยฯ',
        code: '163',
        formName: '(จป.ท)แบบรายงานผลการดำเนินงานของเจ้าหน้าที่ความปลอดภัยในการทำงานระดับเทคนิค ระดับเทคนิคขั้นสูง และระดับวิชาชีพ',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/163.pdf',
      ),
      FormModel(
        formId: 27,
        categoryId: 16, // 16_การจัดให้มีเจ้าหน้าที่ความปลอดภัยในการทำงานบุคลากรหน่วยงานหรือคณะบุคคล เพื่อดำเนินการด้านความปลอดภัยในสถานประกอบกิจการพ.ศ.๒๕๖๕
        categoryName: 'การจัดให้มีเจ้าหน้าที่ความปลอดภัยฯ',
        code: '164',
        formName: '(จป.ว)แบบรายงานผลการดำเนินงานของเจ้าหน้าที่ความปลอดภัยในการทำงานระดับเทคนิค ระดับเทคนิคขั้นสูง และระดับวิชาชีพ',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/164.pdf',
      ),
      FormModel(
        formId: 28,
        categoryId: 16, // 16_การจัดให้มีเจ้าหน้าที่ความปลอดภัยในการทำงานบุคลากรหน่วยงานหรือคณะบุคคล เพื่อดำเนินการด้านความปลอดภัยในสถานประกอบกิจการพ.ศ.๒๕๖๕
        categoryName: 'การจัดให้มีเจ้าหน้าที่ความปลอดภัยฯ',
        code: '165',
        formName: '(จป.ส)แบบรายงานผลการดำเนินงานของเจ้าหน้าที่ความปลอดภัยในการทำงานระดับเทคนิค ระดับเทคนิคขั้นสูง และระดับวิชาชีพ',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/165.pdf',
      ),
      FormModel(
        formId: 29,
        categoryId: 16, // 16_การจัดให้มีเจ้าหน้าที่ความปลอดภัยในการทำงานบุคลากรหน่วยงานหรือคณะบุคคล เพื่อดำเนินการด้านความปลอดภัยในสถานประกอบกิจการพ.ศ.๒๕๖๕
        categoryName: 'การจัดให้มีเจ้าหน้าที่ความปลอดภัยฯ',
        code: '166',
        formName: 'ว่าด้วยหลักเกณฑ์การประเมินโดยวิธีการทดสอบ หลักสูตรเจ้าหน้าที่ความปลอดภัยในการทำงานระดับเทคนิคขั้นสูง และระดับวิชาชีพ',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/166.pdf',
      ),
      FormModel(
        formId: 30,
        categoryId: 16, // 16_การจัดให้มีเจ้าหน้าที่ความปลอดภัยในการทำงานบุคลากรหน่วยงานหรือคณะบุคคล เพื่อดำเนินการด้านความปลอดภัยในสถานประกอบกิจการพ.ศ.๒๕๖๕
        categoryName: 'การจัดให้มีเจ้าหน้าที่ความปลอดภัยฯ',
        code: '167',
        formName:
            '(กภ.คปอ.ผบ ๑) หลักสูตรการฝึกอบรม คุณสมบัติวิทยากร และการดำเนินการฝึกอบรมคณะกรรมการ ความปลอดภัย อาชีวอนามัย และสภาพแวดล้อมในการทำงานของสถานประกอบกิจการและผู้บริหารหน่วยงานความปลอดภัย',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/167.pdf',
      ),
      FormModel(
        formId: 31,
        categoryId: 16, // 16_การจัดให้มีเจ้าหน้าที่ความปลอดภัยในการทำงานบุคลากรหน่วยงานหรือคณะบุคคล เพื่อดำเนินการด้านความปลอดภัยในสถานประกอบกิจการพ.ศ.๒๕๖๕
        categoryName: 'การจัดให้มีเจ้าหน้าที่ความปลอดภัยฯ',
        code: '168',
        formName:
            '(กภ.คปอ.ผบ ๒_๑) หลักสูตรการฝึกอบรม คุณสมบัติวิทยากร และการดำเนินการฝึกอบรมคณะกรรมการ ความปลอดภัย อาชีวอนามัย และสภาพแวดล้อมในการทำงานของสถานประกอบกิจการและผู้บริหารหน่วยงานความปลอดภัย',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/168.pdf',
      ),
      FormModel(
        formId: 32,
        categoryId: 16, // 16_การจัดให้มีเจ้าหน้าที่ความปลอดภัยในการทำงานบุคลากรหน่วยงานหรือคณะบุคคล เพื่อดำเนินการด้านความปลอดภัยในสถานประกอบกิจการพ.ศ.๒๕๖๕
        categoryName: 'การจัดให้มีเจ้าหน้าที่ความปลอดภัยฯ',
        code: '169',
        formName:
            '(กภ.คปอ.ผบ ๒_๒) หลักสูตรการฝึกอบรม คุณสมบัติวิทยากร และการดำเนินการฝึกอบรมคณะกรรมการ ความปลอดภัย อาชีวอนามัย และสภาพแวดล้อมในการทำงานของสถานประกอบกิจการและผู้บริหารหน่วยงานความปลอดภัย',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/169.pdf',
      ),
      FormModel(
        formId: 33,
        categoryId: 16, // 16_การจัดให้มีเจ้าหน้าที่ความปลอดภัยในการทำงานบุคลากรหน่วยงานหรือคณะบุคคล เพื่อดำเนินการด้านความปลอดภัยในสถานประกอบกิจการพ.ศ.๒๕๖๕
        categoryName: 'การจัดให้มีเจ้าหน้าที่ความปลอดภัยฯ',
        code: '1610',
        formName:
            '(กภ.คปอ.ผบ ๓) หลักสูตรการฝึกอบรม คุณสมบัติวิทยากร และการดำเนินการฝึกอบรมคณะกรรมการ ความปลอดภัย อาชีวอนามัย และสภาพแวดล้อมในการทำงานของสถานประกอบกิจการและผู้บริหารหน่วยงานความปลอดภัย',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/1610.pdf',
      ),
      FormModel(
        formId: 34,
        categoryId: 16, // 16_การจัดให้มีเจ้าหน้าที่ความปลอดภัยในการทำงานบุคลากรหน่วยงานหรือคณะบุคคล เพื่อดำเนินการด้านความปลอดภัยในสถานประกอบกิจการพ.ศ.๒๕๖๕
        categoryName: 'การจัดให้มีเจ้าหน้าที่ความปลอดภัยฯ',
        code: '1611',
        formName:
            '(แบบ กภ.จป.ส ๑) หลักสูตรการฝึกอบรม คุณสมบัติวิทยากร และการดำเนินการฝึกอบรมเจ้าหน้าที่ความปลอดภัยในการทำงานระดับเทคนิคขั้นสูงและหลักเกณฑ์การประเมิน',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/1611.pdf',
      ),
      FormModel(
        formId: 35,
        categoryId: 16, // 16_การจัดให้มีเจ้าหน้าที่ความปลอดภัยในการทำงานบุคลากรหน่วยงานหรือคณะบุคคล เพื่อดำเนินการด้านความปลอดภัยในสถานประกอบกิจการพ.ศ.๒๕๖๕
        categoryName: 'การจัดให้มีเจ้าหน้าที่ความปลอดภัยฯ',
        code: '1612',
        formName:
            '(แบบ กภ.จป.ส ๒) หลักสูตรการฝึกอบรม คุณสมบัติวิทยากร และการดำเนินการฝึกอบรมเจ้าหน้าที่ความปลอดภัยในการทำงานระดับเทคนิคขั้นสูงและหลักเกณฑ์การประเมิน',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/1612.pdf',
      ),
      FormModel(
        formId: 36,
        categoryId: 16, // 16_การจัดให้มีเจ้าหน้าที่ความปลอดภัยในการทำงานบุคลากรหน่วยงานหรือคณะบุคคล เพื่อดำเนินการด้านความปลอดภัยในสถานประกอบกิจการพ.ศ.๒๕๖๕
        categoryName: 'การจัดให้มีเจ้าหน้าที่ความปลอดภัยฯ',
        code: '1613',
        formName:
            '(แบบ กภ.จป.ส ๓) หลักสูตรการฝึกอบรม คุณสมบัติวิทยากร และการดำเนินการฝึกอบรมเจ้าหน้าที่ความปลอดภัยในการทำงานระดับเทคนิคขั้นสูงและหลักเกณฑ์การประเมิน',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/1613.pdf',
      ),
      FormModel(
        formId: 37,
        categoryId: 16, // 16_การจัดให้มีเจ้าหน้าที่ความปลอดภัยในการทำงานบุคลากรหน่วยงานหรือคณะบุคคล เพื่อดำเนินการด้านความปลอดภัยในสถานประกอบกิจการพ.ศ.๒๕๖๕
        categoryName: 'การจัดให้มีเจ้าหน้าที่ความปลอดภัยฯ',
        code: '1614',
        formName: '(กภ.จป.ว ๑) หลักสูตรการฝึกอบรม คุณสมบัติวิทยากร และการดำเนินการฝึกอบรมเจ้าหน้าที่ความปลอดภัยในการทำงานระดับวิชาชีพและหลักเกณฑ์การประเมิน',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/1614.pdf',
      ),
      FormModel(
        formId: 38,
        categoryId: 16, // 16_การจัดให้มีเจ้าหน้าที่ความปลอดภัยในการทำงานบุคลากรหน่วยงานหรือคณะบุคคล เพื่อดำเนินการด้านความปลอดภัยในสถานประกอบกิจการพ.ศ.๒๕๖๕
        categoryName: 'การจัดให้มีเจ้าหน้าที่ความปลอดภัยฯ',
        code: '1615',
        formName: '(กภ.จป.ว ๒) หลักสูตรการฝึกอบรม คุณสมบัติวิทยากร และการดำเนินการฝึกอบรมเจ้าหน้าที่ความปลอดภัยในการทำงานระดับวิชาชีพและหลักเกณฑ์การประเมิน',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/1615.pdf',
      ),
      FormModel(
        formId: 39,
        categoryId: 16, // 16_การจัดให้มีเจ้าหน้าที่ความปลอดภัยในการทำงานบุคลากรหน่วยงานหรือคณะบุคคล เพื่อดำเนินการด้านความปลอดภัยในสถานประกอบกิจการพ.ศ.๒๕๖๕
        categoryName: 'การจัดให้มีเจ้าหน้าที่ความปลอดภัยฯ',
        code: '1616',
        formName: '(กภ.จป.ว ๓) หลักสูตรการฝึกอบรม คุณสมบัติวิทยากร และการดำเนินการฝึกอบรมเจ้าหน้าที่ความปลอดภัยในการทำงานระดับวิชาชีพและหลักเกณฑ์การประเมิน',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/1616.pdf',
      ),
      FormModel(
        formId: 40,
        categoryId: 16, // 16_การจัดให้มีเจ้าหน้าที่ความปลอดภัยในการทำงานบุคลากรหน่วยงานหรือคณะบุคคล เพื่อดำเนินการด้านความปลอดภัยในสถานประกอบกิจการพ.ศ.๒๕๖๕
        categoryName: 'การจัดให้มีเจ้าหน้าที่ความปลอดภัยฯ',
        code: '1617',
        formName: '(กภ.จป.นป ๑) หลักสูตรการฝึกอบรม คุณสมบัติวิทยากร และการดำเนินการฝึกอบรมเจ้าหน้าที่ความปลอดภัยในการทำงานระดับหัวหน้างานและระดับบริหาร',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/1617.pdf',
      ),
      FormModel(
        formId: 41,
        categoryId: 16, // 16_การจัดให้มีเจ้าหน้าที่ความปลอดภัยในการทำงานบุคลากรหน่วยงานหรือคณะบุคคล เพื่อดำเนินการด้านความปลอดภัยในสถานประกอบกิจการพ.ศ.๒๕๖๕
        categoryName: 'การจัดให้มีเจ้าหน้าที่ความปลอดภัยฯ',
        code: '1618',
        formName: '(กภ.จป.นป ๒) หลักสูตรการฝึกอบรม คุณสมบัติวิทยากร และการดำเนินการฝึกอบรมเจ้าหน้าที่ความปลอดภัยในการทำงานระดับหัวหน้างานและระดับบริหาร',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/1618.pdf',
      ),
      FormModel(
        formId: 42,
        categoryId: 16, // 16_การจัดให้มีเจ้าหน้าที่ความปลอดภัยในการทำงานบุคลากรหน่วยงานหรือคณะบุคคล เพื่อดำเนินการด้านความปลอดภัยในสถานประกอบกิจการพ.ศ.๒๕๖๕
        categoryName: 'การจัดให้มีเจ้าหน้าที่ความปลอดภัยฯ',
        code: '1619',
        formName: '(กภ.จป.นป ๓) หลักสูตรการฝึกอบรม คุณสมบัติวิทยากร และการดำเนินการฝึกอบรมเจ้าหน้าที่ความปลอดภัยในการทำงานระดับหัวหน้างานและระดับบริหาร',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/1619.pdf',
      ),
      FormModel(
        formId: 43,
        categoryId: 16, // 16_การจัดให้มีเจ้าหน้าที่ความปลอดภัยในการทำงานบุคลากรหน่วยงานหรือคณะบุคคล เพื่อดำเนินการด้านความปลอดภัยในสถานประกอบกิจการพ.ศ.๒๕๖๕
        categoryName: 'การจัดให้มีเจ้าหน้าที่ความปลอดภัยฯ',
        code: '1620',
        formName: '(แบบ กภ.จป.ท ๑) หลักสูตรการฝึกอบรม คุณสมบัติวิทยากรและการดำเนินการฝึกอบรมเจ้าหน้าที่ความปลอดภัยในการทำงานระดับเทคนิค',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/1620.pdf',
      ),
      FormModel(
        formId: 44,
        categoryId: 16, // 16_การจัดให้มีเจ้าหน้าที่ความปลอดภัยในการทำงานบุคลากรหน่วยงานหรือคณะบุคคล เพื่อดำเนินการด้านความปลอดภัยในสถานประกอบกิจการพ.ศ.๒๕๖๕
        categoryName: 'การจัดให้มีเจ้าหน้าที่ความปลอดภัยฯ',
        code: '1621',
        formName: '(แบบ กภ.จป.ท ๒) หลักสูตรการฝึกอบรม คุณสมบัติวิทยากรและการดำเนินการฝึกอบรมเจ้าหน้าที่ความปลอดภัยในการทำงานระดับเทคนิค',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/1621.pdf',
      ),
      FormModel(
        formId: 45,
        categoryId: 16, // 16_การจัดให้มีเจ้าหน้าที่ความปลอดภัยในการทำงานบุคลากรหน่วยงานหรือคณะบุคคล เพื่อดำเนินการด้านความปลอดภัยในสถานประกอบกิจการพ.ศ.๒๕๖๕
        categoryName: 'การจัดให้มีเจ้าหน้าที่ความปลอดภัยฯ',
        code: '1622',
        formName: '(แบบ กภ.จป.ท ๓) หลักสูตรการฝึกอบรม คุณสมบัติวิทยากรและการดำเนินการฝึกอบรมเจ้าหน้าที่ความปลอดภัยในการทำงานระดับเทคนิค',
        formImage: null,
        formUpdatedAt: DateTime.now(),
        formActive: true,
        pdfPath: 'assets/pdfs/1622.pdf',
      ),
    ];
  }
}
