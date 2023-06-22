import 'package:openral_boot_sequence/src/model/firebase_connector_ral_object.dart';
import 'package:openral_boot_sequence/src/open_ral_boot_sequence.dart';
import 'package:test/test.dart';

import 'mock_data.dart';

void main() {
  group(
    OpenRalBootSequence,
    () {
      test(
        'full boot sequence',
        () async {
          OpenRalBootSequence openRalBootSequence = OpenRalBootSequence(
            localFilePath: 'test/assets/ral_object.json',
            localTopNoteRalType: 'pc_instance',
            remoteTopNoteRalType: 'farm',
          );

          final bootResult = await openRalBootSequence.start(
            createLocalRalRepository: (String localDatabaseConnection) async {
              return MockDataLocal.getMockRalRepository();
            },
            createRemoteRalRepository: (FirebaseConnectorSpecificProperties firebaseConnectionProperties) async {
              return MockDataRemote.getMockRalRepository();
            },
          );

          //downstream discovery

          expect(
            bootResult.localTopNode.toTreeString().trim(),
            '''
me_pc
  mqtt_id
    mqtt_child
  firebaseConnectionUID
'''
                .trim(),
          );

          expect(
            bootResult.remoteTopNode!.toTreeString().trim(),
            '''
farm_id
  me_pc
    mqtt_id
      mqtt_child
    firebaseConnectionUID
'''
                .trim(),
          );
        },
      );
    },
  );
}
