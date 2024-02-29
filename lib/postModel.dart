class EventList {
  final String? club;
  final String? contact;
  final String? priceBadminton;
  late List? level;
  final String? brand;
  final String? priceplay;
  final String? details;

  EventList({
    this.club,
    this.contact,
    this.brand,
    this.level,
    this.priceBadminton,
    this.priceplay,
    this.details,
  });
}

// class PostsModel {
//   PostsModel({
//       String? club, 
//       String? contact, 
//       String? priceBadminton, 
//       String? priceplay
//       }){
//     _club = club;
//     _contact = contact;
//     _priceBadminton = priceBadminton;
//     _priceplay = priceplay;
// }

//   PostsModel.fromJson(dynamic json) {
//     _club = json['club'];
//     _contact = json['contact'];
//     _priceBadminton = json['price_badminton'];
//     _priceplay = json['priceplay'];
//   }
//   String? _club, 
//   String? _contact, 
//   String? _priceBadminton, 
//   String? _priceplay

//   String? get club => _club;
//   String? get contact => _contact;
//   String? get price_badminton => _priceBadminton;
//   String? get priceplay => _priceplay;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['club'] = _club;
//     map['contact'] = _contact;
//     map['price_badminton'] = _priceBadminton;
//     map['priceplay'] = _priceplay;
//     return map;
//   }

// }