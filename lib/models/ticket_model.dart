class Ticket {
  final String user;
  final String key;
  final String venue;
  final DateTime date;
  final int slot;

  Ticket(this.user, this.slot, {required this.key, required this.venue, required this.date});
}