import 'package:openral_boot_sequence/src/software_component_ral_object_file_loader.dart';
import 'package:openral_flutter/discovery/discovery_dimension.dart';
import 'package:test/test.dart';

void main() {
  group(
    SoftwareComponentRalObjectFileLoader,
    () {
      test(
        'loads a SoftwareComponentRalObject from a file',
        () async {
          final ralObject = SoftwareComponentRalObjectFileLoader.load('test/assets/ral_object.json');
          expect(ralObject, isNotNull);

          expect(ralObject.template.ralType, 'thing');
          expect(ralObject.identity.uid, 'me');

          expect(ralObject.specificProperties.localDatabaseConnection,
              'mongodb://localhost:27017/mydb?readPreference=primary&appname=permaroboticsApp&directConnection=true&ssl=false');

          expect(ralObject.specificProperties.remoteDatabaseConnectionUID, 'firebaseConnectionUID');

          expect(
            ralObject.specificProperties.discoveryDimensions!.toSet(),
            {DiscoveryDimension.containerId, DiscoveryDimension.linkedObjectRef, DiscoveryDimension.owner},
            reason: "DiscoveryDimensions should be equal",
          );
        },
      );
    },
  );
}
