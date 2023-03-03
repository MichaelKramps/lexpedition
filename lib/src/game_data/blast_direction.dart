enum BlastDirection { vertical, horizontal }

BlastDirection? determineBlastDirection(int? index) {
  if (index == null) {
    return null;
  } else if (index == 0) {
    return BlastDirection.vertical;
  } else {
    return BlastDirection.horizontal;
  }
}
