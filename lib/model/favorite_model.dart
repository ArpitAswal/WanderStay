class FavoriteModel {
  String favID;
  String favTitle;
  List<String> favImageUrls;
  String vendorName;
  String vendorProfile;
  double latitude;
  double longitude;

  FavoriteModel(
      {required this.favID,
      required this.favTitle,
      required this.favImageUrls,
      required this.vendorName,
      required this.vendorProfile,
      required this.latitude,
      required this.longitude});

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
        favID: map['favID'] ?? "",
        favTitle: map['favTitle'] ?? "",
        favImageUrls: map['favImageUrls'].cast<String>() ?? [],
        vendorName: map['vendorName'] ?? "",
        vendorProfile: map['vendorProfile'] ?? "",
        latitude: map['latitude'] ?? 0.0,
        longitude: map['longitude'] ?? 0.0);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'favID': favID,
      'favTitle': favTitle,
      'favImageUrls': favImageUrls,
      'vendorName': vendorName,
      'vendorProfile': vendorProfile,
      'latitude': latitude,
      'longitude': longitude
    };
  }
}
