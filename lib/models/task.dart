class Tasks {
  String id;
  final String dueDate;
  final String title;
  final String desc;
  final List<String> assignees;
  bool isCompleted;

  Tasks({
    required this.id,
    required this.dueDate,
    required this.title,
    required this.desc,
    required this.assignees,
    required this.isCompleted,
  });
}

Tasks task = Tasks(
  id: "12",
  dueDate: "2023-05-01",
  title: "Complete this task right now",
  desc: "Lorem ipsum dolor sit amet",
  assignees: ["Dip", "Palash"],
  isCompleted: false,
);
