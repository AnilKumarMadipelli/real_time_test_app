import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/employee_repository.dart';
import '../model/emplyee_model.dart';

part 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final EmployeeRepository repository;

  final _employeesController = StreamController<List<Employee>>();
  Stream<List<Employee>> get employeesStream => _employeesController.stream;


  EmployeeCubit(this.repository) : super(EmployeeInitialState());

  void getAllEmployees() async {
    try {
      final List<Employee> employees = await repository.getAllEmployees();

      emit(EmployeeLoadSuccessState(employees));
      _employeesController.add(employees);
    } catch (e) {
      emit(const EmployeeErrorState("Error loading employees"));
    }
  }

  void emitUpdatedEmployees() async {
    final List<Employee> updatedEmployees = await repository.getAllEmployees();

    _employeesController.add(updatedEmployees);
  }

  void insertEmployee(Employee employee) async {
    try {
      await repository.insertEmployee(employee);
      emitUpdatedEmployees();
    } catch (e) {
      emit(const EmployeeErrorState("Error inserting employee"));
    }
  }

  void updateEmployee(Employee employee) async {
    try {
      await repository.updateEmployee(employee);
      emitUpdatedEmployees();
    } catch (e) {
      emit(const EmployeeErrorState("Error updating employee"));
    }
  }

  void deleteEmployee(int id) async {
    try {
      await repository.deleteEmployee(id);
      emitUpdatedEmployees();
    } catch (e) {
      emit(const EmployeeErrorState("Error deleting employee"));
    }
  }

  void closes() {
    _employeesController.close();
    super.close();
  }

}
