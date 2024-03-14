class EventList {
  final String? club;
  final String? contact;
  late DateTime? eventdateStart;
  late DateTime? eventdateEnd;
  final String? priceBadminton;
  late List? level;
  final String? brand;
  final String? priceplay;
  final String? details;

  EventList({
    this.club,
    this.contact,
    this.eventdateStart,
    this.eventdateEnd,
    this.brand,
    this.level,
    this.priceBadminton,
    this.priceplay,
    this.details,
  });
}

class ClubList {
  final String? owner;
  late List? follower;
  final String? clubname;
  late List? admin;
  late List? eventId;

  ClubList({
    this.owner,
    this.follower,
    this.clubname,
    this.admin,
    this.eventId,
  });
}
