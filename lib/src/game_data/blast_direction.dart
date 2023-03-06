enum BlastDirection { vertical, horizontal }

BlastDirection? determineBlastDirection(num? index) {
  if (index == null) {
    return null;
  } else if (index == 0) {
    return BlastDirection.vertical;
  } else {
    return BlastDirection.horizontal;
  }
}
