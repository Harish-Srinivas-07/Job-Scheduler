import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

class AddTaskScreen extends StatefulWidget {
  final Map<String, dynamic>? task;

  AddTaskScreen({this.task});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _startTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?['title'] as String?);
    _descriptionController = TextEditingController(text: widget.task?['description'] as String?);
    _startTime = widget.task?['startTime'] as String? ?? DateFormat('dd MMM yyyy : hh:mm a').format(DateTime.now());
  }


  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Task',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[600],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          // color: Colors.blue[50], // Pale blue background color for the page
          child: Card(
            color: Colors.white.withOpacity(0.9), // Translucent white card
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Kindly provide task details to assign ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Job Title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0), // Add padding vertically
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$_startTime',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.red, // Dark blue text color
                          ),
                        ),
                        SizedBox(width: 20), // Right side spacing for the button
                        ElevatedButton(
                          onPressed: () {
                            if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Task Assign Error !',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: Text('Please provide valid title and description to proceed.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Understood'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              final newTask = {
                                'title': _titleController.text,
                                'description': _descriptionController.text,
                                'startTime': _startTime,
                                'completed': widget.task?['completed'] ?? false,
                              };

                              Navigator.of(context).pop(newTask);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              'Confirm',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 40),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

}
