import 'package:openral_flutter/discovery/graph_node.dart';

class BootSequenceResult {
  ///result of the downstream discovery on the local datasource
  final GraphNode downstreamTopNode;

  ///result of the upstream discovery on the remote datasource
  ///is null, if no remote connection is available
  final GraphNode? upstreamTopNode;

  BootSequenceResult({
    required this.downstreamTopNode,
    this.upstreamTopNode,
  });
}
