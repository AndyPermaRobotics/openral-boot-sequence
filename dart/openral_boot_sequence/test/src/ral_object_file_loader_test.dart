import 'package:openral_boot_sequence/src/ral_object_file_loader.dart';
import 'package:test/test.dart';

void main() {
  group(
    RalObjectFileLoader,
    () {
      test(
        'loads a SoftwareComponentRalObject from a file',
        () async {
          final ralObject = RalObjectFileLoader.load('test/assets/ral_object.json');
          expect(ralObject, isNotNull);

          expect(ralObject.template.ralType, 'thing');
          expect(ralObject.identity.uid, 'me');
        },
      );
    },
  );
}
