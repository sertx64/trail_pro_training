import 'package:trailpro_planning/data/gsheets_api.dart';
import 'package:trailpro_planning/domain/management.dart';

class Samples {

  void createSamplesSplitList() async {
    List<String>? samplesList = await ApiGSheet().getSamples();
    Management.samplesList = samplesList!;
    List<List<String>> samplessplitlist = [];

    for (var i = 0; i < samplesList.length; i += 2) {
      samplessplitlist.add(
          samplesList.sublist(i, i + 2 > samplesList.length ? samplesList.length : i + 2));
    }

    Management.samplesSlitList = samplessplitlist;
  }

}