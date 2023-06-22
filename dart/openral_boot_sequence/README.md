# openRAL Boot Sequence

Dart Example implementation of a boot sequence for a software component, that loads it's own environment as a graph of RalObjects.

See [here](https://github.com/AndyPermaRobotics/openral-boot-sequence/tree/develop) for more informations about the behaviour of the boot sequence. 


## Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  openral_flutter: 
    git: 
        url: git@github.com:AndyPermaRobotics/openral-boot-sequence.git
        path: dart/openral_boot_sequence
```

## Usage

See test/src/open_ral_boot_sequence_test.dart for an example of how to use this package.

The package also includes the `FirebaseConnectorRalObject` or `SoftwareComponentRalObject` that provide easy access to the SpecificProperties of those RALTypes.

