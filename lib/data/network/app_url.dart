class AppUrl{
  static var baseUrl='https://intrasense.co.uk/app/api/';
  static var loginUrl= baseUrl + 'common/login';
  static var forgotPasswordUrl= baseUrl + 'common/forgetPassword';
  static var forgotPasswordVerifyOtpUrl= baseUrl + 'common/forgetPassword/otpverify';
  static var forgotNewPasswordUrl= baseUrl + 'common/forgetPassword/newpassword';

  static var countryListUrl= baseUrl + 'common/countryList';
  static var industryListUrl= baseUrl + 'common/industryList';

  static var clientListUrl= baseUrl + 'client/addClient/getCompanies';
  static var subClientListUrl= baseUrl + 'client/addsubCompany/getsubCompanies';
  static var contactListUrl= baseUrl + 'client/contactList';
  static var addClientListUrl= baseUrl + 'client/addClient';
  static var addContactUrl= baseUrl + 'client/addCompanyContact';
  static var addSubClientUrl= baseUrl + 'client/addsubCompany';
  static var deleteClientUrl= baseUrl + 'client/deleteClient';
  static var deleteSubClientUrl= baseUrl + 'client/deleteSubClient';
  static var deleteClientContactUrl= baseUrl + 'client/deleteClientContact';

  ///for roles
  static var roleListUrl= baseUrl + 'roles/roleList';
  static var addRoleUrl= baseUrl + 'roles/createRole';
  static var deleteRoleUrl= baseUrl + 'roles/roleDelete';

  /// for groups
  static var employeesListUrl= baseUrl + 'employees/employeeListing';
  static var addGroupUrl= baseUrl + 'groups/CreateGroup';
  static var groupListUrl= baseUrl + 'groups/groupList';
  static var groupDetailsUrl= baseUrl + 'groups/GroupDetail';
  static var updateGroupUrl= baseUrl + 'groups/GroupUpdate';
  static var deleteGroupUrl= baseUrl + 'groups/GroupDelete';

  ///for Projects
  static var projectManagersListUrl= baseUrl + 'employees/pmList';
  static var projectTypesListUrl = baseUrl + 'projects/projectActivityTypeList';
  static var addProjectUrl = baseUrl + 'projects/createProject';
  static var projectListUrl = baseUrl + 'projects/projectList';

  ////for tasks
  static var taskListUrl= baseUrl + 'mytask/myTask';
  static var addTaskUrl= baseUrl + 'mytask/createTask';
  static var deleteTaskUrl= baseUrl + 'mytask/taskDelete';
  static var taskDetailsUrl= baseUrl + 'mytask/taskDetail';

  ////for leaves
  static var leaveListUrl= baseUrl + 'leaves/myleaves';
  static var leaveTypeListUrl= baseUrl + 'leaves/LeaveTypeList';
  static var applyLeaveUrl= baseUrl + 'leaves/applyLeave';

}