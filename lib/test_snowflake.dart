import 'package:flutter/material.dart';
import "dart:math";
import 'snowflake.dart';

// Set<int> ids = {};
Set<BigInt> bids = {};
final maxValue = pow(2, 53);

class TestSnowFlakeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final snowflake = BigIntTinySnowflakeIdWorker();
        print("start");
        for (int jj = 0; jj < 10000; jj++) {
          print("$jj");
          for (int i = 0; i < 5000; i++) {
            final id = snowflake.nextId();
            if (bids.contains(id)) {
              assert(false);
            }
            bids.add(id);

            final iid = id.toInt();
            final same = id.compareTo(iid.toBigInt());
            assert(iid <= maxValue);
            assert(same == 0);
          }
        }

        print("end:${bids.length}");
      },
      child: SizedBox.expand(child: ColoredBox(color: Colors.red)),
    );
  }
}
