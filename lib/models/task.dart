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
  title: "Complete this task right now",
  desc: "Lorem ipsum dolor sit amet",
  assignees: ["Dip", "Palash"],
  assigneeProfilePictures: [
    "https://upload.wikimedia.org/wikipedia/commons/thumb/3/34/Elon_Musk_Royal_Society_%28crop2%29.jpg/1200px-Elon_Musk_Royal_Society_%28crop2%29.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/3/34/Elon_Musk_Royal_Society_%28crop2%29.jpg/1200px-Elon_Musk_Royal_Society_%28crop2%29.jpg",
  ],
);
