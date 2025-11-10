import 'package:message_notifier/core/services/shared_prefs_service.dart';

class ApiConstants {
  // static String baseUrl = "http://192.168.0.108:8000/api/";
  static String baseUrl =
      SharedPrefsService.getStoredIp() ?? "https://dsync.gfgtech.live/api/";
  //  "https://dsync.gfgtech.live/api/"
  //static String baseUrl = "http://192.168.1.38:8000/api/";

  static String registerUrl = '${baseUrl}RegisterAPI/';
  static String loginUrl = '${baseUrl}LoginAPI/';
  static String registerFcmToken = "${baseUrl}RegisterFCMTokenAPI/";

  static String createProject = '${baseUrl}ProjectCreateAPI/';
  static String requestingUser = '${baseUrl}requesting_to_approve/';
  static String approveUser = '${baseUrl}ApproveUserAPI/';

  static String approvedUser = '${baseUrl}ApprovedList/';

  static final String rejectUser = '${baseUrl}RejectUserAPI/';

  static String empprofile = '${baseUrl}EmpProfileView/';

  static String scheduleMeeting = '${baseUrl}ScheduleMeetingAPIView/';

  static String scheduleMeetings = '${baseUrl}ScheduleMeetingAPIView/';
  static String scheduleMeetingHost = '${baseUrl}ScheduleMeetingAPIView/';

  static String updateMeeting = '${baseUrl}update_meeting/';

  // static String submitDailyTask = '${baseUrl}SubmitDailyTaskAPIView/';

  static String projectList = '${baseUrl}ProjectList/';

  static String updateprofile = '${baseUrl}EmpProfileView/';

  static String cancelMeeting = '${baseUrl}CancelMeetingAPIView/';

  static String teamLeadAllTasks = '${baseUrl}team-lead/all-tasks/';

  static String logout = '${baseUrl}logout_api/';

  static String standupHistory = '${baseUrl}SubmitDailyUpdateAPIView/?date=';

  static String submitdailytasks = '${baseUrl}SubmitDailyUpdateAPIView/';
}
