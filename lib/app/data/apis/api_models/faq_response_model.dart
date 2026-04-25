class FaqResponseModel {
  int? statusCode;
  List<FaqData>? data;
  String? message;
  bool? success;

  FaqResponseModel({this.statusCode, this.data, this.message, this.success});

  FaqResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = <FaqData>[];
      json['data'].forEach((v) {
        data!.add(FaqData.fromJson(v));
      });
    }
    message = json['message'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['success'] = success;
    return data;
  }
}

class FaqData {
  String? sId;
  String? question;
  String? answer;
  String? createdAt;
  String? updatedAt;
  int? iV;

  FaqData(
      {this.sId,
      this.question,
      this.answer,
      this.createdAt,
      this.updatedAt,
      this.iV});

  FaqData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    question = json['question'];
    answer = json['answer'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['question'] = question;
    data['answer'] = answer;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
