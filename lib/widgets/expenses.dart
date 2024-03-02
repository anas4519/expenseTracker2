import 'package:expense_tracker2/widgets/chart/chart.dart';
import 'package:expense_tracker2/widgets/expenses-list/expense_item.dart';
import 'package:expense_tracker2/widgets/expenses-list/expenses_list.dart';
import 'package:expense_tracker2/models/expense.dart';
import 'package:expense_tracker2/widgets/new_expense.dart';
import 'package:flutter/material.dart';


class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpenseState();
  }
}

class _ExpenseState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(title: "Flutter Course", amount: 19.99, date: DateTime.now(), category: Category.work),
    Expense(title: "Snacks", amount: 19.99, date: DateTime.now(), category: Category.leisure),

  ];
  void _openAddExpenseOverlay(){
    showModalBottomSheet(context: context, builder: (ctx) => NewExpense(onAddExpense: _addExpense,), isScrollControlled: true,
    useSafeArea: true
    );
  }

  void _addExpense(Expense expense){
    setState(() {
      _registeredExpenses.add(expense);
    });
    
  }

  void _removeExpense(Expense expense){
    int expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense deleted'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(label:  'Undo', onPressed: (){
          setState(() {
            _registeredExpenses.insert(expenseIndex, expense);
          });
        }),
      )
    );
  }
  @override
  Widget build(BuildContext context) {
   final width = (MediaQuery.of(context).size.width);
    
    Widget mainContent = const Center(child: Text('No expenses found. Start adding some!'),);
    if(_registeredExpenses.isNotEmpty){
      mainContent = ExpensesList(expenses: _registeredExpenses, onRemoveExpense: _removeExpense,);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xpense'),
        actions: [
          IconButton(
          onPressed: _openAddExpenseOverlay,
          icon: const Icon(Icons.add))
        ],
        
        // backgroundColor: const Color.fromARGB(255, 55, 108, 187),
      ),

      body: width< 600 ? Column(
        children: [Chart(expenses: _registeredExpenses),
        Expanded(child: mainContent,)
          
          ],
      )
       : Row(
        children: [Expanded(child: Chart(expenses: _registeredExpenses)),
        Expanded(child: mainContent,)],
      ),
    );
  }
}
