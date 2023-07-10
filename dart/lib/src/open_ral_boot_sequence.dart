import 'dart:convert';
import 'dart:io';

import 'package:openral_boot_sequence/src/model/boot_sequence_result.dart';
import 'package:openral_boot_sequence/src/model/firebase_connector_ral_object.dart';
import 'package:openral_boot_sequence/src/model/software_component_ral_object.dart';
import 'package:openral_boot_sequence/src/software_component_ral_object_file_loader.dart';
import 'package:openral_core/openral_core.dart';

///Invoke start() to start the boot sequence.
class OpenRalBootSequence {
  ///the file in which the cached RalObject of this softwareComponent is stored.
  ///This file is read by the [SoftwareComponentRalObjectFileLoader]
  final String localFilePath;

  ///defines the RalType of the top node of the downstream discovery tree.
  final String localTopNoteRalType;

  ///defines the RalType of the top node of the upstream discovery tree.
  final String remoteTopNoteRalType;

  ///if true, the local file will be updated with the latest RalObject from the local database.
  final bool updateLocalFile;

  SoftwareComponentRalObject? _ralObject;

  OpenRalBootSequence({
    required this.localFilePath,
    required this.localTopNoteRalType,
    required this.remoteTopNoteRalType,
    this.updateLocalFile = false,
  });

  Future<BootSequenceResult> start({
    required Future<RalObjectRepository> Function(String localDatabaseConnection) createLocalRalRepository,
    required Future<RalObjectRepository> Function(FirebaseConnectorSpecificProperties firebaseConnectionProperties) createRemoteRalRepository,
  }) async {
    //1. Get own RalObject from local file
    _ralObject = SoftwareComponentRalObjectFileLoader.load(localFilePath);

    if (_ralObject == null) {
      throw Exception('No RalObject found in local file.');
    }

    //2. What can I do? / Downstream Discovery
    final databaseConnectionStr = _ralObject!.specificProperties.localDatabaseConnection;

    if (databaseConnectionStr == null) {
      throw Exception('No local database connection string found in RalObject.');
    }

    final localRepo = await createLocalRalRepository(databaseConnectionStr);

    //Update the local file, if the own RalObject has changed in the local database
    if (updateLocalFile) {
      await _updateLocalFile(
        repo: localRepo,
        ralObject: _ralObject!,
      );
    }

    final downstreamDiscovery = Discovery(
      ralRepository: localRepo,
      rootNodeRalType: localTopNoteRalType,
      primaryDiscoveryDimension: DiscoveryDimension.containerId,
      startObject: _ralObject!,
      discoveryDimensions: [
        DiscoveryDimension.containerId,
        DiscoveryDimension.owner,
      ],
    );

    // print("Starting downstream discovery...");

    final downstreamTopNode = await downstreamDiscovery.execute();

    // print("Found ${downstreamTopNode.allChildren().length} local RalObjects + top node.");

    final remoteDatabaseConnectionUID = _ralObject!.specificProperties.remoteDatabaseConnectionUID;

    if (remoteDatabaseConnectionUID == null) {
      // print("INFO: Skipping upstream discovery, because no 'remoteDatabaseConnectionUID' could be found.");

      return BootSequenceResult(
        localTopNode: downstreamTopNode,
        remoteTopNode: null,
      );
    } else {
      //3. What can others do? / Upstream Discovery

      try {
        FirebaseConnectorRalObject remoteRalObject = await _getRemoteConnectionRalObject(
          localRepo,
          remoteDatabaseConnectionUID,
        );

        final remoteRalRepository = await createRemoteRalRepository(remoteRalObject.specificProperties);

        // print("Starting upstream discovery...");

        final upstreamDiscovery = Discovery(
          ralRepository: remoteRalRepository,
          rootNodeRalType: remoteTopNoteRalType,
          primaryDiscoveryDimension: DiscoveryDimension.containerId,
          startObject: _ralObject!,
          discoveryDimensions: [
            DiscoveryDimension.containerId,
            DiscoveryDimension.owner,
          ],
        );

        final upstreamTopNode = await upstreamDiscovery.execute();

        // print("Found ${upstreamTopNode.allChildren().length} remote RalObjects + top node.");

        return BootSequenceResult(
          localTopNode: downstreamTopNode,
          remoteTopNode: upstreamTopNode,
        );
      } catch (e) {
        print("Skipping remote discovery because of error: $e");

        return BootSequenceResult(
          localTopNode: downstreamTopNode,
          remoteTopNode: null,
        );
      }
    }
  }

  Future<void> _updateLocalFile({
    required SoftwareComponentRalObject ralObject,
    required RalObjectRepository repo,
  }) async {
    final updatedObject = await repo.getByUid(ralObject.identity.uid);

    final file = File(localFilePath);

    await file.writeAsString(
      jsonEncode(
        updatedObject.toMap(),
      ),
    );
  }

  Future<FirebaseConnectorRalObject> _getRemoteConnectionRalObject(
    RalObjectRepository repository,
    String remoteDatabaseConnectionUID,
  ) async {
    final object = await repository.getByUid(
      remoteDatabaseConnectionUID,
      specificPropertiesTransform: FirebaseConnectorSpecificProperties.fromSpecificProperties,
    );

    return object.transformTo<FirebaseConnectorSpecificProperties>(
        (specificProperties) => FirebaseConnectorSpecificProperties.fromSpecificProperties(specificProperties));
  }
}
