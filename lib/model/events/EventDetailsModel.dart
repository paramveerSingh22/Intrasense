class EventDetailsModel{
  final EventDetails eventDetails;
  final List<Attendee> attendees;
  final List<ClientDetail> clientDetails;
  final List<GroupDetail> groupDetails;

  EventDetailsModel({
    required this.eventDetails,
    required this.attendees,
    required this.clientDetails,
    required this.groupDetails,
  });

  factory EventDetailsModel.fromJson(Map<String, dynamic> json) {
    return EventDetailsModel(
      eventDetails: EventDetails.fromJson(json['event_details']),
      attendees: (json['attendees'] as List)
          .map((item) => Attendee.fromJson(item))
          .toList(),
        clientDetails: (json['client_details'] as List)
            .map((item) => ClientDetail.fromJson(item))
            .toList(),
      groupDetails: (json['group_details'] as List)
          .map((item) => GroupDetail.fromJson(item))
          .toList(),
    );
  }
}

class EventDetails {
  final String? eventId;
  final String? title;
  final String? eventDate;
  final String? venue;
  final String? timeFrom;
  final String? timeTo;
  final String? timezone;
  final String? googleMapUrl;
  final String? description;
  final String? organiser;
  final String? organiserFname;
  final String? organiserLname;

  EventDetails({
     this.eventId,
     this.title,
     this.eventDate,
     this.venue,
     this.timeFrom,
     this.timeTo,
     this.timezone,
     this.googleMapUrl,
     this.description,
     this.organiser,
     this.organiserFname,
     this.organiserLname,
  });

  factory EventDetails.fromJson(Map<String, dynamic> json) {
    return EventDetails(
      eventId: json['event_id']??"",
      title: json['title']??"",
      eventDate: json['eventdate']??"",
      venue: json['venue']??"",
      timeFrom: json['timefrom']??"",
      timeTo: json['timeto']??"",
      timezone: json['timezone']??"",
      googleMapUrl: json['googlemapurl']??"",
      description: json['description']??"",
      organiser: json['organiser']??"",
      organiserFname: json['organiser_fname']??"",
      organiserLname: json['organiser_lname']??"",
    );
  }
}

class Attendee {
  final String? userId;
  final String? attendeeFname;
  final String? attendeeLname;

  Attendee({
     this.userId,
     this.attendeeFname,
     this.attendeeLname,
  });

  factory Attendee.fromJson(Map<String, dynamic> json) {
    return Attendee(
      userId: json['user_id']??"",
      attendeeFname: json['attendee_fname']??"",
      attendeeLname: json['attendee_lname']??"",
    );
  }
}

class GroupDetail {
  final String? groupId;
  final String? groupName;

  GroupDetail({
     this.groupId,
     this.groupName,
  });

  factory GroupDetail.fromJson(Map<String, dynamic> json) {
    return GroupDetail(
      groupId: json['group_id']??"",
      groupName: json['group_name']??"",
    );
  }
}


class ClientDetail {
  final String? clientId;
  final String? status;
  final String? companyName;
  final String? companyEmailId;

  ClientDetail({
    this.clientId,
    this.status,
    this.companyName,
    this.companyEmailId,
  });

  factory ClientDetail.fromJson(Map<String, dynamic> json) {
    return ClientDetail(
      clientId: json['client_id']??"",
      status: json['status']??"",
      companyName: json['company_name']??"",
      companyEmailId: json['company_emailid']??"",
    );
  }
}
