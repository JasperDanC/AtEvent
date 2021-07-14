/// Model for uploading images to the TinyPNG API
class TinyResponse {
  String url;

  void printURL() {
    print(url);
  }

  TinyResponse.fromJson(Map<String, dynamic> json)
      : url = json['output']['url'];
}
