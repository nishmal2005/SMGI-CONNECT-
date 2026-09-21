import 'package:smgi.connect/model/dummy_documentmodel.dart';

final List<DocumentItem> documents = [
  DocumentItem(
    title: 'Aadhaar Card',
    image: 'assets/images/aadhar.png',
    status: DocumentStatus.verified,
  ),
  DocumentItem(
    title: '10th Marks Card',
    image: 'assets/images/marks.png',
    status: DocumentStatus.pending,
  ),
  DocumentItem(
    title: 'Address Proof',
    image: 'assets/images/address.png',
    status: DocumentStatus.reupload,
  ),
  DocumentItem(
    title: 'Referral Code',
    image: 'assets/images/qr.png',
    status: DocumentStatus.verified,
  ),
];
