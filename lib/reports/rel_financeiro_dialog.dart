import 'package:flutter/material.dart';
import 'package:marmi_app/reports/financeiro_report.dart';

class RelFinanceiroDialog extends StatefulWidget {
  @override
  _RelFinanceiroDialogState createState() => _RelFinanceiroDialogState();
}

class _RelFinanceiroDialogState extends State<RelFinanceiroDialog> {
  int _groupValue = 7;
  bool _geraReceita = true;
  bool _geraDespesa = true;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text("Selecione um Período"),
      children: <Widget>[
        Column(
          children: <Widget>[
            _myRadioButton(
              title: "7 dias",
              value: 7,
              onChanged: (newValue) => setState(() => _groupValue = newValue),
            ),
            _myRadioButton(
              title: "15 dias",
              value: 15,
              onChanged: (newValue) => setState(() => _groupValue = newValue),
            ),
            _myRadioButton(
              title: "30 dias",
              value: 30,
              onChanged: (newValue) => setState(() => _groupValue = newValue),
            ),
            _myRadioButton(
              title: "Todo Movimento",
              value: 9999,
              onChanged: (newValue) => setState(() => _groupValue = newValue),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _myCheckBox(
                  title: "Receitas",
                  value: _geraReceita,
                  onChanged: (newValue) =>
                      setState(() => _geraReceita = newValue),
                ),
                _myCheckBox(
                  title: "Despesas",
                  value: _geraDespesa,
                  onChanged: (newValue) =>
                      setState(() => _geraDespesa = newValue),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                OutlineButton(
                  child: Text("Continuar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    financeiroReport(_groupValue, _geraReceita, _geraDespesa);
                  },
                ),
                OutlineButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget _myRadioButton({String title, int value, Function onChanged}) {
    return RadioListTile(
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
      title: Text(
        title,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _myCheckBox({String title, bool value, Function onChanged}) {
    return FilterChip(
      selected: value,
      onSelected: onChanged,
      label: Text(
        title,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
} //fim de tudo
