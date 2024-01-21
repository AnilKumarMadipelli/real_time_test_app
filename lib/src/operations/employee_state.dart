part of 'employee_cubit.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object?> get props => [];
}

class EmployeeInitialState extends EmployeeState {}

class EmployeeLoadSuccessState extends EmployeeState {
  final List<Employee> employees;

  const EmployeeLoadSuccessState(this.employees);

  @override
  List<Object?> get props => [employees];
}

class EmployeeNewState extends EmployeeState {
  final bool newState =true;
}

class EmployeeUpdateState extends EmployeeState {
  final bool update =true;
}

class EmployeeDeleteState extends EmployeeState {
  final bool delete =true;
}



class EmployeeErrorState extends EmployeeState {
  final String error;

  const EmployeeErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
