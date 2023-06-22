import 'package:openral_flutter/model/specific_properties.dart';

class SoftwareComponentSpecificProperties extends SpecificProperties {
  SoftwareComponentSpecificProperties(super.specificProperties);

  String? get localDatabaseConnection => this['localDatabaseConnection'];

  String? get remoteDatabaseConnectionUID => this['remoteDatabaseConnectionUID'];

  //TODO: Parse this into a list of DiscoveryStrategies
  List<dynamic>? get discoveryStrategies => this['discoveryStrategies'];
}
