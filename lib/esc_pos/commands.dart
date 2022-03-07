// ignore_for_file: constant_identifier_names

import 'dart:typed_data';

import 'package:tuple/tuple.dart';


const ESC = 0x1B;
const FF = 0x0C;
const SO = 0x0E;
const LF = 0x0A;
const CR = 0x0D;
const HT = 0x09;
const GS = 0x1D;
const FS = 0x1C;
const US = 0x1F;
const DLE = 0x10;
const CAN = 0x18;
const SI = 0x0F; // set upside down printing
const DC2 = 0x12; // cancel upside down
const DC4 = 0x14; // cancel upside down
const DEL = 0x7F;
const RS = 0X1E;

final commands = [
  ESC,
  FF,
  SO,
  LF,
  CR,
  HT,
  GS,
  FS,
  US,
  DLE,
  CAN,
  SI,
  DC2,
  DC4,
  DEL
];

final fullCommands = <List<int>, int>{
  [HT]: 0,
  [LF]: 0,
  [FF]: 0, // print and recover to page mode
  [CR]: 0, // carriage return
  [SO]: 0,
  [DEL]: 0,
  [CAN]: 0, // cancel print data in page mode
  [DC4]: 0, // Cancel expanded wide
  [DLE, 0x04]: 1, // DLE EOT n - real time status transmission
  [DLE, 0x05]: 1, // DLE ENQ n - real-time request to printer
  [DLE, 0x14]: 3, // DLE DC4 n m t - Real time output of specified pulse
  [ESC, FF]: 0, // Print data in page mode
  [ESC, DC4]: 0, // cancel expanded high
  [ESC, SO]: 0, // set double high
  [ESC, 0x20]: 1, // ESC SP n - set character right space amount
  [ESC, 0x21]: 1, // ESC ! n - Batch specify print mode
  const [ESC, 0x24]: 2, // ESC $ nL nH - Specify absolute position
  [ESC, 0x25]: 1, // ESC % n - Specify / cancel download character set
  [ESC, 0x26]: 1, // ESC & y
  [ESC, 0x2A]: 3, // ESC * m nL nH d1...dk - specify bit image mode
  [ESC, 0x2D]: 1, // ESC - n - specify/cancel underline
  [ESC, 0x32]: 0, // ESC 2 - set default line spacing
  [ESC, 0x33]: 1, // ESC 3 n - set line feed amount
  [ESC, 0x3D]: 1, // ESC = n - select peripheral device
  [ESC, 0x3F]: 1, // ESC ? n - delete dpwnload characters
  const [ESC, 0x40]: 0, //ESC @ - initialize printer
  [ESC, 0x44, 0x00]: 0, // ESC D NUL - cancel all horizontal tab position
  [ESC, 0x44]: 0, // ESC D n1...nk - set horizontal tab positions
  [ESC, 0x45]: 1, //ESC E n - specify/cancel emphasized characters
  [ESC, 0x47]: 1, // ESC G n - Specify/cancel double printing
  [ESC, 0x4A]: 1, // ESC J n - Print and paper feed
  [ESC, 0x4C]: 0, // ESC L - switch to page mode
  [ESC, 0x52]: 1, // ESC R n - select international characters
  [ESC, 0x53]: 0, // ESC S - Switch to standard mode
  [ESC, 0x54]: 1, // ESC T n - Select character print direction in page mode
  [ESC, 0x56]: 1, // ESC V n - Specify/cancel char. 90 deg. clockwise rotation
  [ESC, 0x57]: 8, // ESC W xL xH yL yH dxL dxH dyL dyH - Set print region
  [ESC, 0x5C]: 2, // ESC \ nL nH -Specify relative position
  [ESC, 0x61]: 1, // ESC a n - Position alignment
  [ESC, 0x63, 0x33]: 1, // ESC c 3 n
  [ESC, 0x63, 0x34]: 1, // ESC c 4 n
  [ESC, 0x63, 0x35]: 1, // ESC c 5 n - Enable/disable panel switches
  [ESC, 0x64]: 1, // ESC d n - print and feed paper n lines
  [ESC, 0x70]: 3, // ESC p m t1 t2 - Specify pulse, open drawer
  [ESC, 0x74]: 1, // ESC t n - Select character code table
  [ESC, 0x7B]: 1, // ESC { n -specify/cancel upside-down printing
  [ESC, 0x4D]: 1, // ESC M n - Set character font based on n
  [ESC, RS, 0X46]: 1, // ESC RS F n - Select font
  [ESC, RS, 0x4C]: 1, // ESC RS L m - Spec. A print logo in batch
  [ESC, RS, 0x64]: 1, // ESC RS d n - Set print density
  [ESC, RS, 0x72]: 1, // ESC RS r n - Set print speed
  [ESC, RS, 0x61]: 1, // ESC RS a n - Set status transmission conditions
  [ESC, RS, 0x45]: 1, // ESC RS E n - Init ASB ETB counter and ETB status
  [ESC, RS, 0x63]: 1, // ESC RS c n - Set print color in 2 color print mode
  [ESC, RS, 0x43]: 1, // ESC RS C n - Set/cancel 2 color print mode
  [ESC, RS, 0x43]: 1, // ESC RS C n - Set/cancel 2 color print mode
  [FS]: 0,
  [FS, 0x79]: 2, // FS y - Print graphic blank logo
  [ESC, 0xFA]: 5, // ESC 0xFA n xH xL yH yL
  [ESC, FS, 0x70]: 2, // ESC FS p n m - print logo
  [ESC, FS, 0x71]: 1, // ESC FS q n .... - Register logo
  [FS, 0x67, 0x31]: 5, // FS g 1 m a1 a2 a3 a4 nL nH d1...dk
  [FS, 0x67, 0x32]: 7, // FS g 2 m a1 a2 a3 a4 nL nH
  [FS, 0x70]: 2, // FS p n m - Print NV bit image
  [FS, 0x71]: 1, // FS q n - define nv bit image
  [GS, 0x21]: 1, // GS ! n - Select character size
  [GS, 0x24]: 2, // GS $ nL nH
  [GS, 0x2A]: 1, // GS * x yd(xXyX8)
  [GS, 0x28, 0x41]: 4, // GS ( A pL pH n m - Test print
  [GS, 0x28, 0x4B]: 4, // GS ( K pL pH fn m - set print density
  [GS, 0x28, 0x4C]: 4, // GS ( L pL pH m fn
  [GS, 0x28, 0x4C]: 4, // GS 8 L p1 p2 p3 p4
  [GS, 0x38, 0x4C]: 6, // GS 8 L p1 p2 p3 p4 m fn
  [GS, 0x2F]: 1, // GS / m - print download bit images
  [GS, 0x3A]: 0, // GS : - start macro defn.
  [GS, 0x42]: 1, // GS B n - specify/cancel white/black inverted printing
  [GS, 0x43, 0x30]: 2, // GS C O n m - Set counter print mode
  [GS, 0x43, 0x31]: 6, // GS C 1 aL aH bL bH n r - Set counter mode (A)
  [GS, 0x43, 0x32]: 2, // GS C 2 nL nH - Set counter mode value
  [GS, 0x43, 0x3B]: 10, // GS C ; sa ; sb ; sn ; sr ; sc ; - Set counter mode(B)
  [GS, 0x45]: 1, // GS E n - Set printing speed
  [GS, 0x48]: 1, // GS H n - Select HRI character print position
  [GS, 0x49]: 1, // GS I n - Transmission of printer id
  [GS, 0x4C]: 2, // GS L nL nH - Set left margin
  [GS, 0x50]: 2, // GS P x y - Set basis calculation pitch
  [GS, 0x54]: 1, // GS T n - move to top of line
  [GS, 0x56]: 1, // GS V m - Cut paper
  [GS, 0x56, 65]: 1, // GS V m=65 n - Cut paper (specify feed)
  [GS, 0x56, 66]: 1, // GS V m=66 n
  [GS, 0x57]: 2, // GS W nL nW - Set print region width
  [GS, 0x5C]: 2, // GS \ nL nH
  [GS, 0x5E]: 3, // GS ^ r t m - Execute macro
  [GS, 0x62]: 1, // GS b n - Specify or cancel smoothing
  [GS, 0x63]: 0, // GS c - Print counter
  [GS, 0x66]: 1, // GS f n - Set HRI character font
  [GS, 0x68]: 1, // GS h n - Set bar code height
  [GS, 0x6B]: 0, // GS k NUL - print bar code command. Has multiple args
  [GS, 0x6B, 0x00]: 0, // GS k NUL - clear print bar code command
  [GS, 0x72]: 1, // GS r n - Transmission of status
  const [GS, 0x76, 0x30]: -1, // GS v O m xL xH yL yH ... - Print raster bit images
  [GS, 0x77]: 1, // GS w n - set bar code horizontal size
  [US]: 0, // unknown
  [SI]: 0, // set upside down
  [DC2]: 0,
};

/// Extracts the arg len and data length for commands that take variable length args
/// e.g printing barcodes and raster images
/// [offset] is the first index after the end of the command bytes
/// [buffer] is a subview of the print buffer offset to the start of the argument bytes
typedef DataLenGenerator = Tuple2<int, int> Function(ByteData buffer, int offset);

final variableArgCommands = <List<int>, DataLenGenerator>{
  // GS v 0 m xL xH yL yH d1...dk
  const [GS, 0x76, 0x30]: (ByteData buffer, int offset) {
    final argLen = 5;
    final argBytes = buffer.buffer.asUint8List(offset, argLen);
    final m = argBytes[0],
        xL = argBytes[1],
        xH = argBytes[2],
        yL = argBytes[3],
        yH = argBytes[4];
    // k = (xL + (xH * 256))
    final dataLen = (xL + (xH * 256)) * (yL + (yH * 256));
    return Tuple2(argLen, dataLen);
  }, // GS v O m xL xH yL ... - Print raster bit images
};
