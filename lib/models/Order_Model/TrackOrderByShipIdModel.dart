import 'dart:convert';

TrackOrderByShipIdModel trackOrderByShipIdModelFromMap(String? str) => TrackOrderByShipIdModel.fromMap(json.decode(str!));

class TrackOrderByShipIdModel {
  TrackOrderByShipIdModel({
    required this.trackingData,
  });

  TrackingData trackingData;

  factory TrackOrderByShipIdModel.fromMap(Map<String, dynamic> json) => TrackOrderByShipIdModel(
    trackingData: TrackingData.fromMap(json["tracking_data"]),
  );
}

class TrackingData {
  TrackingData({
    required this.trackStatus,
    this.shipmentStatus,
    this.shipmentTrack,
    this.shipmentTrackActivities,
    this.trackUrl,
    this.etd,
    this.qcResponse,
    this.error
  });

  int? trackStatus;
  int? shipmentStatus;
  List<ShipmentTrack>? shipmentTrack;
  List<ShipmentTrackActivity>? shipmentTrackActivities;
  String? trackUrl;
  DateTime? etd;
  QcResponse? qcResponse;
  dynamic error;

  factory TrackingData.fromMap(Map<dynamic, dynamic> json) => TrackingData(
    trackStatus: json["track_status"],
    shipmentStatus: json["shipment_status"],
    shipmentTrack: List<ShipmentTrack>.from(json["shipment_track"].map((x) => ShipmentTrack.fromMap(x))),
    shipmentTrackActivities: List<ShipmentTrackActivity>.from(json["shipment_track_activities"].map((x) => ShipmentTrackActivity.fromMap(x)) ?? []),
    trackUrl: json["track_url"],
    etd: DateTime.parse(json["etd"]),
    qcResponse: QcResponse.fromMap(json["qc_response"]),
    error: json["error"],
  );
}

class QcResponse {
  QcResponse({
    this.qcImage,
    this.qcFailedReason,
  });

  String? qcImage;
  String? qcFailedReason;

  factory QcResponse.fromMap(Map<dynamic, dynamic> json) => QcResponse(
    qcImage: json["qc_image"],
    qcFailedReason: json["qc_failed_reason"],
  );
}

class ShipmentTrack {
  ShipmentTrack({
    this.id,
    this.awbCode,
    this.courierCompanyId,
    this.shipmentId,
    this.orderId,
    this.pickupDate,
    this.deliveredDate,
    this.weight,
    this.packages,
    this.currentStatus,
    this.deliveredTo,
    this.destination,
    this.consigneeName,
    this.origin,
    this.courierAgentDetails,
    this.edd,
  });

  int? id;
  String? awbCode;
  int? courierCompanyId;
  int? shipmentId;
  int? orderId;
  DateTime? pickupDate;
  DateTime? deliveredDate;
  String? weight;
  int? packages;
  String? currentStatus;
  String? deliveredTo;
  String? destination;
  String? consigneeName;
  String? origin;
  dynamic courierAgentDetails;
  dynamic edd;

  factory ShipmentTrack.fromMap(Map<dynamic, dynamic> json) => ShipmentTrack(
    id: json["id"],
    awbCode: json["awb_code"],
    courierCompanyId: json["courier_company_id"],
    shipmentId: json["shipment_id"],
    orderId: json["order_id"],
    pickupDate: DateTime.parse(json["pickup_date"]),
    deliveredDate: DateTime.parse(json["delivered_date"]),
    weight: json["weight"],
    packages: json["packages"],
    currentStatus: json["current_status"],
    deliveredTo: json["delivered_to"],
    destination: json["destination"],
    consigneeName: json["consignee_name"],
    origin: json["origin"],
    courierAgentDetails: json["courier_agent_details"],
    edd: json["edd"],
  );
}

class ShipmentTrackActivity {
  ShipmentTrackActivity({
    this.date,
    this.status,
    this.activity,
    this.location,
    this.srStatus,
    this.srStatusLabel,
  });

  DateTime? date;
  String? status;
  String? activity;
  String? location;
  dynamic srStatus;
  String? srStatusLabel;

  factory ShipmentTrackActivity.fromMap(Map<dynamic, dynamic> json) => ShipmentTrackActivity(
    date: DateTime.parse(json["date"]),
    status: json["status"],
    activity: json["activity"],
    location: json["location"],
    srStatus: json["sr-status"],
    srStatusLabel: json["sr-status-label"],
  );
}