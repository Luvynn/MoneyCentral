import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:awesomeapp/scoped_models/main.dart';
import 'package:awesomeapp/models/category.dart';
import 'package:awesomeapp/models/expense.dart';

class EditExpense extends StatefulWidget {
  final Expense expense;

  EditExpense(this.expense);

  @override
  State<StatefulWidget> createState() => _EditExpenseState();
}

class _EditExpenseState extends State<EditExpense> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _categoryVal;
  late Map<String, dynamic> _formData;

  @override
  void initState() {
    super.initState();
    _categoryVal = widget.expense.category.isEmpty ? "0" : widget.expense.category;
    _formData = {
      "title": widget.expense.title,
      "amount": (double.parse(widget.expense.amount) / 100).toStringAsFixed(2),
      "createdAt": DateTime.fromMillisecondsSinceEpoch(int.parse(widget.expense.createdAt)).millisecondsSinceEpoch,
      "note": widget.expense.note ?? '',
    };
  }

  Widget _buildTitleField() {
    return Card(
      clipBehavior: Clip.none,
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child: TextFormField(
        initialValue: _formData['title'],
        validator: (value) => value!.isEmpty ? "Please enter a title for your expense" : null,
        onSaved: (value) => _formData["title"] = value!,
        decoration: _inputDecoration("Title", "Title"),
      ),
    );
  }

  Widget _buildAmountField(String currency) {
    return Card(
      clipBehavior: Clip.none,
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child: TextFormField(
        initialValue: _formData['amount'],
        decoration: _inputDecoration("Amount", "$currency "),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        onSaved: (value) => _formData["amount"] = value!,
        validator: (value) {
          if (value!.isEmpty) {
            return "An amount is required.";
          }
          if (!RegExp(r"^\d+\.?\d{0,2}$").hasMatch(value)) {
            return "Please enter a valid amount";
          }
          return null;
        },
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, String prefixText) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(30.0)),
      hintText: hint,
      hintStyle: TextStyle(fontWeight: FontWeight.w600),
      prefixText: prefixText,
      filled: true,
      fillColor: isLightTheme ? Colors.white : Colors.grey[600],
    );
  }

  Widget _buildCategorySelector(List<Category> categories) {
    List<Category> output = [Category("0", "None")];
    output.addAll(categories);
    return Card(
      clipBehavior: Clip.none,
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child: DropdownButtonFormField<String>(
        value: _categoryVal,
        items: output.map<DropdownMenuItem<String>>((Category category) {
          return DropdownMenuItem<String>(
            value: category.id,
            child: Text(category.name),
          );
        }).toList(),
        onChanged: (value) => setState(() => _categoryVal = value!),
        decoration: _inputDecoration("Select Category (optional)", ""),
      ),
    );
  }

  Widget _showDateOption() {
    return Card(
      clipBehavior: Clip.none,
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child: MaterialButton(
        minWidth: 100,
        child: Text("Date"),
        onPressed: () async {
          final DateTime? date = await showDatePicker(
            context: context,
            initialDate: DateTime.fromMillisecondsSinceEpoch(_formData["createdAt"]),
            firstDate: DateTime(2000),
            lastDate: DateTime(3000),
          );
          if (date != null) {
            setState(() {
              _formData["createdAt"] = date.millisecondsSinceEpoch;
            });
          }
        },
      ),
    );
  }

  _buildNoteField() {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    return Card(
      clipBehavior: Clip.none,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: TextFormField(
        initialValue: _formData['note'],
        onSaved: (value) => _formData["note"] = value?? '',
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 20.0,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(30.0),
          ),
          hintText: "Note",
          hintStyle: TextStyle(
            fontWeight: FontWeight.w600,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          prefix: Text("  "),
          filled: true,
          fillColor: isLightTheme ? Colors.white : Colors.grey[600],
        ),
        maxLines: 5,
      ),
    );
  }

  _buildSaveButton(Function editExpense) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: isLightTheme
            ? Theme.of(context).colorScheme.secondary
            : Colors.grey[800],
      ),
      child: MaterialButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            String category = _categoryVal == "0" ? "" : _categoryVal;
            await editExpense(
                accno: _formData["title"],
                deposits: _formData['amount'],
                withdrawls: _formData['createdAt'],
                balance: _formData['note'],
                bankName: category,
                context: context,
                term: widget.expense.key);

            Navigator.of(context).pop();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.check,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Save Expense",
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildCancelButton() {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: isLightTheme
            ? Theme.of(context).colorScheme.secondary
            : Colors.grey[800],
      ),
      child: MaterialButton(
        minWidth: 150,
        onPressed: () => Navigator.of(context).pop(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.cancel,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Cancel",
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildForm(MainModel model) {
    return Container(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              _buildTitleField(),
              SizedBox(
                height: 10,
              ),
              _buildAmountField(model.userCurrency?? ''),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildCategorySelector(model.allCategories),
                  SizedBox(
                    width: 15.0,
                  ),
                  _showDateOption(),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              _buildNoteField(),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildSaveButton(model.editExpense),
                  _buildCancelButton(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLightTheme = Theme.of(context).brightness == Brightness.light;

    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget? child, MainModel model) {
        return Scaffold(
          backgroundColor: isLightTheme ? Colors.grey[100] : Colors.grey[900],
          body: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: isLightTheme ? Theme.of(context).colorScheme.secondary : Theme.of(context).primaryColorLight,
                  expandedHeight: 80,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 30),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Edit Expense", style: TextStyle(
                              color: Colors.white,
                              fontSize: 40.0,
                              fontWeight: FontWeight.w500,
                            ),),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([_buildForm(model)]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
