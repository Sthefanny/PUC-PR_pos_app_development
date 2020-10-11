enum UnitMeaEnum {
  unit,
  weight,
}

String unitMeaEnumToStr(UnitMeaEnum unitMeaEnum) {
  switch (unitMeaEnum) {
    case UnitMeaEnum.unit:
      return 'Unidade(s)';
      break;
    case UnitMeaEnum.weight:
      return 'Grama(s)';
      break;
    default:
      return '';
  }
}
