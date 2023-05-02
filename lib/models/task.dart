class TaskField{
  static const createdTime = 'CreatedTime';
}

class Tasks {
  String id;
  final String dueDate;
  final String title;
  final String desc;
  final List<dynamic> assignees;
  bool isCompleted;
  String createdTime;
  final int priority;

  Tasks({
    required this.createdTime,
    required this.id,
    required this.dueDate,
    required this.title,
    required this.desc,
    required this.assignees,
    required this.isCompleted,
    required this.priority,
  });
}

// Tasks task = Tasks(
//   createdTime: DateTime.now().toString(),
//   id: "12",
//   dueDate: "2023-05-01",
//   title: "Complete this task right now",
//   desc: "Lorem ipsum dolor sit amet",
//   assignees: ["Dip", "Palash"],
//   isCompleted: false,
// );
