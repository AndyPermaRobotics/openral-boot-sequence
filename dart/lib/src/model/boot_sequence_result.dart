import 'package:openral_core/openral_core.dart';

class BootSequenceResult {
  ///result of the discovery on the local datasource
  final GraphNode localTopNode;

  ///result of the discovery on the remote datasource
  ///is null, if no remote connection is available
  final GraphNode? remoteTopNode;

  final RalObjectRepository localRepository;

  ///the remote repository is null, if no remote connection is available
  final RalObjectRepository? remoteRepository;

  //the RalObject that represents the currently running software component
  final RalObject thisRalObject;

  BootSequenceResult({
    required this.localTopNode,
    this.remoteTopNode,
    required this.localRepository,
    this.remoteRepository,
    required this.thisRalObject,
  });
}
