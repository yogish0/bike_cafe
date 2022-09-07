import 'dart:convert';

DownloadInvoiceModel downloadInvoiceModelFromMap(String str) => DownloadInvoiceModel.fromMap(json.decode(str));

class DownloadInvoiceModel {
  DownloadInvoiceModel({
    required this.isInvoiceCreated,
    this.invoiceUrl,
    this.notCreated,
    this.irnNo,
  });

  bool isInvoiceCreated;
  String? invoiceUrl;
  List<dynamic>? notCreated;
  String? irnNo;

  factory DownloadInvoiceModel.fromMap(Map<String, dynamic> json) => DownloadInvoiceModel(
    isInvoiceCreated: json["is_invoice_created"],
    invoiceUrl: json["invoice_url"],
    notCreated: List<dynamic>.from(json["not_created"].map((x) => x)),
    irnNo: json["irn_no"],
  );
}


//ship rocket token model
GetShiprocketTokenModel getShiprocketTokenModelFromMap(String str) => GetShiprocketTokenModel.fromMap(json.decode(str));

class GetShiprocketTokenModel {
  GetShiprocketTokenModel({
    required this.shiprocketToken,
  });

  String? shiprocketToken;

  factory GetShiprocketTokenModel.fromMap(Map<String, dynamic> json) => GetShiprocketTokenModel(
    shiprocketToken: json["shiprocket_token"],
  );
}
