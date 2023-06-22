import 'package:openral_flutter/model/ral_object.dart';
import 'package:openral_flutter/model/specific_properties.dart';

///Extends [SpecificProperties] with getters for the specific properties of a [FirebaseConnectorRalObject]
///Use [FirebaseConnectorSpecificProperties.fromSpecificProperties] to create an instance of this class from a general [SpecificProperties] instance.
class FirebaseConnectorSpecificProperties extends SpecificProperties {
  FirebaseConnectorSpecificProperties(super.specificProperties);

  String? get appId => this['appId'];

  String? get apiKey => this['apiKey'];

  String? get projectId => this['projectId'];

  String? get messagingSenderId => this['messagingSenderId'];

  String? get authDomain => this['authDomain'];

  static FirebaseConnectorSpecificProperties fromSpecificProperties(SpecificProperties specificProperties) =>
      FirebaseConnectorSpecificProperties(specificProperties.map);
}

typedef FirebaseConnectorRalObject = RalObject<FirebaseConnectorSpecificProperties>;
