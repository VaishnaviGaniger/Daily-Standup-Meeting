class ApiConstants {
  // static const String baseUrl = 'http://192.168.0.116:8000/api/';

  // static const String baseUrl = 'http://192.168.0.109:8000/api/';

  static const String baseUrl = "http://192.168.0.112:8000/api/";

  static const String registerUrl = '${baseUrl}RegisterAPI/';
  static const String loginUrl = '${baseUrl}LoginAPI/';
  static const String createProject = '${baseUrl}ProjectCreateAPI/';

  static const String requestingUser = '${baseUrl}requesting_to_approve/';
  static const String approveUser = '${baseUrl}ApproveUserAPI/';
  static const String approvedUser = '${baseUrl}ApprovedListsAPI/';

  static final String rejectUser = '${baseUrl}RejectUserAPI/';

  static const String empprofile = '${baseUrl}EmpProfileView/';

  static const String scheduleMeeting = '${baseUrl}ScheduleMeetingAPIView/';

  static const String scheduleMeetings = '${baseUrl}ScheduleMeetingAPIView/';

  static const String standupHistory = '${baseUrl}SubmitDailyTaskAPIView/';

  static const String updateMeeting = '${baseUrl}update_meeting/';

  static const String submitDailyTask = '${baseUrl}SubmitDailyTaskAPIView/';

  static const String projectList = '${baseUrl}ProjectList/';

  static const String updateprofile = '${baseUrl}EmpProfileView/';

  static const String logout = '${baseUrl}logout_api/';
}
