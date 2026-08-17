enum ExpenseCategory {
  food(
    "Food",
    "🍔",
  ),
  coffee(
    "Coffee",
    "☕",
  ),
  grocery(
    "Grocery",
    "🛒",
  ),
  transport(
    "Transport",
    "🚗",
  ),
  travel(
    "Travel",
    "✈️",
  ),
  shopping(
    "Shopping",
    "🛍️",
  ),
  entertainment(
    "Entertainment",
    "🎬",
  ),
  health(
    "Health",
    "💊",
  ),
  education(
    "Education",
    "📚",
  ),
  bills(
    "Bills",
    "💡",
  ),
  other(
    "Other",
    "📦",
  );

  final String label;
  final String emoji;

  const ExpenseCategory(
      this.label,
      this.emoji,
      );
}