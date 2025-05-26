class AppUrl{
  /// Live Url////
  //static var baseUrl='https://intrasense.co.uk/app/api/';

  /// Dev Url///
  static var baseUrl='https://dev.intrasense.co.uk/app/api/';

  static var imageUrl='https://intrasense.co.uk/app/';
  static var loginUrl= baseUrl + 'common/login';
  static var forgotPasswordUrl= baseUrl + 'common/forgetPassword';
  static var forgotPasswordVerifyOtpUrl= baseUrl + 'common/forgetPassword/otpverify';
  static var forgotNewPasswordUrl= baseUrl + 'common/forgetPassword/newpassword';

  static var countryListUrl= baseUrl + 'common/countryList';
  static var industryListUrl= baseUrl + 'common/industryList';
  static var timeZoneListUrl= baseUrl + 'meeting/timezoneList';

  static var clientListUrl= baseUrl + 'client/addClient/getCompanies';
  static var subClientListUrl= baseUrl + 'client/addsubCompany/getsubCompanies';
  static var contactListUrl= baseUrl + 'client/contactList';
  static var addClientListUrl= baseUrl + 'client/addClient';
  static var addContactUrl= baseUrl + 'client/addCompanyContact';
  static var addSubClientUrl= baseUrl + 'client/addsubCompany';
  static var deleteClientUrl= baseUrl + 'client/deleteClient';
  static var deleteSubClientUrl= baseUrl + 'client/deleteSubClient';
  static var deleteClientContactUrl= baseUrl + 'client/deleteClientContact';
  static var editClientUrl= baseUrl + 'client/editcompany';

  static var getUserProfileUrl= baseUrl + 'setting/profile';
  static var updateProfileUrl= baseUrl + 'setting/profile/profileUpdate';
  static var updatePasswordUrl= baseUrl + 'setting/changePassword/';
  static var updatePreferencesUrl= baseUrl + 'setting/preferences/';
  static var getPreferencesUrl= baseUrl + 'setting/preferences/getpreference';
  static var getNotificationsListUrl= baseUrl + 'notification/myNotification';
  static var notificationDeleteUrl= baseUrl + 'notification/deleteNotification';

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
  static var updateProjectUrl = baseUrl + 'projects/updateProject';
  static var addProjectQuotationUrl = baseUrl + 'projects/generateQuotes';
  static var projectListUrl = baseUrl + 'projects/projectList';
  static var projectDeleteUrl = baseUrl + 'projects/projectDelete';
  static var getProjectDetailUrl = baseUrl + 'projects/projectDetail';

  ////for tasks
  static var taskListUrl= baseUrl + 'mytask/myTask';
  static var addTaskUrl= baseUrl + 'mytask/createTask';
  static var deleteTaskUrl= baseUrl + 'mytask/taskDelete';
  static var taskDetailsUrl= baseUrl + 'mytask/taskDetail';

  ////for leaves
  static var leaveListUrl= baseUrl + 'leaves/myleaves';
  static var leaveTypeListUrl= baseUrl + 'leaves/LeaveTypeList';
  static var applyLeaveUrl= baseUrl + 'leaves/applyLeave';
  static var leaveRequestListUrl= baseUrl + 'leaves/leaveRequest';
  static var acceptDeclineLeaveUrl= baseUrl + 'leaves/leaveAcceptDecline';
  static var deleteLeaveUrl= baseUrl + 'leaves/cancelLeave';

  ////for time sheet
  static var timeSheetActivityUrl= baseUrl + 'timesheet/timeSheetActivityList';
  static var addTimeSheetUrl= baseUrl + 'timesheet/createTimesheet';
  //static var timeSheetListUrl= baseUrl + 'timesheet/timesheet';
  static var timeSheetListUrl= baseUrl + 'timesheet/timesheetmob';

  ////for expenses
  static var expenseListUrl= baseUrl + 'expenses/expenseList';
  static var addExpenseUrl= baseUrl + 'expenses/addExpense';
  static var deleteExpenseUrl= baseUrl + 'expenses/deleteExpense';
  static var approveExpenseUrl= baseUrl + 'expenses/ApproveExpense';
  static var paidExpenseUrl= baseUrl + 'expenses/paidExpense';

 //// for tickets....
  static var ticketListUrl= baseUrl + 'support/generateTicket/ticketlist';
  static var addTicketUrl= baseUrl + 'support/generateTicket/';
  static var addTicketCommentUrl= baseUrl + 'support/generateTicket/ticketresponse';
  static var ticketDetailUrl= baseUrl + 'support/generateTicket/ticketdetailMobVer';
  static var updateTicketStatusUrl= baseUrl + 'support/generateTicket/updateticketstatus';

///for meetings
  static var meetingListUrl = baseUrl + 'meeting/meetingList';
  static var meetingDetailUrl = baseUrl + 'meeting/meetingDetail';
  static var meetingGroupListUrl = baseUrl + 'meeting/groupList';
  static var addMeetingUrl = baseUrl + 'meeting/createMeeting';
  static var meetingRevertUrl = baseUrl + 'meeting/meetingRevert';
  static var meetingCancelUrl = baseUrl + 'meeting/cancelMeeting';

  ////for team
  static var addEmployeeUrl= baseUrl + 'employees/addEmployee';
  static var getmployeeDetailUrl= baseUrl + 'employees/employeeDetail';
  static var commonImageUploadUrl= baseUrl + 'common/images';
  static var teamDeleteUrl= baseUrl + 'employees/deleteEmployee';

  ///for events
  static var eventListUrl = baseUrl + 'events/addEvent/getevents';
  static var addEventUrl = baseUrl + 'events/addEvent';
  static var eventRevertUrl = baseUrl + 'events/eventRevert';
  static var eventDetailUrl = baseUrl + 'events/eventDetailSortByUSer';

  ///for appraisal
  static var appraisalListUrl = baseUrl + 'appraisal/myAppraisalsList';
  static var appraisalDetailUrl = baseUrl + 'appraisal/Appraisal_detail';
  static var appraisalRequestListUrl = baseUrl + 'appraisal/appraisalRequestedList';
  static var createAppraisalUrl = baseUrl + 'appraisal/create_appraisal_request';
  static var appraisalPMRevertUrl = baseUrl + 'appraisal/appraisalRevertByPM';


  static var myFilesListUrl = baseUrl + 'dms/myFolders';
  static var sharedWithMeFileListUrl = baseUrl + 'dms/fileSharedWithMe';
  static var createFolderUrl = baseUrl + 'dms/createFolder';
  static var fileDetailUrl = baseUrl + 'dms/GetFileDetailsMobile';

  static var uploadFileUrl = baseUrl + 'dms/uploadFile';

}