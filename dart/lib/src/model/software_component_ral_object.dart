import 'package:openral_core/openral_core.dart';

typedef SoftwareComponentRalObject = RalObject<SoftwareComponentSpecificProperties>;

///defines easy access to the specific properties of a [SoftwareComponentRalObject]
class SoftwareComponentSpecificProperties extends SpecificProperties {
  SoftwareComponentSpecificProperties(super.specificProperties);

  ///contains the informations to connect to the local database
  String? get localDatabaseConnection => this['localDatabaseConnection'];

  ///the uid of the RalObject that contains the information about the remote database connection
  ///this RalObject is stored in the local database
  String? get remoteDatabaseConnectionUID => this['remoteDatabaseConnectionUID'];

  ///defines which attributes of the RalObjects are used to build up the discovery graph
  List<DiscoveryDimension>? get discoveryDimensions {
    final discoveryDimensions = this['discoveryDimensions'];
    if (discoveryDimensions == null) {
      return [];
    }
    return discoveryDimensions.map<DiscoveryDimension>((e) => DiscoveryDimension.values.firstWhere((element) => element.name == e)).toList();
  }
}
