class CancleMeetingModel {
  final String reason;

  CancleMeetingModel({required this.reason});

  Map<String, dynamic> toJson() {
    return {"reason": reason};
  }
}
