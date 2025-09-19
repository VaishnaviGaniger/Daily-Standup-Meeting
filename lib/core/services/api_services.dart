import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:message_notifier/config/api_constants.dart';
import 'package:message_notifier/core/services/dio_service.dart';
import 'package:message_notifier/core/services/shared_prefs_service.dart';
import 'package:message_notifier/features/auth/model/login_request_model.dart';
import 'package:message_notifier/features/employees/model/meetings_update_model.dart';
import 'package:message_notifier/features/employees/model/project_list_model.dart';
import 'package:message_notifier/features/employees/model/standup_history_model.dart';
import 'package:message_notifier/features/employees/model/submit_daily_task.dart';
import 'package:message_notifier/features/host/model/approve_user_model.dart';
import 'package:message_notifier/features/host/model/host_profile_model.dart';
import 'package:message_notifier/features/host/model/requesting_user_model.dart';

import '../../features/employees/model/emp_profile_model.dart';

//final basicAuth = 'Basic ${base64Encode(utf8.encode('shri:shri'))}';
final basicAuth = 'Basic ${base64Encode(utf8.encode('why:why'))}';
var dio = Dio();

class ApiServices {
  static Map<String, String> _headersWithToken() {
    final token = SharedPrefsService.getToken();

    if (token != null || token?.isEmpty == true) {
      return {
        'Authorization': 'Token $token',
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

  Future login(LoginRequestModel input) async {
    try {
      final response = await DioService.postMethod(
        url: ApiConstants.loginUrl,
        headers: {
          'Authorization': basicAuth,
          'Content-Type': 'application/json',
        },
        input: input.toJson(),
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

  //  --------------------------------  HOST  ------------------------------------

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

  // static Future<List<RequestingUserModel>> requestingUserData() async {
  //   try {
  //     final response = await dio.get(
  //       ApiConstants.requestingUser,
  //       options: Options(headers: _headersWithToken()),
  //     );
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final userdata = response.data;
  //       final List<RequestingUserModel> user = [];
  //       for (var i in userdata) {
  //         user.add(RequestingUserModel.fromJson(i));
  //       }
  //       return user;
  //     } else {
  //       throw Exception("Error");
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  static Future<List<ApproveUserModel>> approvedUser() async {
    try {
      final response = await dio.get(
        ApiConstants.approvedUser,
        options: Options(headers: _headersWithToken()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> responseData = response.data;
        final users = responseData
            .map((e) => ApproveUserModel.fromJson(e as Map<String, dynamic>))
            .toList();
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
      final token = await SharedPrefsService.getToken();
      if (token == null) {
        return {'success': false, 'error': 'No authentication token'};
      }
      final response = await dio.post(
        "${ApiConstants.approveUser}$id/",
        data: input,
        options: Options(headers: _headersWithToken()),
      );
      print("Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");
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
      final token = await SharedPrefsService.getToken();
      if (token == null) {
        return {'success': false, 'error': 'No authentication token found'};
      }

      final response = await dio.post(
        "${ApiConstants.rejectUser}$id/",
        options: Options(
          headers: {
            'Authorization': 'Token $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        throw Exception("Failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Failed to reject user: $e");
    }
  }

  static Future<List<StandupHistoryModel>> standupHistoryhost() async {
    try {
      final response = await DioService.getMethod(
        url: ApiConstants.standupHistory,
        headers: _headersWithToken(),
      );
      if (response.success) {
        final List<StandupHistoryModel> responsehistory = [];
        for (var i in response.data) {
          responsehistory.add(StandupHistoryModel.fromJson(i));
        }
        return responsehistory;
      } else {
        throw Exception(response.error);
      }
    } catch (e) {
      rethrow;
    }
  }

  // static Future<EmpProfileModel?> empprofile() async {
  //   try {
  //     final token = await SharedPrefsService.getToken();
  //     if (token == null) {
  //       return null;
  //     }
  //     print('Using token for API call: $token');
  //     final response = await dio.get(
  //       ApiConstants.empprofile,
  //       options: Options(headers: {'Authorization': 'Token $token'}),
  //     );
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       print("Employee Response: $response");

  //       return EmpProfileModel.fromJson(response.data);
  //     } else {
  //       print("Error: ${response.statusCode}");
  //       return null;
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //     throw Exception("Failed to reject user: $e");
  //   }
  // }

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
      final token = await SharedPrefsService.getToken();
      if (token == null) {
        return {'success': false, 'error': 'No authentication token'};
      }
      final response = await dio.post(
        ApiConstants.logout,
        options: Options(
          headers: {
            'Authorization': 'Token $token',
            'Content-Type': 'application/json',
          },
        ),
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

  // static Future<EmpProfileModel?> updateprofile(
  //   Map<String, dynamic> input,
  // ) async {
  //   try {
  //     final token = await SharedPrefsService.getToken();
  //     if (token == null) {
  //       return null;
  //     }
  //     final response = await dio.patch(
  //       ApiConstants.updateprofile,
  //       data: jsonEncode(input),
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Token $token',
  //           'Content-Type': 'application/json',
  //         },
  //       ),
  //     );
  //     if (response.statusCode == 200) {
  //       return EmpProfileModel.fromJson(response.data);
  //     }
  //   } catch (e) {
  //     print("Error $e");
  //   }
  //   return null;
  // }
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

  // static Future submitdailytask(Map<String, dynamic> tasks) async {
  //   try {
  //     final token = await SharedPrefsService.getToken();
  //     if (token == null) {
  //       return null;
  //     }
  //     final response = await dio.post(
  //       ApiConstants.submitDailyTask,
  //       data: tasks,
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Token $token',
  //           'Content-Type': 'application/json',
  //         },
  //       ),
  //     );
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       print("Response Submit Task: ${response.data['detail']}");
  //       return response.data;
  //     }
  //   } catch (e, stack) {
  //     print("Error $e");
  //     print("$stack");
  //   }
  // }
  static Future submitdailytask(Map<String, dynamic> input) async {
    try {
      final response = await DioService.postMethod(
        url: ApiConstants.submitDailyTask,
        headers: _headersWithToken(),
        input: input,
      );
      if (response.success) {
        final detail = response.data is Map && response.data['detail'] != null
            ? response.data['detail'].toString()
            : "Task submitted successfully.";

        return SubmitDailyTaskResponseModel(detail: detail);
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
      final token = await SharedPrefsService.getToken();
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

  static Future<List<StandupHistoryModel>> standuphistory() async {
    try {
      final response = await DioService.getMethod(
        url: ApiConstants.standupHistory,
        headers: _headersWithToken(),
      );
      if (response.success) {
        print(response.data);
        List<StandupHistoryModel> history = [];
        for (var i in response.data) {
          history.add(StandupHistoryModel.fromJson(i));
        }
        return history;
      } else {
        throw Exception(response.error);
      }
    } catch (e) {
      rethrow;
    }
  }

  //----------------Employee---------------------//

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

  static Future<dynamic> submitdailytasks(Map<String, dynamic> input) async {
    try {
      final response = await DioService.postMethod(
        url: ApiConstants.submitDailyTask,
        headers: _headersWithToken(),
        input: input,
      );
      if (response.success) {
        return SubmitDailyTaskResponseModel(detail: response.data);
      } else {
        throw Exception(response.error);
      }
    } catch (e) {
      rethrow;
    }
  }
}
