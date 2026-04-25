class PolicyResponseModel {
  int? statusCode;
  PolicyData? data;
  String? message;
  bool? success;

  PolicyResponseModel({this.statusCode, this.data, this.message, this.success});

  PolicyResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    data = json['data'] != null ? PolicyData.fromJson(json['data']) : null;
    message = json['message'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    data['success'] = success;
    return data;
  }
}

class PolicyData {
  String? sId;
  String? headingOne;
  String? descriptionOne;
  String? headingTwo;
  String? descriptionTwo;
  String? createdAt;
  String? updatedAt;
  int? iV;

  PolicyData(
      {this.sId,
      this.headingOne,
      this.descriptionOne,
      this.headingTwo,
      this.descriptionTwo,
      this.createdAt,
      this.updatedAt,
      this.iV});

  PolicyData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    headingOne = json['headingOne'];
    descriptionOne = json['descriptionOne'];
    headingTwo = json['headingTwo'];
    descriptionTwo = json['descriptionTwo'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['headingOne'] = headingOne;
    data['descriptionOne'] = descriptionOne;
    data['headingTwo'] = headingTwo;
    data['descriptionTwo'] = descriptionTwo;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
