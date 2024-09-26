class AppUrl{
  static var baseUrl='https://intrasense.co.uk/app/api/';
  static var loginUrl= baseUrl + 'common/login';
  static var countryListUrl= baseUrl + 'common/countryList';
  static var clientListUrl= baseUrl + 'client/addClient/getCompanies';
  static var subClientListUrl= baseUrl + 'client/addsubCompany/getsubCompanies';
  static var contactListUrl= baseUrl + 'client/contactList';
  static var addClientListUrl= baseUrl + 'client/addClient';
  static var addContactUrl= baseUrl + 'client/addCompanyContact';
  static var industryListUrl= baseUrl + 'common/industryList';
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
}