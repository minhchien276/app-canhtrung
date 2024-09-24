enum PhaseEnum {
  none,
  trung,
  antoan,
  thai,
  sua,
  vithanhnien;

  static PhaseEnum getPhase(int? phase) {
    switch (phase) {
      case 1:
        return PhaseEnum.trung;
      case 2:
        return PhaseEnum.antoan;
      case 3:
        return PhaseEnum.thai;
      case 4:
        return PhaseEnum.sua;
      case 5:
        return PhaseEnum.vithanhnien;
      case null:
        return PhaseEnum.none;
      default:
        return PhaseEnum.none;
    }
  }

  toInt() {
    switch (this) {
      case PhaseEnum.trung:
        return 1;
      case PhaseEnum.antoan:
        return 2;
      case PhaseEnum.thai:
        return 3;
      case PhaseEnum.sua:
        return 4;
      case PhaseEnum.vithanhnien:
        return 5;
      default:
        return 0;
    }
  }

  //user must enter data in these phases to go home
  bool mustSaveData() {
    switch (this) {
      case PhaseEnum.trung:
      case PhaseEnum.antoan:
      case PhaseEnum.vithanhnien:
      case PhaseEnum.none:
        return true;
      default:
        return false;
    }
  }

  bool isMainPhase() {
    switch (this) {
      case PhaseEnum.trung:
      case PhaseEnum.antoan:
      case PhaseEnum.vithanhnien:
        return true;
      default:
        return false;
    }
  }
}
