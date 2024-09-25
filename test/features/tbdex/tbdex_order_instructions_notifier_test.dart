import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:didpay/features/tbdex/tbdex_order_instructions_notifier.dart';
import 'package:didpay/features/pfis/pfi.dart';

class MockPfi extends Mock implements Pfi {}

void main() {
  late TbdexOrderInstructionsNotifier notifier;
  late MockPfi mockPfi;

  setUp(() {
    mockPfi = MockPfi();
    notifier = TbdexOrderInstructionsNotifier();
  });

  test('should initialize with provided PFI', () async {
    expect(notifier, isA<TbdexOrderInstructionsNotifier>());
  });

  // Add more tests here to stress-test TbdexOrderInstructionsNotifier
}
