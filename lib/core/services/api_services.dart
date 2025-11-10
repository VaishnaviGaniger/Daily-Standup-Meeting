import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:message_notifier/config/api_constants.dart';
import 'package:message_notifier/core/services/dio_service.dart';
import 'package:message_notifier/core/services/shared_prefs_service.dart';
import 'package:message_notifier/features/auth/model/login_request_model.dart';
import 'package:message_notifier/features/employees/model/emp_profile_model.dart';
import 'package:message_notifier/features/employees/model/meetings_update_model.dart';
import 'package:message_notifier/features/employees/model/project_list_model.dart';
import 'package:message_notifier/features/employees/model/standup_history_model.dart';
import 'package:message_notifier/features/host/model/updates_from_employee.dart';
import 'package:message_notifier/features/host/model/approve_user_model.dart';
import 'package:message_notifier/features/host/model/host_profile_model.dart';
import 'package:message_notifier/features/host/model/requesting_user_model.dart';
import 'package:message_notifier/features/common_model/submit_daily_tasks_model.dart';

final basicAuth = 'Basic ${base64Encode(utf8.encode('gfgtech:gfggfg'))}';
var dio = Dio();

class ApiServices {
  static Map<String, String> _headersWithToken() {
    final token = SharedPrefsService.getToken();

    if (token != null || token?.isEmpty == true) {
      return {
        'Authorization': 'Token ${token?.trim()}',
        'Content-Type': 'application/json',
      };
    } else {
      return {'Authorization': basicAuth, 'Content-Type': 'application/json'};
    }
  }

  //  ------------------------------  AUTH  ------------------------------------
  Future register(Map<String, String> input) async {
    try {
      final response = await DioService.postMethod(
        url: ApiConstants.registerUrl,
        headers: _headersWithToken(),
        input: input,
      );

      if (response.success) {
        return response.data;
      } else {
        throw Exception(response.error);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future registerfcmToken(Map<String, String> input) async {
    try {
      final response = await DioService.postMethod(
        url: ApiConstants.registerFcmToken,
        headers: _headersWithToken(),
        input: input,
      );
      print(response);
      if (response.success) {
        print("Register Response : ${response.data}");
        return response.data;
      } else {
        print("Error message");
      }
    } catch (e) {
      print("Error");
    }
  }

  Future login(LoginRequestModel input) async {
    try {
      final response = await DioService.postMethod(
        url: ApiConstants.loginUrl,
        headers: {
          'Authorization': basicAuth,
          'Content-Type': 'application/json',
        },
        input: input,
      );

      if (response.success) {
        return response.data;
      } else {
        throw Exception(response.error);
      }
    } catch (e) {
      rethrow;
    }
  }

  //------------------------------------------------------------------------------

  //  --------------------------------  HOST  ------------------------------------

  static Future<HostProfileModel> hostProfile() async {
    try {
      final response = await DioService.getMethod(
        url: ApiConstants.empprofile,
        headers: _headersWithToken(),
      );
      if (response.success) {
        return HostProfileModel.fromJson(response.data);
      } else {
        throw Exception(response.data);
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future updatehostprofile(Map<String, dynamic> input) async {
    final response = await DioService.patchMethod(
      url: ApiConstants.updateprofile,
      headers: _headersWithToken(),
      input: input,
    );
    if (response.success) {
      print("Successful response");
      return response.data;
    } else {
      print("Failed to update");
      throw Exception("Response: ${response.error}");
    }
  }

  Future createproject(Map<String, dynamic> input) async {
    try {
      final response = await DioService.postMethod(
        url: ApiConstants.createProject,
        headers: _headersWithToken(),
        input: input,
      );
      if (response.success) {
        return response.data;
      } else {
        throw Exception(response.error);
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<ApproveUserModel>> approvedUser() async {
    try {
      final response = await DioService.getMethod(
        url: ApiConstants.approvedUser,
        headers: _headersWithToken(),
      );

      print("Data: ${response.data}");

      if (response.success) {
        final List<dynamic> responseData = response.data;
        // final users = responseData
        //     .map((e) => ApproveUserModel.fromJson(e as Map<String, dynamic>))
        //     .toList();
        final List<ApproveUserModel> users = [];
        for (var i in responseData) {
          users.add(ApproveUserModel.fromJson(i));
        }
        return users;
      } else {
        throw Exception("Failed to load users");
      }
    } catch (e) {
      throw Exception("approveUsers error: $e");
    }
  }

  static Future<List<RequestingUserModel>> requestingUserData() async {
    try {
      final response = await DioService.getMethod(
        url: ApiConstants.requestingUser,
        headers: _headersWithToken(),
      );
      if (response.success) {
        final List<dynamic> data = response.data;
        return data.map((e) => RequestingUserModel.fromJson(e)).toList();
      } else {
        throw Exception(response.error);
      }
    } catch (e) {
      throw Exception("approveUsers error: $e");
    }
  }

  static Future approveUser(int id, Map<String, dynamic> input) async {
    try {
      final token = SharedPrefsService.getToken();
      if (token == null) {
        return {'success': false, 'error': 'No authentication token'};
      }
      final response = await dio.post(
        "${ApiConstants.approveUser}$id/",
        data: input,
        options: Options(headers: _headersWithToken()),
      );
      // print("Status Code: ${response.statusCode}");
      // print("Response Data: ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("ApprovedUsers Data: ${response.data['message']}");
        return response.data['message'];
      } else {
        print("Failed with status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to approve users");
    }
  }

  static Future rejectUser(int id) async {
    try {
      final token = SharedPrefsService.getToken();
      if (token == null) {
        return {'success': false, 'error': 'No authentication token found'};
      }

      final response = await dio.post(
        "${ApiConstants.rejectUser}$id/",
        options: Options(headers: {'Authorization': 'Token $token'}),
      );

      if (response.statusCode == 200) {
        print("Status Code: ${response.statusCode}");
        print("Response: $response");
        return response.data['message'];
        // return json.decode(response.data);
      } else {
        return {
          'success': false,
          'error':
              "Reject failed: ${response.statusCode} ${response.statusMessage}",
        };
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Failed to reject user: $e");
    }
  }

  static Future<dynamic> cancelMeeting(
    int id,
    Map<String, dynamic> input,
  ) async {
    try {
      final response = await DioService.postMethod(
        url: "${ApiConstants.cancelMeeting}$id/",
        headers: _headersWithToken(),
        input: input,
      );
      if (response.success) {
        final responseData = response.data;
        return responseData;
      } else {
        throw "error";
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  static Future<List<MeetingsUpdateModel>> meetingupdateHost() async {
    try {
      final response = await DioService.getMethod(
        url: ApiConstants.scheduleMeetingHost,
        headers: _headersWithToken(),
      );
      if (response.success) {
        final List<MeetingsUpdateModel> responsehistory = [];
        for (var i in response.data) {
          responsehistory.add(MeetingsUpdateModel.fromJson(i));
        }
        return responsehistory;
      } else {
        throw Exception(response.error);
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<AllTasksUpdatesModel>> allTasksUpdates() async {
    try {
      final response = await DioService.getMethod(
        url: ApiConstants.teamLeadAllTasks,
        headers: _headersWithToken(),
      );

      if (response.success) {
        print("Response data");

        final data = response.data['results'] as List;
        print(data);
        final List<AllTasksUpdatesModel> responseData = data
            .map((e) => AllTasksUpdatesModel.fromJson(e))
            .toList();

        print(responseData);
        return responseData;
      } else {
        throw Exception('API returned unsuccessful response');
      }
    } catch (e) {
      print('Error in allTasksUpdates: $e');
      rethrow;
    }
  }

  //-------------------------------- host and employee -----------------

  static Future<StandupHistoryModel> standupHistory({
    required String date,
  }) async {
    try {
      final response = await DioService.getMethod(
        url: "${ApiConstants.standupHistory}$date",
        headers: _headersWithToken(),
      );

      print("✅ API raw response: $response");
      if (response.success) {
        return StandupHistoryModel.fromJson(response.data);
      } else {
        return StandupHistoryModel.fromJson(response.data);
      }
    } catch (e) {
      print("❌ Error in standupHistory(): $e");
      rethrow;
    }
  }

  static Future<SubmitDailyUpdateResponseModel> submitdailytasks(
    Map<String, dynamic> input,
  ) async {
    try {
      final response = await DioService.postMethod(
        url: ApiConstants.submitdailytasks,
        headers: _headersWithToken(),
        input: input,
      );
      if (response.success) {
        if (response.data is Map<String, dynamic>) {
          print('one');

          return SubmitDailyUpdateResponseModel.fromJson(response.data);
        } else {
          print('two');

          return SubmitDailyUpdateResponseModel(
            message: response.data.toString(),
          );
        }
      } else {
        throw Exception(response.error);
      }
    } catch (e) {
      print('------------- ERROR : $e');
      rethrow;
    }
  }

  //  --------------------------------------------------------------------------------

  //  -------------------------------  EMPLOYEEE  ------------------------------------
  static Future<EmpProfileModel?> empprofile() async {
    try {
      final response = await DioService.getMethod(
        url: ApiConstants.empprofile,
        headers: _headersWithToken(),
      );
      if (response.success) {
        return EmpProfileModel.fromJson(response.data);
      } else {
        throw Exception(response.error);
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future scheduledMeeting(Map<String, dynamic> input) async {
    try {
      final response = await DioService.postMethod(
        url: ApiConstants.scheduleMeeting,
        headers: _headersWithToken(),
        input: input,
      );
      if (response.success) {
        return response.data;
      } else {
        throw Exception(response.error);
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> logout() async {
    try {
      final token = SharedPrefsService.getToken();
      if (token == null) {
        return {'success': false, 'error': 'No authentication token'};
      }
      final response = await dio.post(
        ApiConstants.logout,
        options: Options(headers: _headersWithToken()),
      );
      print("Status code: ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        print("Failed to logout");
        throw Exception('Failed with the statuscode: ${response.statusCode}');
      }
    } catch (e) {
      print("Error $e");
    }
    return null;
  }

  static Future<EmpProfileModel?> updateprofile(
    Map<String, dynamic> input,
  ) async {
    try {
      final response = await DioService.patchMethod(
        url: ApiConstants.updateprofile,
        headers: _headersWithToken(),
        input: input,
      );
      if (response.success) {
        return response.data;
      } else {
        throw Exception(response.error);
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<ProjectListModel>> projectList() async {
    try {
      final response = await dio.get(
        ApiConstants.projectList,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 200) {
        List<ProjectListModel> projects = [];
        for (var i in response.data) {
          projects.add(ProjectListModel.fromJson(i));
        }
        print("Project Response ${response.data}");
        print("Projects : $projects");
        return projects;
      } else {
        throw Exception("error");
      }
    } catch (e) {
      throw Exception("Error $e");
    }
  }

  static Future<Response> createsProject(Map<String, dynamic> input) async {
    try {
      final token = SharedPrefsService.getToken();
      final response = await dio.post(
        ApiConstants.createProject,
        data: input,
        options: Options(headers: {"Authorization": "Token $token"}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        throw Exception("error");
      }
    } catch (e) {
      throw Exception("Error $e");
    }
  }

  static Future<List<MeetingsUpdateModel>> meetingUpdate() async {
    try {
      final response = await DioService.getMethod(
        url: ApiConstants.scheduleMeetings,
        headers: _headersWithToken(),
      );
      if (response.success) {
        List<MeetingsUpdateModel> meetingupdates = [];
        for (var i in response.data) {
          meetingupdates.add(MeetingsUpdateModel.fromJson(i));
        }
        print("Meeting Updates: ${response.data}");
        return meetingupdates;
      } else {
        throw Exception(response.error);
      }
    } catch (e) {
      rethrow;
    }
  }

  //  ----------------------------------------------------------------------------
}
