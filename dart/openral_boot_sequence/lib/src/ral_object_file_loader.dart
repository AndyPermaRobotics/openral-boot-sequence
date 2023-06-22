import 'dart:convert';
import 'dart:io';

import 'package:openral_boot_sequence/src/model/software_component_ral_object.dart';
import 'package:openral_boot_sequence/src/model/software_component_specific_properties.dart';
import 'package:openral_flutter/model/ral_object.dart';
import 'package:openral_flutter/model/specific_properties.dart';

///provides functionality for loading a [RalObject] from a file
class RalObjectFileLoader {
  ///loads a [RalObject] from a file
  static SoftwareComponentRalObject load<S extends SpecificProperties>(String path) {
    // read the contents of the file
    String jsonString = File(path).readAsStringSync();

    // parse the JSON string to a Map
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    // create a RalObject from the Map
    final parsingResult = RalObject.fromMap<SoftwareComponentSpecificProperties>(
      jsonMap,
      specificPropertiesTransform: (SpecificProperties specificProperties) => SoftwareComponentSpecificProperties(specificProperties.map),
    );

    if (parsingResult.isRight) {
      throw Exception(parsingResult.right);
    } else {
      return parsingResult.left;
    }
  }
}
