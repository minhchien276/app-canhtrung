enum TestResultEnum {
  thap,
  cao,
  datdinh,
}

TestResultEnum checkTestResult(double res) {
  if (res < 35) {
    return TestResultEnum.thap;
  } else if (res <= 45) {
    return TestResultEnum.cao;
  } else {
    return TestResultEnum.datdinh;
  }
}

const aspectThap = 0.4375;
const aspectCao = 0.1875;
const aspectDatdinh = 0.3125;
