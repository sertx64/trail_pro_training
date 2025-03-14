import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailpro_planning/domain/samples_cubit.dart';

class AddSamplesScreen extends StatelessWidget {
  const AddSamplesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddSamplesCubit()..loadSamples(),
      child: BlocBuilder<AddSamplesCubit, AddSamplesModel>(
          builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: const Text(
                  style: TextStyle(fontSize: 30, color: Colors.white), 'Шаблоны'),
              backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
          body: (!state.isLoading)
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Color.fromRGBO(255, 132, 26, 1),
                  strokeWidth: 3,
                ))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    itemCount: state.samplesSplit.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 2),
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(state.samplesSplit[index][0]),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                      color: Color.fromRGBO(255, 132, 26, 1),
                                      Icons.edit)),
                              IconButton(
                                  onPressed: () {
                                    _showModalAddSample(
                                        context,
                                        state.samplesSplit[index][0],
                                        state.samplesSplit[index][1]);
                                  },
                                  icon: const Icon(
                                      color: Color.fromRGBO(255, 132, 26, 1),
                                      Icons.copy)),
                              IconButton(
                                  onPressed: () {
                                    _showDeleteModal(context, index);
                                  },
                                  icon: const Icon(
                                      color: Color.fromRGBO(255, 132, 26, 1),
                                      Icons.delete)),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color.fromRGBO(1, 57, 104, 1),
            onPressed: () {
              _showModalAddSample(context, '', '');
            },
            child: const Icon(color: Colors.white, Icons.add),
          ),
        );
      }),
    );
  }

  void _showModalAddSample(BuildContext context, String label, String description) {
    final addSamplesCubit = context.read<AddSamplesCubit>();
    final List<String> labelControl = addSamplesCubit.samples;
    final TextEditingController controllerLabelTraining =
    TextEditingController(text: label);
    final TextEditingController controllerDescriptionTraining =
    TextEditingController(text: description);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: addSamplesCubit,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('Название'),
                TextField(
                  maxLength: 27,
                  decoration: const InputDecoration(
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                  ),
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(1, 57, 104, 1),
                      fontSize: 16),
                  controller: controllerLabelTraining,
                ),
                const SizedBox(height: 8),
                const Text('Описание'),
                TextField(
                  maxLines: 5,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                  ),
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(1, 57, 104, 1),
                      fontSize: 16),
                  controller: controllerDescriptionTraining,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(1, 57, 104, 1)),
                    onPressed: () {
                      if (!labelControl
                          .contains(controllerLabelTraining.text.trim()) && !labelControl
                          .contains(controllerDescriptionTraining.text.trim()) &&
                          controllerLabelTraining.text.trim() != '' &&
                          controllerDescriptionTraining.text.trim() != '') {
                        addSamplesCubit.addSample(controllerLabelTraining.text.trim(),
                            controllerDescriptionTraining.text.trim());
                        controllerLabelTraining.clear();
                        controllerDescriptionTraining.clear();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                        style: TextStyle(fontSize: 24, color: Colors.white),
                        'Добавить')),
              ]),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteModal(BuildContext context, int index) {
    final addSamplesCubit = context.read<AddSamplesCubit>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Builder(builder: (context) {
          return BlocProvider.value(
            value: addSamplesCubit,
            child: AlertDialog(
              title: const Text('Удалить шаблон?'),
              content: const Text('Шаблон будет удалён без возвратно.'),
              actions: [
                TextButton(
                  onPressed: () {
                    addSamplesCubit.deleteSample(index);
                    Navigator.of(context).pop();
                  },
                  child: const Center(
                      child: Text(
                          style: TextStyle(color: Colors.red),
                          'Да, продолжить')),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Center(
                      child: Text(
                          style: TextStyle(color: Colors.black),
                          'Нет, я передумал')),
                ),
              ],
            ),
          );
        });
      },
    );
  }

}
