// class Task {
//   final String taskId;
//   final String desc;
//   final String duedate;
//   final List<dynamic> assigne;

//   Task({
//     required this.desc,
//     required this.duedate,
//     required this.assigne,
//     required this.taskId,
//   });
// }


class Task {
  String dueDate;
  String title;
  String desc;
  List<String> assignees;
  List<String> assigneeProfilePictures;
  bool isCompleted;

  Task({
    required this.dueDate,
    required this.title,
    required this.desc,
    required this.assignees,
    required this.assigneeProfilePictures,
    this.isCompleted = false,
  });
}

Task task = Task(
  dueDate: "2023-05-01",
  title: "Complete Task",
  desc: "Lorem ipsum dolor sit amet",
  assignees: ["John Doe", "Jane Smith"],
  assigneeProfilePictures: [
    "https://example.com/profile-pictures/john-doe.jpg",
    "https://example.com/profile-pictures/jane-smith.jpg",
  ],
);
