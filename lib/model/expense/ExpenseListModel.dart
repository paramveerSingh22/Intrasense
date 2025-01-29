class ExpenseListModel {
  final String expenseId;
  final String userId;
  final String usrRoleTrackId;
  final String expenseTitle;
  final DateTime? expenseForDate;  // Nullable DateTime
  final String expenseCategory;
  final String expenseReceipt;
  final double amount;
  final String expenseDescription;
  final DateTime createdOn;
  final String status;
  final String usrName;

  // Constructor
  ExpenseListModel({
    required this.expenseId,
    required this.userId,
    required this.usrRoleTrackId,
    required this.expenseTitle,
    this.expenseForDate,  // Nullable DateTime
    required this.expenseCategory,
    required this.expenseReceipt,
    required this.amount,
    required this.expenseDescription,
    required this.createdOn,
    required this.status,
    required this.usrName,
  });

  // Factory method to create an Expense instance from JSON
  factory ExpenseListModel.fromJson(Map<String, dynamic> json) {
    return ExpenseListModel(
      expenseId: json['expense_id'] ?? '0',  // Default value if null
      userId: json['user_id'] ?? '0',  // Default value if null
      usrRoleTrackId: json['usr_role_track_id'] ?? '0',  // Default value if null
      expenseTitle: json['expense_title'] ?? 'No Title',  // Default value if null
      expenseForDate: json['expense_forDate'] != null
          ? DateTime.tryParse(json['expense_forDate']) ?? DateTime.now()  // Fallback if invalid date
          : null,
      expenseCategory: json['expense_category'] ?? 'Uncategorized',  // Default value if null
      expenseReceipt: json['expense_receipt'] ?? 'No receipt',  // Default value if null
      amount: json['amount'] != null ? double.tryParse(json['amount'].toString()) ?? 0.0 : 0.0,  // Default value if null or invalid
      expenseDescription: json['expense_description'] ?? 'No description',  // Default value if null
      createdOn: DateTime.tryParse(json['createdOn']) ?? DateTime.now(),  // Fallback if invalid date
      status: json['status'] ?? 'Unknown',  // Default value if null
      usrName: json['usr_name'] ?? 'Unknown',  // Default value if null
    );
  }
}