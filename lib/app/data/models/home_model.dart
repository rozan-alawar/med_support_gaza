class NightPrice {
  int totalPrice;
  int preNightPrice;
  int totalNight;

  NightPrice({
    required this.totalPrice,
    required this.preNightPrice,
    required this.totalNight,
  });

  factory NightPrice.fromJson(Map<String, dynamic> json) {
    return NightPrice(
      totalPrice: json['total_price'],
      preNightPrice: json['pre_night_price'],
      totalNight: json['total_night'],
    );
  }
}

class RatingData {
  int totalRating;
  int ratingValue;

  RatingData({
    required this.totalRating,
    required this.ratingValue,
  });

  factory RatingData.fromJson(Map<String, dynamic> json) {
    return RatingData(
      totalRating: json['total_rating'],
      ratingValue: json['rating_value'],
    );
  }
}

class Photo {
  int id;
  int classificationId;
  int orderId;
  String originalImage;

  Photo({
    required this.id,
    required this.classificationId,
    required this.orderId,
    required this.originalImage,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      classificationId: json['classification_id'],
      orderId: json['order_id'],
      originalImage: json['original_image'],
    );
  }
}

class Property {
  int id;
  int mainId;
  String name;
  RatingData ratingData;
  String bookingType;
  String cityName;
  String neighborhoodName;
  NightPrice nightPrice;
  int numberOfUnitsAvailable;
  String originalImage;
  String lat;
  String lang;
  bool isWishlist;
  List<Photo> photos;

  Property({
    required this.id,
    required this.mainId,
    required this.name,
    required this.ratingData,
    required this.bookingType,
    required this.cityName,
    required this.neighborhoodName,
    required this.nightPrice,
    required this.numberOfUnitsAvailable,
    required this.originalImage,
    required this.lat,
    required this.lang,
    required this.isWishlist,
    required this.photos,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    var ratingDataJson = json['rating_data'];
    var nightPriceJson = json['night_price'];
    var photosJson = json['photos'] as List;

    return Property(
      id: json['id'],
      mainId: json['main_id'],
      name: json['name'],
      ratingData: RatingData.fromJson(ratingDataJson),
      bookingType: json['booking_type'],
      cityName: json['city_name'],
      neighborhoodName: json['neighborhood_name'],
      nightPrice: NightPrice.fromJson(nightPriceJson),
      numberOfUnitsAvailable: json['number_of_units_available'],
      originalImage: json['original_image'],
      lat: json['lat'],
      lang: json['lang'],
      isWishlist: json['is_wishlist'],
      photos: photosJson.map((photoJson) => Photo.fromJson(photoJson)).toList(),
    );
  }
}

class PropertiesResponse {
  String? status;
  String? message;
  List<Property>? data;
  PropertiesResponse({
    this.status,
    this.message,
    this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data,
    };
  }

  factory PropertiesResponse.fromJson(Map<String, dynamic> map) {
    return PropertiesResponse(
      status: map['status'],
      message: map['message'],
      data: List<Property>.from(map['data']?.map((x) => Property.fromJson(x))),
    );
  }
}
