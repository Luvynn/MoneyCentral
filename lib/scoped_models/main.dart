import 'package:scoped_model/scoped_model.dart';
import 'package:awesomeapp/scoped_models/combined_model.dart';

class MainModel extends Model with CombinedModel, UserModel, ExpensesModel, SavingsAccModel, DepositsAccModel, CCExpensesModel, CreditCardsModel, FilterModel{}

