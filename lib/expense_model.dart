class Expense {
  final int id;
  final String title;
  final String amount;
  final String category;
  final String date;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      title: json['title'],
      amount: json['amount'].toString(),
      category: json['category'],
      date: json['date'],
    );
  }
}