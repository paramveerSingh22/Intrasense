class EventListModel {
  final String? eventId;
  final String? userId;
  final String? eventStatus;
  final String? title;
  final String? eventDate;
  final String? venue;
  final String? timeFrom;
  final String? timeTo;
  final String? timezone;
  final String? googleMapUrl;
  final String? description;
  final String? organiser;
  final String? organiserFirstName;
  final String? organiserLastName;

  EventListModel({
     this.eventId,
     this.userId,
     this.eventStatus,
     this.title,
     this.eventDate,
     this.venue,
     this.timeFrom,
     this.timeTo,
     this.timezone,
     this.googleMapUrl,
     this.description,
     this.organiser,
     this.organiserFirstName,
     this.organiserLastName,
  });

  // Factory method to create an Event object from a JSON map
  factory EventListModel.fromJson(Map<String, dynamic> json) {
    return EventListModel(
      eventId: json['event_id'] ??"",
      userId: json['user_id'] ??"",
      eventStatus: json['event_status'] ??"",
      title: json['title'] ??"",
      eventDate: json['eventdate'] ??"",
      venue: json['venue'] ??"",
      timeFrom: json['timefrom'] ??"",
      timeTo: json['timeto'] ??"",
      timezone: json['timezone'] ??"",
      googleMapUrl: json['googlemapurl'] ??"",
      description: json['description'] ??"",
      organiser: json['organiser'] ??"",
      organiserFirstName: json['organiser_firstname'] ??"",
      organiserLastName: json['organiser_lastname']??"",
    );
  }

  // Method to convert an Event object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'user_id': userId,
      'event_status': eventStatus,
      'title': title,
      'eventdate': eventDate,
      'venue': venue,
      'timefrom': timeFrom,
      'timeto': timeTo,
      'timezone': timezone,
      'googlemapurl': googleMapUrl,
      'description': description,
      'organiser': organiser,
      'organiser_firstname': organiserFirstName,
      'organiser_lastname': organiserLastName,
    };
  }

  @override
  String toString() {
    return 'Event(eventId: $eventId, '
        'userId: $userId, '
        'eventStatus: $eventStatus, '
        'title: $title,'
        ' eventDate: $eventDate,'
        ' venue: $venue, '
        'timeFrom: $timeFrom, '
        'timeTo: $timeTo, '
        'timezone: $timezone, '
        'googleMapUrl: $googleMapUrl, '
        'description: $description, '
        'organiser: $organiser, '
        'organiserFirstName: $organiserFirstName, '
        'organiserLastName: $organiserLastName)';
  }
}