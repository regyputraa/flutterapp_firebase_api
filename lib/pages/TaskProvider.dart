import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskProvider extends ChangeNotifier {
  List<String> tasks = [];

  TaskProvider(List<String> initialTasks) {
    tasks = initialTasks;
  }

  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tasks = prefs.getStringList('tasks') ?? [];
    notifyListeners();
  }

  Future<void> saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('tasks', tasks);
  }

  void addTask(String task) {
    tasks.add(task);
    saveTasks();
    notifyListeners();
  }

  void removeTask(int index) {
    if (index >= 0 && index < tasks.length) {
      tasks.removeAt(index);
      saveTasks();
      notifyListeners();
    }
  }

  void updateTask(int index, String updatedTask) {
    if (index >= 0 && index < tasks.length) {
      tasks[index] = updatedTask;
      saveTasks();
      notifyListeners();
    }
  }
}
