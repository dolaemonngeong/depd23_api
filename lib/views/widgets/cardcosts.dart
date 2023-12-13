part of 'widgets.dart';

class CardCosts extends StatefulWidget {
  final Costs costs;
  const CardCosts(this.costs);

  @override
  State<CardCosts> createState() => _CardCostsState();
}

class _CardCostsState extends State<CardCosts> {
  @override
  Widget build(BuildContext context) {
    Costs c = widget.costs;
    print(c);
    return Card(
      color: Color(0xFFFFFFFF),
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        title: Text("${c.description} (${c.service})"),
        subtitle: Column(
          children: [
            Text("Biaya: Rp. ${c.cost?[0].value},00"),
            Text("Estimasi Sampai: ${c.cost?[0].etd} hari"),
          ],
        ),
      ),
    );
  }
}
