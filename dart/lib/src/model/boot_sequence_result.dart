import 'package:openral_core/openral_core.dart';

class BootSequenceResult {
  ///result of the discovery on the local datasource
  final GraphNode localTopNode;

  ///result of the discovery on the remote datasource
  ///is null, if no remote connection is available
  final GraphNode? remoteTopNode;

  BootSequenceResult({
    required this.localTopNode,
    this.remoteTopNode,
  });
}
