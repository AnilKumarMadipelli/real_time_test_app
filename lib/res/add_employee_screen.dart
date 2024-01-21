import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_time_test_app/res/widgets/calendar_widget.dart';

import '../Utils/color.dart';
import '../src/model/emplyee_model.dart';
import '../src/operations/employee_cubit.dart';

class AddEmployeeScreen extends StatefulWidget {
  final EmployeeCubit employeeCubit;

  const AddEmployeeScreen({super.key, required this.employeeCubit});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController roleController =
      TextEditingController(text: 'Select role');
  final _formKey = GlobalKey<FormState>();

  final TextEditingController todayController = TextEditingController(text: 'Today');
  final TextEditingController noDateController = TextEditingController(text: "No date");

  List<String> dropdownItems = [
    'Product Designer',
    'Flutter Developer',
    'QA Tester',
    'Product owner'
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Employee Details"),
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                controller: nameController,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "Employee name can't empty";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: 'Employee name',

                    hintStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: border),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        )),
                    contentPadding: const EdgeInsets.symmetric(vertical: 13.0),
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: primary,
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: border),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ))),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: border)),
                      child: InkWell(
                        onTap: () {
                          FocusManager.instance.primaryFocus!.unfocus();

                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                height: height * 0.3,
                                child: Center(
                                  child: ListView(
                                    // Use ListView to display multiple Slidables
                                    children: dropdownItems.map((personone) {
                                      return Center(
                                        child: Column(
                                          children: [
                                            ListTile(
                                              onTap: () {
                                                roleController.text = personone;
                                                print(personone);
                                                Navigator.of(context)
                                                    .pop(personone);
                                              },
                                              title:
                                                  Center(child: Text(personone)),
                                            ),
                                            const Divider(
                                              height: 0.1,
                                              thickness: 0.2,
                                            )
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ).whenComplete(() {
                            setState(() {});
                          });
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Row(children: [
                          const SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.work_outline,
                            color: primary,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text(roleController.text.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              )),
                          const Spacer(),
                          Icon(
                            Icons.arrow_drop_down,
                            color: primary,
                          ),
                        ]),
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(
                height: 9,
              ),
              Row(
                children: [
                  Expanded(
                      child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: border)),
                    child: InkWell(
                      onTap: () {
                        FocusManager.instance.primaryFocus!.unfocus();

                        showDialog(
                          context: context,
                          useSafeArea: true,
                          builder: (BuildContext context) {
                            return Dialog(
backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40))),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40)
                                ),
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 1.6,
                                  child: CalendarWidget()),
                            );
                          },
                        ).then((value) {
                          if(value != null) {
                            todayController.text = value;
                            setState(() {});
                          }else{

                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Row(children: [
                        const SizedBox(
                          width: 5,
                        ),

                        Icon(
                          Icons.event_outlined,
                          color: primary,
                        ),
                        SizedBox(width: 10,),
                        Text(todayController.text,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ))
                      ]),
                    ),
                  )),
                  SizedBox(
                    height: 70,
                    width: 50,
                    child: Icon(Icons.arrow_right_alt_rounded, color: primary),
                  ),
                  Expanded(
                      child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: border)),
                    child: InkWell(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();

                        showDialog(
                          context: context,
                          useSafeArea: true,
                          builder: (BuildContext context) {
                            return Dialog(
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40)
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                  MediaQuery.of(context).size.height / 1.6,
                                  child: CalendarWidget()),
                            );
                          },
                        ).then((value) {
                          if(value != null) {
                            noDateController.text = value;
                            setState(() {});
                          }else{

                          }
                        });
                      },

                      borderRadius: BorderRadius.circular(10),
                      child: Row(children: [
                        const SizedBox(
                          width: 5,
                        ),

                        Icon(
                          Icons.event_outlined,
                          color: primary,
                        ),
                        SizedBox(width: 10,),
                        Text(noDateController.text.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ))
                      ]),
                    ),
                  ))
                ],
              ),
              const Spacer(),
              const Divider(height: 0.7, thickness: 0.4),
              Row(
                children: [
                  SizedBox(
                    width: width * 0.45,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel",
                          style: TextStyle(
                            fontSize: 14,
                            color: primary,
                            fontWeight: FontWeight.w500,
                          ))),
                  const Spacer(),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 1,
                        backgroundColor: primary,
                        side: const BorderSide(
                          width: 2,
                          color: Colors.blue,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {

                        if (_formKey.currentState!.validate()) {
                          final Employee newEmployee = Employee(
                              name: nameController.text,
                              role: roleController.text,
                              today: todayController.text,
                              noDate: noDateController.text == "No date"?"empty":noDateController.text,
                              slno: DateTime
                                  .now()
                                  .millisecondsSinceEpoch);
                          widget.employeeCubit.insertEmployee(newEmployee);
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text("Save",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ))),
                  const Spacer()
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
