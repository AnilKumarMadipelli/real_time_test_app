import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:real_time_test_app/Utils/color.dart';
import 'package:real_time_test_app/res/update_delete_screen.dart';
import '../Utils/constant.dart';
import '../src/model/emplyee_model.dart';
import '../src/operations/employee_cubit.dart';
import 'add_employee_screen.dart';

class HomeScreen extends StatefulWidget {
  final EmployeeCubit repository;

  const HomeScreen({super.key, required this.repository});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    widget.repository.getAllEmployees();
  }

  List<Employee> currentEmp = [];
  List<Employee> previousEmp = [];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocConsumer<EmployeeCubit, EmployeeState>(
      listener: (context, state) {
        if (state is EmployeeLoadSuccessState) {
          final updatedList = List.of(state.employees);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            BlocProvider.of<EmployeeCubit>(context)
                .emit(EmployeeLoadSuccessState(updatedList));
          });
        }
      },
      builder: (context, state) {
        if (state is EmployeeInitialState) {
          BlocProvider.of<EmployeeCubit>(context).getAllEmployees();
          return const Center(child: CircularProgressIndicator());
        } else if (state is EmployeeLoadSuccessState) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(title: const Text("Employee List")),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AddEmployeeScreen(employeeCubit: widget.repository);
                  }));
                },
                mini: true,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
            body: isLoading == false
                ? RefreshIndicator(
                    onRefresh: () async {
                      try {
                        setState(() {
                          isLoading = true;
                        });
                        widget.repository.emitUpdatedEmployees();
                        Future.delayed(const Duration(seconds: 3));
                        setState(() {
                          isLoading = false;
                        });
                      } catch (e) {
                        log(e.toString());
                      }
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: height,
                            width: width,
                            child: StreamBuilder<List<Employee>>(
                              stream: widget.repository.employeesStream,
                              builder: (context, snapshot) {
                                previousEmp.clear();
                                currentEmp.clear();
                                if (snapshot.hasData) {
                                  snapshot.data!.forEach((element) {
                                    if (element.noDate != "empty") {
                                      previousEmp.add(element);
                                    } else {
                                      currentEmp.add(element);
                                    }
                                  });
                                  return snapshot.data!.isEmpty
                                      ? FittedBox(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: SizedBox(
                                              width: width/0.5,
                                              height: height * 0.5,
                                              child: Image.asset(
                                                  'assets/images/no_employee.png'),
                                            ),
                                        ),
                                      )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              color: backGround,
                                              width: width,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 13.0,
                                                        vertical: 10),
                                                child: Text("Current employees",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: primary,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 3),
                                                child: ListView(
                                                  children: currentEmp
                                                      .map((personone) {
                                                    return Slidable(
                                                      endActionPane: ActionPane(
                                                        motion:
                                                            const ScrollMotion(),
                                                        extentRatio: 0.3,
                                                        children: [
                                                          SlidableAction(
                                                            onPressed:
                                                                (contexts) {
                                                              bool isDelete =
                                                              true;
                                                              final snackBar =
                                                              SnackBar(
                                                                content:
                                                                const Text(
                                                                    delete),
                                                                duration:
                                                                const Duration(
                                                                    seconds:
                                                                    2),
                                                                action:
                                                                SnackBarAction(
                                                                  label: 'Undo',
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                            () {
                                                                          isDelete =
                                                                          false;
                                                                        });
                                                                    // Some code to undo the change.
                                                                  },
                                                                ),
                                                              );
                                                              ScaffoldMessenger
                                                                  .of(
                                                                  context)
                                                                  .showSnackBar(
                                                                  snackBar);
                                                              Future.delayed(
                                                                const Duration(
                                                                    seconds: 2),
                                                                    () {
                                                                  ScaffoldMessenger.of(
                                                                      context)
                                                                      .hideCurrentSnackBar();

                                                                  if (isDelete ==
                                                                      true) {
                                                                    widget
                                                                        .repository
                                                                        .deleteEmployee(
                                                                        personone.slno);
                                                                  } else {
                                                                    ScaffoldMessenger.of(
                                                                        context)
                                                                        .hideCurrentSnackBar();
                                                                  }
                                                                },
                                                              );
                                                              setState(() {});
                                                            },
                                                            backgroundColor:
                                                                const Color(
                                                                    0xFFFE4A49),
                                                            foregroundColor:
                                                                Colors.white,
                                                            icon: Icons.delete,
                                                            autoClose: true,
                                                            label: 'Delete',
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 13.0),
                                                        child: InkWell(
                                                          onTap: ()
                                                          {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) =>
                                                                    UpdateDeleteScreen(
                                                                      employeeCubit:
                                                                      widget
                                                                          .repository,
                                                                      selectedEmployee:
                                                                      personone,
                                                                    ),
                                                              ),
                                                            );

                                                          },
                                                          child: Container(
                                                            width: width,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                    personone.name,
                                                                    style: const TextStyle(
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.w500,
                                                                    )
                                                                ),
                                                                Text(
                                                                    personone.role,
                                                                    style:  TextStyle(
                                                                      fontSize: 14,
                                                                      color: hintText,

                                                                      fontWeight: FontWeight.w400,
                                                                    )
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                        "${personone.today} - ${personone.noDate}",
                                                                        style:  TextStyle(
                                                                          fontSize: 12,
                                                                          color: hintText,

                                                                          fontWeight: FontWeight.w400,
                                                                        )
                                                                    )
                                                                  ],
                                                                ),
                                                                Divider(thickness: 0.1,)
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              color: backGround,
                                              width: width,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 13.0,
                                                        vertical: 10),
                                                child:
                                                    Text("Previous employees",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: primary,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        )),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                color: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 3),
                                                child: ListView(
                                                  children: previousEmp
                                                      .map((personone) {
                                                    return Slidable(
                                                      endActionPane: ActionPane(
                                                        motion:
                                                            const ScrollMotion(),
                                                        extentRatio: 0.3,
                                                        children: [
                                                          SlidableAction(
                                                            onPressed:
                                                                (contexts) {
                                                              bool isDelete =
                                                                  true;
                                                              final snackBar =
                                                                  SnackBar(
                                                                content:
                                                                    const Text(
                                                                        delete),
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            2),
                                                                action:
                                                                    SnackBarAction(
                                                                  label: 'Undo',
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      isDelete =
                                                                          false;
                                                                    });
                                                                    // Some code to undo the change.
                                                                  },
                                                                ),
                                                              );
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      snackBar);
                                                              Future.delayed(
                                                                const Duration(
                                                                    seconds: 2),
                                                                () {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .hideCurrentSnackBar();

                                                                  if (isDelete ==
                                                                      true) {
                                                                    widget
                                                                        .repository
                                                                        .deleteEmployee(
                                                                            personone.slno);
                                                                  } else {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .hideCurrentSnackBar();
                                                                  }
                                                                },
                                                              );
                                                              setState(() {});
                                                            },

                                                            backgroundColor:
                                                                const Color(
                                                                    0xFFFE4A49),
                                                            foregroundColor:
                                                                Colors.white,
                                                            icon: Icons.delete,
                                                            autoClose: true,
                                                            label: 'Delete',
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 13.0),
                                                        child: InkWell(
                                                          onTap: ()
                                                          {
                                                            Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            UpdateDeleteScreen(
                                                                          employeeCubit:
                                                                              widget
                                                                                  .repository,
                                                                          selectedEmployee:
                                                                              personone,
                                                                        ),
                                                                      ),
                                                                    );

                                                          },
                                                          child: Container(
                                                            width: width,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                    personone.name,
                                                                    style: const TextStyle(
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.w500,
                                                                    )
                                                                ),
                                                                Text(
                                                                    personone.role,
                                                                    style:  TextStyle(
                                                                      fontSize: 14,
                                                                      color: hintText,

                                                                      fontWeight: FontWeight.w400,
                                                                    )
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                        "${personone.today} - ${personone.noDate}",
                                                                        style:  TextStyle(
                                                                          fontSize: 12,
                                                                          color: hintText,

                                                                          fontWeight: FontWeight.w400,
                                                                        )
                                                                    )
                                                                  ],
                                                                ),
                                                                Divider(thickness: 0.1,)

                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              color: backGround,
                                              width: width,
                                              child:  Padding(
                                                padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 13.0,
                                                    vertical: 13),
                                                child:
                                                Text(
                                                    "Swipe left to delete",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: hintText,
                                                      fontWeight: FontWeight.w400,
                                                    )
                                                )
                                              ),
                                            ),
SizedBox(height: MediaQuery.of(context).size.height * 0.11,)                                          ],
                                        );
                                } else if (snapshot.hasError) {
                                  return Text("Error: ${snapshot.error}");
                                } else {
                                  return const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                          child:
                                              CircularProgressIndicator()),
                                    ],
                                  );
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
          );
        } else if (state is EmployeeErrorState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Employee List'),
            ),
            body: Text(state.error),
          );
        }
        return Container(); // You can handle more states as needed
      },
    );
  }
}
