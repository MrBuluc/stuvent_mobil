import 'package:http/http.dart' as http;

class BildirimGondermeServis {
  Future<bool> eventBildirimGonder(Map<String, dynamic> eventMap) async {
    String endUrl = "https://fcm.googleapis.com/fcm/send";

    String stuventFirebaseKey =
        "AAAAzHFBr9k:APA91bHUcYB__s-PeOXLul36TJ6R2VDXTMjY9q0QOclc9TRkrRlO17peox1M25Ii0NW49FFVEiUq1zTd7wDcBr49fhweeUm3nbZVdkjtrmqbcbvb8UbZIq-Nz5d3jJLjfnEPwtX6LFcN";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "key=$stuventFirebaseKey"
    };

    String location = eventMap["Etkinlik Konumu"];
    String title = eventMap["Etkinlik Adı"];
    String image_url = eventMap["Etkinlik Photo Url"];
    List<dynamic> categoryList = eventMap["category"];
    List<dynamic> participants = eventMap["Katilimcilar"];
    Map<String, dynamic> docMap = eventMap["Dosyalar"];

    String json =
        '{"to": "/topics/all", "data": {"title": "$title", "message": "$location", "image-url": "$image_url", "category": "$categoryList", "Dosyalar": "$docMap", "Katilimcilar": "$participants"}}';

    http.Response response =
        await http.post(endUrl, headers: headers, body: json);

    if (response.statusCode == 200) {
      print("işlem başarılı");
      return true;
    } else {
      print("işlem başarısız: " + response.statusCode.toString());
      print("json: " + json);
      return false;
    }
  }

  Future<bool> bigTextBildirimGonder(
      String title, String message, String bigText) async {
    String endUrl = "https://fcm.googleapis.com/fcm/send";

    String stuventFirebaseKey =
        "AAAAzHFBr9k:APA91bHUcYB__s-PeOXLul36TJ6R2VDXTMjY9q0QOclc9TRkrRlO17peox1M25Ii0NW49FFVEiUq1zTd7wDcBr49fhweeUm3nbZVdkjtrmqbcbvb8UbZIq-Nz5d3jJLjfnEPwtX6LFcN";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "key=$stuventFirebaseKey"
    };

    String json =
        '{"to": "/topics/all", "data": {"title": "$title", "message": "$message", "bigText": "$bigText"}}';
    http.Response response =
        await http.post(endUrl, headers: headers, body: json);

    if (response.statusCode == 200) {
      print("işlem başarılı");
      return true;
    } else {
      print("işlem başarısız: " + response.statusCode.toString());
      print("json: " + json);
      return false;
    }
  }
}
