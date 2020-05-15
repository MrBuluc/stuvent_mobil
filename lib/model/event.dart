class Event {
  final String title,
      location,
      category,
      imageURL;
  final DateTime date;

  Event(
      {this.title,
      this.location,
      this.date,
      this.category,
      this.imageURL});
}

final events = [];
