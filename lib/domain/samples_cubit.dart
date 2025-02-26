import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailpro_planning/data/gsheets_api.dart';


class AddSamplesCubit extends Cubit<AddSamplesModel> {
  AddSamplesCubit() : super(AddSamplesModel([], false));

  List<String> samples = [];

  void loadSamples() async {

    samples = (await ApiGSheet().getSamples())!;

    List<List<String>> samplesSplit = [];

    for (var i = 0; i < samples.length; i += 2) {
      samplesSplit.add(
          samples.sublist(i, i + 2 > samples.length ? samples.length : i + 2));
    }

    final AddSamplesModel newSamples = AddSamplesModel(samplesSplit, true);
    emit(newSamples);
  }


  void addSample(String label, String description) {
    List<List<String>> samplesSplit = state.samplesSplit;
    List<String> newSample = [label, description];
    samplesSplit.add(newSample);
    final AddSamplesModel newSamples = AddSamplesModel(samplesSplit, true);
    emit(newSamples);
    samples.add(label);
    samples.add(description);
    ApiGSheet().sendSamplesList(samples);
  }

  void deleteSample(String label, String description, int index) async {
    List<List<String>> samplesSplit = state.samplesSplit;
    samplesSplit.removeAt(index);
    final AddSamplesModel newSamples = AddSamplesModel(samplesSplit, true);
    emit(newSamples);
    samples.remove(label);
    samples.remove(description);
    samples.add('');
    samples.add('');
    ApiGSheet().sendSamplesList(samples);
  }


}

class AddSamplesModel {
  List<List<String>> samplesSplit;
  bool isLoading;
  AddSamplesModel(this.samplesSplit, this.isLoading);
}
