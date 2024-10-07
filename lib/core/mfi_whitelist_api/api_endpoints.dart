import 'package:mfi_whitelist_admin_portal/ui/shared/sessionmanagement/getuserinfo/getuserinfo.dart';

class MFIApiEndpoints {
  static const String _url = 'https://dev-api-janus.fortress-asya.com:18021/api/public/v1';
  static String getURL() {
    return _url;
  }

  //LOGIN and LOGOUT
  static const String login = "$_url/login/test";
  static const String verifyOTPCode = "$_url/user/test/confirmcode";
  static String logout = '$_url/user/test/logout?hcisId=${getUId()}';

  //DASHBOARD ACCESS
  static const String getDashboardMenu = "$_url/dashboard/test/fetch/all";
  static const String getDashboardCardValues = "$_url/dashboard/test/fetch/all";

  //ROLE MANAGEMENT
  static const String getALLRoles = "$_url/role/test/fetch/all";
  static String getRoleAccessByTitle(String roleTitle) {
    return '$_url/role/test/access/$roleTitle';
  }

  static String switchRoleStatusByID(int roleId) {
    return '$_url/role/test/update/status/$roleId';
  }

  //USER MANAGEMENT
  static const String getAllUsers = "$_url/user/test/fetch/all";
  static const String addNewUser = "$_url/user/test/register";
  static String updateAUser(int userId) {
    return '$_url/user/test/update/user/$userId';
  }

  static String getSingleUserByID(int userId) {
    return '$_url/user/test/user/$userId';
  }

  static String getUserProfile(String hcis) {
    return '$_url/user/hcis/$hcis';
  }

  static String switchUserStatus(int id) {
    return '$_url/user/test/update/user/status/$id';
  }

  //PASSWORD RESET
  static const String checkEmail = "$_url/credentials/test/send/reset";
  static const String changePasswordByAdmin = "$_url/credentials/test/admin/reset/user";
  static const String changePasswordByUser = "$_url/user/test/change/password/inside";
  static const String changePasswordByEmail = "$_url/user/test/change/password/outside";

  //AUDIT LOGS
  static const String getAllLogs = "$_url/audit/test/get/all/logs";
  static const String downloadAuditLogs = "$_url/audit/test/download/audit/logs";

  //MFI TOP UP
  static const String mfiInquireClient = '$_url/topup/test/inquire';
  static const String mfiTopUpClient = '$_url/topup/test/request';
  static const String mfiPreviewBatchTopUp = '$_url/topup/test/preview';
  static const String mfiBatchTopUpRequest = '$_url/topup/test/batch/request';

  //MFI DISBURSE
  static const String mfiPreviewBatchDisburse = '$_url/loan/test/disbursement/preview';
  static const String mfiBatchDisburseRequest = '$_url/loan/test/batch/disbursement';

  //CLIENT
  static const String mfiGetSingleClient = '$_url/client/test/get/single';
}
