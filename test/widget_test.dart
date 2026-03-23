import 'package:flutter_test/flutter_test.dart';
import 'package:quenote/features/sequence/domain/enums/side_type.dart';

void main() {
  test('SideType has four options for cue flow', () {
    expect(SideType.values.length, 4);
    expect(SideType.values, contains(SideType.both));
  });
}
