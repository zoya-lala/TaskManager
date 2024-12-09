import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  final Map<String, String>? taskToEdit;

  AddTask({this.taskToEdit});
  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  String status = 'Pending';
  void initState() {
    super.initState();
    if (widget.taskToEdit != null) {
      titleController.text = widget.taskToEdit!['title']!;
      descController.text = widget.taskToEdit!['description']!;
      status = widget.taskToEdit!['status']!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.0,
                    ),
                  ),
                  labelText: 'Task Title',
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.0,
                    ),
                  ),
                  labelText: 'Task Description',
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              DropdownButton<String>(
                value: status,
                // style: TextStyle(
                //   color: Colors.black,
                // ),
                items: <String>['Pending', 'In progress', 'Completed']
                    .map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    status = value!;
                  });
                },
              ),
              SizedBox(
                height: 30.0,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Colors.blue,
                  ),
                  foregroundColor: MaterialStatePropertyAll(
                    Colors.white,
                  ),
                ),
                onPressed: () {
                  final task = {
                    'title': titleController.text,
                    'description': descController.text,
                    'status': status,
                  };

                  Navigator.pop(context, task);
                },
                child: Text(
                  'Add Task',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
