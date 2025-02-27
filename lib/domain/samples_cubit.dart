import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trailpro_planning/data/gsheets_api.dart';
import 'package:trailpro_planning/domain/management.dart';


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
    Management.samplesSlitList = samplesSplit;
    final AddSamplesModel newSamples = AddSamplesModel(samplesSplit, true);
    emit(newSamples);
    samples.add(label);
    samples.add(description);
    ApiGSheet().sendSamplesList(samples);
  }

  void deleteSample(int index) async {
    List<List<String>> samplesSplit = state.samplesSplit;
    samples.remove(samplesSplit[index][0]);
    samples.remove(samplesSplit[index][1]);
    samples.add('');
    samples.add('');
    samplesSplit.removeAt(index);
    Management.samplesSlitList = samplesSplit;
    final AddSamplesModel newSamples = AddSamplesModel(samplesSplit, true);
    emit(newSamples);
    ApiGSheet().sendSamplesList(samples);
  }


}

class AddSamplesModel {
  List<List<String>> samplesSplit;
  bool isLoading;
  AddSamplesModel(this.samplesSplit, this.isLoading);
}
