
import 'dart:convert';

ContactModel contactModelFromJson(String str) => ContactModel.fromJson(json.decode(str));

String contactModelToJson(ContactModel data) => json.encode(data.toJson());

class ContactModel {
  ContactModel({
    this.status,
    this.message,
    this.data,
  });

  int status;
  String message;
  Data data;

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int currentPage;
  List<Datum> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  String nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class Datum {
  Datum({
    this.vchrCustomerMobile,
    this.pkIntEnquiryId,
    this.vchrCustomerName,
    this.vchrPurpose,
    this.vchrStatus,
    this.createdAt,
    this.createdDate,
  });

  String vchrCustomerMobile;
  int pkIntEnquiryId;
  String vchrCustomerName;
  VchrPurpose vchrPurpose;
  String vchrStatus;
  DateTime createdAt;
  String createdDate;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    vchrCustomerMobile: json["vchr_customer_mobile"],
    pkIntEnquiryId: json["pk_int_enquiry_id"],
    vchrCustomerName: json["vchr_customer_name"],
    vchrPurpose: vchrPurposeValues.map[json["vchr_purpose"]],
    vchrStatus: json["vchr_status"],
    createdAt: DateTime.parse(json["created_at"]),
    createdDate: json["created_date"],
  );

  Map<String, dynamic> toJson() => {
    "vchr_customer_mobile": vchrCustomerMobile,
    "pk_int_enquiry_id": pkIntEnquiryId,
    "vchr_customer_name": vchrCustomerName,
    "vchr_purpose": vchrPurposeValues.reverse[vchrPurpose],
    "vchr_status": vchrStatus,
    "created_at": createdAt.toIso8601String(),
    "created_date": createdDate,
  };
}

enum VchrPurpose { NO_PURPOSE_MENTIONED, WEBSITE_DESIGNING, TRAINING }

final vchrPurposeValues = EnumValues({
  "No Purpose Mentioned": VchrPurpose.NO_PURPOSE_MENTIONED,
  "Training": VchrPurpose.TRAINING,
  "Website Designing": VchrPurpose.WEBSITE_DESIGNING
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
