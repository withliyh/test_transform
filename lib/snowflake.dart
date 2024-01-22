import 'dart:math';

///1- 000000000000000000000000000000000000 - 00000000 - 00000000
///1+36+8+8 = 53
//////js只有 53bit有效
///1 - 36bit stamp - hostid - seq
///

extension CTB on int {
  BigInt toBigInt() {
    return BigInt.from(this);
  }
}

class BigIntTinySnowflakeIdWorker {
  /**
     * 开始时间截 (2015-01-01)
     */
  static BigInt twepoch = 1420041600000.toBigInt();

  static const int bigest = 1; //

  //时间戳所占位数
  static BigInt timestampBits = 36.toBigInt();
  static BigInt timestampMask = 0xFFFFFFFFF.toBigInt(); //36个bit
  static const int timestampLeftShift = 16;

  /**
     * 机器id所占的位数
     */
  static BigInt workerIdBits = 8.toBigInt();
  static BigInt workerIdMask = 0xFF.toBigInt();
  static const int workerIdShift = 8;

  /**
     * 序列在id中占的位数
     */
  static BigInt sequenceBits = 8.toBigInt();
  static BigInt sequenceMask = 0xFF.toBigInt(); //8个bit
  static const int sequenceShift = 0;

  BigIntTinySnowflakeIdWorker() {
    final random = DateTime.now().millisecondsSinceEpoch;
    workerId = Random(random).nextInt(0xFF).toBigInt();
  }

  /**
     * 工作机器ID(0-2^8)
     */
  BigInt workerId = 0.toBigInt();

  /**
     * 毫秒内序列(0~2^8)
     */
  BigInt sequence = 0.toBigInt();
  /**
     * 上次生成ID的时间截
     */
  BigInt lastTimestamp = 0.toBigInt();

/**
     * 获得下一个ID (该方法是线程安全的)
     * @return SnowflakeId
     */
  BigInt nextId() {
    BigInt timestamp = timeGen();
    // 如果当前时间小于上一次ID生成的时间戳，说明系统时钟回退过这个时候应当抛出异常
    if (timestamp < lastTimestamp) {
      throw Exception(
          "Clock moved backwards.  Refusing to generate id for %d milliseconds");
    }
    // 如果是同一时间生成的，则进行毫秒内序列
    if (lastTimestamp == timestamp) {
      sequence = (sequence + 1.toBigInt()) & sequenceMask;
      // 毫秒内序列溢出
      if (sequence == 0.toBigInt()) {
        //阻塞到下一个毫秒,获得新的时间戳
        timestamp = tilNextMillis(lastTimestamp);
      }
    }
    // 时间戳改变，毫秒内序列重置
    else {
      sequence = 0.toBigInt();
    }
    // 上次生成ID的时间截
    lastTimestamp = timestamp;
    // 移位并通过或运算拼到一起组成53位的ID
    final timeField =
        ((timestamp - twepoch) & timestampMask) << timestampLeftShift;
    final workerField = (workerId & workerIdMask) << workerIdShift;
    final sequenceField = (sequence & sequenceMask) << sequenceShift;
    final finalid = timeField | workerField | sequenceField;
    return finalid;
  }

  /**
     * 返回以毫秒为单位的当前时间
     * @return 当前时间(毫秒)
     */
  BigInt timeGen() {
    final time = DateTime.now().millisecondsSinceEpoch;
    return time.toBigInt();
  }

/**
     * 阻塞到下一个毫秒，直到获得新的时间戳
     * @param lastTimestamp 上次生成ID的时间截
     * @return 当前时间戳
     */
  BigInt tilNextMillis(BigInt lastTimestamp) {
    BigInt timestamp = timeGen();
    while (timestamp <= lastTimestamp) {
      timestamp = timeGen();
    }
    return timestamp;
  }
}
