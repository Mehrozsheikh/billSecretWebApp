

class QrModel {
  String ? url ;
  String ? name;
  String ? urlType;


  QrModel({this.url, this.name, this.urlType });

  factory QrModel.fromJson(Map<String, dynamic> parsedJson) {
    return QrModel( url: parsedJson['url'] ?? "",
                    name: parsedJson['name'] ?? "",
                    urlType: parsedJson['urlType'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      "url": url,
      "name": name,
      "urlType": urlType,
    };
  }
}