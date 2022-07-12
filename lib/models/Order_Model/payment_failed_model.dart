import 'dart:convert';

PaymentCancelledResponseModel paymentCancelledResponseModelFromMap(String str) => PaymentCancelledResponseModel.fromMap(json.decode(str));

String paymentCancelledResponseModelToMap(PaymentCancelledResponseModel data) => json.encode(data.toMap());

class PaymentCancelledResponseModel {
  PaymentCancelledResponseModel({
    required this.error,
  });

  Error error;

  factory PaymentCancelledResponseModel.fromMap(Map<String, dynamic> json) => PaymentCancelledResponseModel(
    error: Error.fromMap(json["error"]),
  );

  Map<String, dynamic> toMap() => {
    "error": error.toMap(),
  };
}

class Error {
  Error({
    required this.code,
    required this.description,
    required this.source,
    required this.step,
    required this.reason,
    required this.metadata,
  });

  String? code;
  String? description;
  String? source;
  String? step;
  String? reason;
  Metadata metadata;

  factory Error.fromMap(Map<String, dynamic> json) => Error(
    code: json["code"],
    description: json["description"],
    source: json["source"],
    step: json["step"],
    reason: json["reason"],
    metadata: Metadata.fromMap(json["metadata"]),
  );

  Map<String, dynamic> toMap() => {
    "code": code,
    "description": description,
    "source": source,
    "step": step,
    "reason": reason,
    "metadata": metadata.toMap(),
  };
}

class Metadata {
  Metadata({
    required this.paymentId,
  });

  String? paymentId;

  factory Metadata.fromMap(Map<String, dynamic> json) => Metadata(
    paymentId: json["payment_id"],
  );

  Map<String, dynamic> toMap() => {
    "payment_id": paymentId,
  };
}
