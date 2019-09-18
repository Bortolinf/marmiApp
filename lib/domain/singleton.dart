class AppData {
  static final AppData _appData = new AppData._internal();
  
  String uid = "";
  String wtlopc  = "";
  String wtlCliId = "";
  String wtlCliNom = "";
  String wtlCliEnd = "";
  String wtlCliTel = "";
  String wtlCliObs = "";
  int wtlCliPess = 0;
  double wtlSaldoAtu = 0.0;

  String wtlPrdId = "";
  String wtlPrdDsc = "";
  double wtlPrdVlr = 0.0;

  String wtlDespId = "";
  String wtlDespDsc = "";
  String wtlDespData = "";
  double wtlDespVlr = 0.0;
  double wtlTotDesp = 0.0;

  String wtlFiltroFin = "7";
  String wtlRecId = "";
  String wtlRecDsc = "";
  String wtlRecCli = "";
  String wtlRecCliNome = "";
  String wtlRecData = "";
  double wtlRecVlr = 0.0;
  double wtlTotRec = 0.0;

  Map<String,List<dynamic>> wtlDiasSel = {};    // Map();
  Map<String,List<dynamic>> wtlDiasRec = {};    // Map();
  String wtlMesAno = "";


  factory AppData() {
    return _appData;
  }
  AppData._internal();
}
final appData = AppData();